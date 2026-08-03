ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Plugin individual settings.
# These only set variables / define widgets, so they are sourced now (before the
# turbo-loaded plugins activate after the first prompt).
PLUGIN_FOLDER="${ZDOTDIR:-$HOME/.config/zsh}/plugins"
# starship reads ~/.config/starship.toml by default — deployed from the
# separate starship repo (see scripts/deploy.sh).
source "${PLUGIN_FOLDER}/syntax-highlighting.zsh"
source "${PLUGIN_FOLDER}/autosuggestions.zsh"
source "${PLUGIN_FOLDER}/man-colors.zsh"
source "${PLUGIN_FOLDER}/git-tools.zsh"
source "${PLUGIN_FOLDER}/fzf-extras.zsh"
source "${PLUGIN_FOLDER}/keyboard-layout.zsh"

# Hooks applied by zinit's `atload` once the relevant plugin has finished loading
# (turbo plugins load after the first prompt, so these run then too).
_apply_hss_binding() {
  bindkey '^p' history-substring-search-up
  bindkey '^n' history-substring-search-down
  bindkey "${terminfo[kcuu1]}" history-substring-search-up
  bindkey "${terminfo[kcud1]}" history-substring-search-down
}

zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

zinit ice wait lucid atload"_apply_hss_binding"
zinit light zsh-users/zsh-history-substring-search

# zicompinit boots the completion system; run it on the last turbo plugin so
# every completion definition (incl. zsh-completions) is registered first.
zinit ice wait lucid atinit"zicompinit; zicdreplay"
zinit light zsh-users/zsh-syntax-highlighting

bindkey -e
bindkey "^[w" kill-region

# Tab = classic, bash-like completion. First Tab fills the longest common
# prefix; a second Tab opens the highlighted zsh menu you cycle with Tab/arrows.
# It NEVER accepts the grey history suggestion — that lives on Ctrl+Space below.
bindkey '^I' expand-or-complete

# Ctrl+X Ctrl+E — open the current command line in $EDITOR (nvim) and run it on
# save. Handy for long or multi-line commands that are awkward to edit inline.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Accept the whole history autosuggestion (the grey ghost text). Tab is reserved
# for directory completion, so accepting the suggestion gets its own key.
# (Right arrow / Ctrl+E still accept it too, via zsh-autosuggestions defaults.)
bindkey '^ ' autosuggest-accept          # Ctrl+Space

# Word movement with Ctrl+Arrow (zsh doesn't bind these out of the box).
# Ctrl+Right also accepts the autosuggestion one word at a time.
bindkey '^[[1;5C' forward-word           # Ctrl+Right
bindkey '^[[1;5D' backward-word          # Ctrl+Left
bindkey '^[[1;3C' forward-word           # Alt+Right  (fallback for some terms)
bindkey '^[[1;3D' backward-word          # Alt+Left
bindkey '^[Oc'    forward-word           # Ctrl+Right (xterm/rxvt variants)
bindkey '^[Od'    backward-word
bindkey '^[[5C'   forward-word
bindkey '^[[5D'   backward-word
bindkey '^H'      backward-kill-word     # Ctrl+Backspace (delete word back)

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt sharehistory
setopt inc_append_history
setopt extended_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_reduce_blanks

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt INTERACTIVE_COMMENTS
setopt EXTENDED_GLOB

zstyle ":completion:*" matcher-list 'm:{a-z}={A-Za-z}'
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
# Classic highlighted menu: navigate with Tab/arrows, Enter accepts.
zstyle ":completion:*" menu select

# bash-like Tab flow:
#   AUTO_LIST        — list matches when the completion is ambiguous, but…
#   LIST_AMBIGUOUS   — …only once the common prefix is filled, so the list shows
#                      up on the SECOND Tab (just like bash)
#   AUTO_MENU        — repeated Tab then cycles through the highlighted menu
#   no MENU_COMPLETE — first Tab fills the prefix; it never jumps to match #1
setopt AUTO_LIST
setopt LIST_AMBIGUOUS
setopt AUTO_MENU
unsetopt MENU_COMPLETE

# eza file colors drawn from the yugen-ash palette (see the starship repo's starship.toml).
# di=dirs(tide) fi=files(color200) ex=exec(sage) ln=symlink(mist) or=broken(crimson)
# bd/cd=devices(gold) pi/so=pipe/socket(bloom); plus a few extension groups.
export EZA_COLORS="\
di=38;2;121;160;170:\
fi=38;2;212;212;212:\
ex=38;2;157;184;156:\
ln=38;2;168;196;196:\
or=38;2;191;97;106:\
bd=38;2;212;160;23:\
cd=38;2;212;160;23:\
pi=38;2;195;139;158:\
so=38;2;195;139;158:\
*.tar=38;2;179;90;58:*.gz=38;2;179;90;58:*.tgz=38;2;179;90;58:*.zip=38;2;179;90;58:*.xz=38;2;179;90;58:*.zst=38;2;179;90;58:*.7z=38;2;179;90;58:*.bz2=38;2;179;90;58:*.rar=38;2;179;90;58:\
*.png=38;2;195;139;158:*.jpg=38;2;195;139;158:*.jpeg=38;2;195;139;158:*.gif=38;2;195;139;158:*.svg=38;2;195;139;158:*.webp=38;2;195;139;158:\
*.mp3=38;2;212;160;23:*.flac=38;2;212;160;23:*.wav=38;2;212;160;23:*.mp4=38;2;212;160;23:*.mkv=38;2;212;160;23:*.mov=38;2;212;160;23:\
*.md=38;2;168;196;196:*.txt=38;2;168;196;196:*.pdf=38;2;168;196;196"

# Modern CLI replacements (interactive only; scripts still get the real tools)
alias ls="eza -1 --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first --git"
alias la="eza -a --icons --group-directories-first"
alias lt="eza --tree --level=2 --icons"
alias cat="bat --paging=never"
alias top="btop"
alias du="dust"
alias grep="grep --color=auto"   # rg is great, but kept separate to avoid flag surprises

alias vi="nvim"
alias vim="nvim"
alias c="clear"
alias e="exit"
alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias cdd="cd ~/Desktop/"
alias d="dirs -v"                # jump list populated by AUTO_PUSHD
alias pwf="poweroff"
alias mer="~/meridius-3.3.5/meridius --no-sandbox > /dev/null 2>&1 &"
alias claude="claude --dangerously-skip-permissions"

alias open="xdg-open"            # open a file/URL with the default app
alias xo="xdg-open"
alias xmime="xdg-mime"           # query/set default app for a mime type
alias xset-default="xdg-settings"
alias xemail="xdg-email"         # compose mail with the default client
alias xdir="xdg-user-dir"        # resolve XDG dirs, e.g. xdir DOWNLOAD

# Git aliases & tooling live in plugins/git-tools.zsh (sourced above).

alias d-c="docker compose"
alias d-cl="docker compose logs -f"

alias tm="tmux"
alias tmd="tmux detach-client"

tmn() {
    local terms="${1:-2}"
    local dir="$PWD"
    local session="${PWD:t}-$$"

    tmux new-session -d -s "$session" -c "$dir" "nvim ."

    local i
    for (( i = 1; i <= terms; i++ )); do
        tmux new-window -t "$session" -c "$dir"
    done

    tmux select-window -t "$session":0

    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session"
    else
        tmux attach-session -t "$session"
    fi
}

nixs() {
    local query="${*}"
    query="${query// /+}"
    local url="https://search.nixos.org/packages?query=${query}"

    if ! command -v xdg-open >/dev/null; then
        echo "Open in browser: $url"
        return
    fi

    xdg-open "$url"

    local browser=$(xdg-settings get default-web-browser 2>/dev/null | sed 's/\.desktop$//')
    if [ -n "$browser" ]; then
        if command -v wmctrl >/dev/null; then
            wmctrl -x -a "$browser" 2>/dev/null || wmctrl -a "$browser" 2>/dev/null
        elif command -v xdotool >/dev/null; then
            xdotool search --class "$browser" windowactivate 2>/dev/null
        fi
    fi
}

nixpa() {
    nix profile add nixpkgs#"$1"
}

nixsw() {
    sudo nixos-rebuild switch --flake ".#${1:-qFioofa}"
}

t() {
	mkdir -p "$(dirname -- "$1")" && touch "$1"
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

# Russian layout (ЙЦУКЕН) mirrors: p -> з, and < > -> , . by key position
bindkey 'з+' player_vol_up
bindkey 'З+' player_vol_up
bindkey 'з-' player_vol_down
bindkey 'З-' player_vol_down
bindkey 'з,' player_prev_cmd
bindkey 'З,' player_prev_cmd
bindkey 'з.' player_next_cmd
bindkey 'З.' player_next_cmd
bindkey 'з||' player_toggle_cmd
bindkey 'З||' player_toggle_cmd

export EDITOR=nvim
export VISUAL=nvim

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
