# locale
export LC_ALL=en_US.UTF-8

# profile
source $HOME/.profile

# compinit
autoload -Uz compinit
compinit -i

# install zplug, if needed
if [[ ! -d "$HOME/.zplug" ]]; then
  git clone https://github.com/zplug/zplug "$HOME/.zplug/repos/zplug/zplug"
  ln -s "$HOME/.zplug/repos/zplug/zplug/init.zsh" "$HOME/.zplug/init.zsh"
  RUN_ZPLUG_INSTALL=1
fi

# load zplug plugin manager
source $HOME/.zplug/init.zsh

# plugins
zplug "zplug/zplug", hook-build:"zplug --self-manage"
zplug "zsh-users/zsh-completions"
zplug "zdharma/fast-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "hlissner/zsh-autopair", defer:2

zplug "philslab/abbr-zsh-theme", as:theme

# start zplug
if [[ -n $RUN_ZPLUG_INSTALL ]]; then
  zplug install
  unset RUN_ZPLUG_INSTALL
fi
zplug load

# history settings
[ -z "$HISTFILE" ] && export HISTFILE=~/.zsh_history
export SAVEHIST=HISTSIZE=20000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST

# key bindings
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[3~" delete-char
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^I" expand-or-complete-prefix

# dynamic terminal title
precmd () {
  print -Pn "\e]0;zsh - %~\a"
}

# other zsh options
setopt GLOB_STAR_SHORT

# completion features
zstyle ':completion:*' rehash true
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# ssh settings
if [[ -n $SSH_CONNECTION ]]; then
  export TERM='xterm-256color'
fi

# add PATH directories
additional_paths=(
  "/usr/local/bin"
  "/usr/local/opt/coreutils/libexec/gnubin"
  "/usr/local/opt/unzip/bin"
)
for add_path in $additional_paths; do
  export PATH="$add_path:$PATH"
done

# ENV: EDITOR / VISUAL
if (( $+commands[nvim] )) ; then
  export VISUAL='nvim'
elif (( $+commands[vim] )) ; then
  export VISUAL='vim'
else
  export VISUAL='vi'
fi

export EDITOR="$VISUAL"

# ENV: cat --> bat
if (( $+commands[bat] )) ; then
  alias cat="bat"
fi

# ENV: SSH_KEY_PATH
export SSH_KEY_PATH="~/.ssh/id_rsa"

# ENV: PAGER
export PAGER="most"
export MANPAGER="$VISUAL -c 'set ft=man' -"

# all the *vi* editors!
alias vi="$VISUAL"
alias vim="$VISUAL"

# in case someone (me) fucked up again...
alias fuck='sudo env "PATH=$PATH" $(fc -ln -1)'

# happens from time to time...
alias :q="exit"

# ls on steroids
if (( $+commands[exa] )) ; then
  alias ls="exa --header --extended --git --group --group-directories-first --color-scale --color=always"
  alias lm="exa --header --long --group --sort=modified --reverse --color always --color-scale"
  alias lt="ls --long --tree --all --ignore-glob .git"
fi

alias ll="ls -l"
alias la="ls -la"

# docker-compose
alias dc="docker-compose"
alias dcr="docker-compose down && docker-compose up -d"

# git
alias gitlog="git log --graph --oneline --decorate --all"

# HTTPie https requests
if (( $+commands[http] )) ; then
  alias https='http --default-scheme=https'
fi

# reload zsh config
alias reload='source $HOME/.zshrc'

# housekeeping (updates, cache cleanup, etc.)
housekeeping () {
  brew upgrade
  brew cask upgrade
  brew cleanup
}

brewdump () {
  local brewdir="$HOME/.config/brew"
  [[ ! -d "$brewdir" ]] && mkdir -p "$brewdir"

  pushd "$brewdir" > /dev/null 2>&1
  brew bundle dump --force --describe
  popd > /dev/null 2>&1
}

# upload to https://0x0.st
0x0 () {
  curl -sf -F "file=@$1" "https://0x0.st" || echo "error uploading $1"
}

# config management with git
dotconf () {
  local cdir="$HOME/.dotconf"

  [[ -d $cdir ]] || mkdir -p $cdir
  [[ -f $cdir/HEAD ]] || git init --bare $cdir

  git --git-dir=$cdir --work-tree=$HOME/ "$@"
}

