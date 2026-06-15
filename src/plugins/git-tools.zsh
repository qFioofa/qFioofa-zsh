# Git tooling. Diff colors follow the yugen-ash palette (see plugins/starship.toml).

# delta — syntax-highlighted, line-numbered diffs as git's pager. Configured
# here rather than in ~/.gitconfig so this repo stays the single source of truth
# and never mutates the user's global git config. git runs the pager through
# `sh -c`, so the quoted multi-word styles below survive intact. Keep it on one
# line: inside single quotes a backslash-newline would be literal, not a join.
if (( $+commands[delta] )); then
  export GIT_PAGER='delta --line-numbers --hyperlinks --navigate --file-style="#ffbe89" --file-decoration-style="#bc735c ul" --hunk-header-style="file line-number syntax" --hunk-header-decoration-style="#79a0aa box" --line-numbers-left-style="#505050" --line-numbers-right-style="#505050" --line-numbers-minus-style="#bf616a" --line-numbers-plus-style="#9db89c" --minus-style="syntax #3a2426" --minus-emph-style="syntax #5a2e32" --plus-style="syntax #243a24" --plus-emph-style="syntax #2f5a2f" --zero-style="syntax"'
fi

# lazygit — full-screen terminal UI for stage/commit/rebase/etc.
(( $+commands[lazygit] )) && alias lg="lazygit"

# Aliases. Short, mnemonic verbs over the commands reached for most often.
alias gst="git status"
alias gss="git status -s"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log --oneline --graph --decorate -20"
alias gco="git checkout"
alias gsw="git switch"
alias gswc="git switch -c"
alias gp="git pull"
alias gf="git fetch --all --prune"
alias gpu="git push"
alias gpuf="git push --force-with-lease"   # safer than --force
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gcan="git commit --amend --no-edit"
alias gb="git branch"
alias gba="git branch -a"
alias gr="git restore"
alias grs="git restore --staged"
alias gsta="git stash"
alias gstp="git stash pop"

# add-all + commit + push in one go: gpf "message" [branch=main]
gpf() {
	git add . && git commit -m "$1" && git push origin "${2:-main}"
}
