# fzf appearance & widgets, themed with yugen-ash (see the starship repo's starship.toml).
# These env vars are read by fzf at call time, so setting them here (before the
# `fzf --zsh` integration loads at the end of .zshrc) is enough.

# yugen-ash colors + a compact bordered layout shared by every fzf invocation.
# bg:-1 keeps the terminal's own background (stays transparent if it is).
export FZF_DEFAULT_OPTS="\
--height 60% --layout=reverse --border=rounded --info=inline \
--color=fg:#d4d4d4,bg:-1,hl:#bf616a \
--color=fg+:#fafafa,bg+:#303030,hl+:#bc735c \
--color=info:#79a0aa,prompt:#9db89c,pointer:#c38b9e \
--color=marker:#d4a017,spinner:#c38b9e,header:#5d6d7e,border:#505050"

# Use fd for the file/dir walkers when present (respects .gitignore, skips .git).
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# Ctrl+T (paste a path): bat preview for files, eza listing for directories.
export FZF_CTRL_T_OPTS="--preview '([ -d {} ] && eza -1 --color=always --icons {} || bat -n --color=always --line-range :500 {}) 2>/dev/null' --preview-window=right:60%:border-left"

# Alt+C (cd into a directory): eza tree preview.
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always --icons {} 2>/dev/null'"

# Ctrl+R (history): full command on a wrapped preview, toggled with '?'.
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=down:3:hidden:wrap --bind '?:toggle-preview'"

# fkill — pick process(es) in fzf and signal them. Default SIGTERM; pass a
# signal to override, e.g. `fkill 9` for SIGKILL.
fkill() {
  local pids
  pids=$(ps -eo pid,ppid,user,%cpu,%mem,command --sort=-%cpu | sed 1d \
    | fzf --multi --header='[fkill] выбери процесс(ы), Enter — сигнал' \
    | awk '{print $1}')
  [ -z "$pids" ] && return
  echo "$pids" | xargs kill "-${1:-TERM}"
}
