# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it"s not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
# zinit light Aloxaf/fzf-tab
zinit light starship/starship

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Plugin individual settings
PLUGIN_FOLDER="$HOME/.config/zsh/plugins"

export STARSHIP_CONFIG="${PLUGIN_FOLDER}/starship.toml"
source "${PLUGIN_FOLDER}/syntax-highlighting.zsh"
source "${PLUGIN_FOLDER}/autosuggestions.zsh"

# Keybindings
bindkey -e
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward
bindkey "^[w" kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

setopt AUTO_CD

# Completion styling
zstyle ":completion:*" matcher-list 'm:{a-z}={A-Za-z}'
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
zstyle ":completion:*" menu no
zstyle ":fzf-tab:complete:cd:*" fzf-preview 'ls --color $realpath'
zstyle ":fzf-tab:complete:__zoxide_z:*" fzf-preview 'ls --color $realpath'

alias ls="ls --color"
alias ll="ls -la"
alias vi="nvim"
alias vim="nvim"
alias c="clear"
alias e="exit"
alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias cdD="cd ~/Desktop/"
alias gst="git status"
alias pwoff="poweroff"
alias mer="~/meridius-3.3.5/meridius --no-sandbox > /dev/null 2>&1 &"

# Docker
alias d-c="docker compose"
alias d-cl="docker compose logs -f"

# Tmux
alias tm="tmux"
alias "tmd"="tmux detach-client"

gpf() {
	git add . && git commit -m "$1" && git push origin "${2:-main}"
}

t() {
	touch "$1"
}

player_prev_cmd() {
  playerctl previous
  zle .reset-prompt
  zle -R
}

player_next_cmd() {
  playerctl next
  zle .reset-prompt
  zle -R
}

player_toggle_cmd() {
  playerctl play-pause
  zle .reset-prompt
  zle -R
}

player_vol_up() {
  playerctl volume 0.05+
  zle .reset-prompt
  zle -R
}

player_vol_down() {
  playerctl volume 0.05-
  zle .reset-prompt
  zle -R
}

zle -N player_vol_up
zle -N player_vol_down

zle -N player_prev_cmd
zle -N player_next_cmd
zle -N player_toggle_cmd

bindkey 'p+' player_vol_up
bindkey 'P+' player_vol_up
bindkey 'p-' player_vol_down
bindkey 'P-' player_vol_down
bindkey 'p<' player_prev_cmd
bindkey 'P<' player_prev_cmd
bindkey 'p>' player_next_cmd
bindkey 'P>' player_next_cmd
bindkey 'p||' player_toggle_cmd
bindkey 'P||' player_toggle_cmd

export EDITOR=nvim
export VISUAL=nvim

eval "$(starship init zsh)"
eval "$(fzf --zsh)"
