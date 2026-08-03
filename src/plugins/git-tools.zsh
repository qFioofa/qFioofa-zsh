if (( $+commands[delta] )); then
  export GIT_PAGER='delta --line-numbers --hyperlinks --navigate --file-style="#ffbe89" --file-decoration-style="#bc735c ul" --hunk-header-style="file line-number syntax" --hunk-header-decoration-style="#79a0aa box" --line-numbers-left-style="#505050" --line-numbers-right-style="#505050" --line-numbers-minus-style="#bf616a" --line-numbers-plus-style="#9db89c" --minus-style="syntax #3a2426" --minus-emph-style="syntax #5a2e32" --plus-style="syntax #243a24" --plus-emph-style="syntax #2f5a2f" --zero-style="syntax"'
fi

(( $+commands[lazygit] )) && alias lg="lazygit"

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
alias gpuf="git push --force-with-lease"
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

gpf() {
	git add . && git commit -m "$1" && git push origin "${2:-$(_git_default_branch)}"
}

_git_default_branch() {
	local ref
	if ref=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null); then
		print -r -- "${ref:t}"
		return
	fi
	if git rev-parse -q --verify origin/master >/dev/null 2>&1; then
		print -r -- "master"
	else
		print -r -- "main"
	fi
}

gfr() {
	git fetch origin &&
	git switch -c "${1:?usage: gfr <branch>}" "origin/$(_git_default_branch)"
}

gup() {
	git fetch origin &&
	git rebase "origin/${1:-$(_git_default_branch)}"
}

gsync() {
	gup && git push --force-with-lease origin HEAD
}

gpr() {
	git push -u origin HEAD &&
	{ command -v gh >/dev/null && gh pr create --fill || true; }
}

gprc() {
	command -v gh >/dev/null || { print -u2 "gh not installed"; return 1 }
	gh pr checkout "${1:?usage: gprc <pr>}"
}

alias gprl='gh pr list'
alias gprm='gh pr merge --squash --delete-branch'
alias gdel='git branch -d'
alias glg='git log --graph --pretty="%h %ad %s (%an)" --date=short -20'
alias gsh='git show --stat'
alias gdn='git diff HEAD'

gundo() { git reset --soft HEAD~1; }

gnuke() {
	git fetch origin
	git reset --hard "origin/$(git branch --show-current)"
	git clean -fd
}

alias gclean='git clean -fd'
alias gstau='git stash -u'
alias gstal='git stash list'
alias gtag='git tag -l | sort -V'
alias grv='git remote -v'

gblame() { git blame "${1:?usage: gblame <file>}"; }
gcp()    { git cherry-pick "${1:?usage: gcp <commit>}"; }
