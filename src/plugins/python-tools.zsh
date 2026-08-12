# Python tooling & shortcuts: interpreter wrapper, one-liners, venvs, pip,
# http/json helpers, notebooks and the lint/format/test trio.
# The whole file is guarded on python3 so the config still works without it.

(( $+commands[python3] )) || return 0

# --- interpreter ---
alias py="python3"

pyv() { python3 -V; }                                  # version
pyw() { print -r -- "${commands[python3]}"; }          # interpreter path

# --- running & inspecting code ---
px()     { python3 -c "$1"; }                          # one-liner:  px "print(2**10)"
pyr()    { python3 -u "$@"; }                          # run a script unbuffered
pyi()    { python3 -i "$@"; }                          # run, then drop into the REPL
pyc()    { python3 -m py_compile "$1"; }               # syntax/compile check a file
pydbg()  { python3 -m pdb "$1"; }                      # pdb debug session
pydoc()  { python3 -m pydoc "$@"; }                    # module docs / -w html export
pyprof() { python3 -m cProfile -s cumulative "$1"; }   # profile a script

# --- pip ---
alias pip="python3 -m pip"
alias pipi="pip install"
alias pipup="pip install --upgrade"
alias pipu="pip uninstall"
alias pipr="pip install -r requirements.txt"
alias pipf="pip freeze"
alias pipfr="pip freeze > requirements.txt"
alias pipo="pip list"
alias pipou="pip list --outdated"
alias pipc="pip cache purge"

# --- virtualenvs ---
mkenv() { python3 -m venv "${1:-.venv}"; }                               # mkenv [name]

aenv() {                                                                 # aenv [name]
  local name="${1:-.venv}"
  [[ -f "$name/bin/activate" ]] || {
    print -u2 "no $name/bin/activate in $PWD"
    return 1
  }
  source "$name/bin/activate"
}

deenv() { deactivate; }                                                  # leave the venv

# --- handy tools ---
pyhttp() { python3 -m http.server "${1:-8000}" --bind 0.0.0.0; }         # pyhttp [port] — file browser (WSL/container friendly)

pyjson() {                                                               # pyjson <file|-> pretty JSON
  if (( $+commands[bat] )); then
    python3 -m json.tool "$@" | bat -l json -p
  else
    python3 -m json.tool "$@"
  fi
}

# --- notebooks ---
if (( $+commands[jupyter] )); then
  alias pynb="jupyter notebook --no-browser"
  alias pylab="jupyter lab --no-browser"
fi

# --- lint / format / test ---
(( $+commands[pytest] )) && alias pyt="pytest -q"
(( $+commands[pytest] )) && alias pytx="pytest -q -x"
(( $+commands[ruff]  ))  && alias pyruff="ruff check"
(( $+commands[black] ))  && alias pybl="black --line-length 100"
(( $+commands[uv] ))     && alias pyu="uv run python3"
