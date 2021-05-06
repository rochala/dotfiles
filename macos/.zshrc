source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

fpath+=$HOME/.zsh/pure

export TERM=xterm-256color
export PAGER=less

export EDITOR=nvim
export VISUAL="$EDITOR"

ENABLE_CORRECTION="false"


export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

if command -v dry &> /dev/null; then
    dry 0.0166666666667 > /dev/null
fi

export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

zstyle ':prompt:pure:prompt:*' color red

autoload -U promptinit; promptinit
compinit -U

prompt pure


autoload -U compinit
fpath=($HOME/.bloop/zsh $fpath)
compinit

# Make completion:
# - Try exact (case-sensitive) match first.
# - Then fall back to case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors ''

# Allow completion of ..<Tab> to ../ and beyond.
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

# $CDPATH is overpowered (can allow us to jump to 100s of directories) so tends
# to dominate completion; exclude path-directories from the tag-order so that
# they will only be usedas a fallback if no completions are found.
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

# Categorize completion suggestions with headings: zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %F{default}%B%{$__WINCENT[ITALIC_ON]%}--- %d ---%{$__WINCENT[ITALIC_OFF]%}%b%f

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
zstyle ':completion:*' menu select

# ALIASES

alias ....='cd ../..'
alias :sp='test -n "$TMUX" && tmux split-window'
alias :vs='test -n "$TMUX" && tmux split-window -h'
alias cat='bat --paging=never'
alias :q='exit'
alias :wq='exit'
alias f='find . -name'

alias zshrc='nvim ~/.zshrc'
alias szsh='source ~/.zshrc'
alias vimrc='nvim ~/.config/nvim/init.vim'
alias tmuxrc='nvim ~/.tmux.conf'

alias t='[ -f .tmux ] && sh .tmux || tmux'

# OPTIONS

setopt AUTO_CD                 # [default] .. is shortcut for cd .. (etc)
setopt AUTO_PARAM_SLASH        # tab completing directory appends a slash
setopt AUTO_PUSHD              # [default] cd automatically pushes old dir onto dir stack
setopt AUTO_RESUME             # allow simple commands to resume backgrounded jobs
setopt CLOBBER                 # allow clobbering with >, no need to use >!
setopt CORRECT                 # [default] command auto-correction
setopt CORRECT_ALL             # [default] argument auto-correction
setopt NO_FLOW_CONTROL         # disable start (C-s) and stop (C-q) characters
setopt NO_HIST_IGNORE_ALL_DUPS # don't filter non-contiguous duplicates from history
setopt HIST_FIND_NO_DUPS       # don't show dupes when searching
setopt HIST_IGNORE_DUPS        # do filter contiguous duplicates from history
setopt HIST_IGNORE_SPACE       # [default] don't record commands starting with a space
setopt HIST_VERIFY             # confirm history expansion (!$, !!, !foo)
setopt IGNORE_EOF              # [default] prevent accidental C-d from exiting shell
setopt INTERACTIVE_COMMENTS    # [default] allow comments, even in interactive shells
setopt LIST_PACKED             # make completion lists more densely packed
setopt MENU_COMPLETE           # auto-insert first possible ambiguous completion
setopt NO_NOMATCH              # [default] unmatched patterns are left unchanged
setopt PRINT_EXIT_VALUE        # [default] for non-zero exit status
setopt PUSHD_IGNORE_DUPS       # don't push multiple copies of same dir onto stack
setopt PUSHD_SILENT            # [default] don't print dir stack after pushing/popping
setopt SHARE_HISTORY           # share history across shells

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
export PATH="/Users/rochala/Scripts:$PATH" HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
if command -v dry &> /dev/null; then
    dry 0.0166666666667 > /dev/null
fi

[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export PATH="$PATH:/Users/rochala/Library/Application Support/Coursier/bin"
export PATH="/usr/local/opt/ruby/bin:$PATH"
