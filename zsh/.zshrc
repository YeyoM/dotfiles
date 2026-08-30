# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Autocomplete bindings
bindkey '\t\t' autosuggest-accept # double tab to accept suggestion

source "$ZSH/oh-my-zsh.sh"

alias ls='eza --icons --color=always --group-directories-first'
alias ll='eza -alF --icons --color=always --group-directories-first'
alias la='eza -a --icons --color=always --group-directories-first'
alias l='eza -F --icons --color=always --group-directories-first'
alias l.='eza -a | egrep "^\."'
alias bat='batcat'

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.spicetify"
export PATH="$PATH:$HOME/rofi-bluetooth"
export PATH="$PATH:$HOME/Zen/zen-specific.AppImage"

# zsh-syntax-highlighting (single source, installed via apt)
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Set up fzf key bindings and fuzzy completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export BAT_THEME="gruvbox-dark"
export FZF_CTRL_T_OPTS="--preview 'batcat -n --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "batcat -n --color=always --line-range :500 {}" "$@" ;;
  esac
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/home/yeyo/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
