# uv tooling & shortcuts: project lifecycle, python management, pip-compat,
# ad-hoc tools, cache hygiene and the build/publish path.
# The whole file is guarded on uv so the config still works without it.

(( $+commands[uv] )) || return 0

# --- project lifecycle ---
alias uvi="uv init"                              # scaffold a project
alias uva="uv add"                               # add a dependency
alias uvrm="uv remove"                           # remove a dependency
alias uvs="uv sync"                              # sync the project env with uv.lock
alias uvsu="uv sync --upgrade"                   # bump deps to newest allowed + sync
alias uvl="uv lock"                              # resolve & write uv.lock
alias uvr="uv run"                               # run a command with the project env
alias uvt="uv tree"                              # dependency tree
alias uvo="uv outdated"                          # list outdated dependencies
alias uve="uv export --format requirements > requirements.txt"

# --- python management ---
alias uvpy="uv python list"                      # installed/available pythons
alias uvpi3="uv python install"                  # install a version: uvpi3 3.12
alias uvpin="uv python pin"                      # pin the project python: uvpin 3.12

# --- ad-hoc venvs (pip-style compat) ---
alias uvv="uv venv"                              # create ./.venv
uvv3() { uv venv --python "${1:-3.12}"; }        # uvv3 [ver] — venv with a specific python
alias uvpi="uv pip install"
alias uvpis="uv pip sync"                        # make any env exactly match a requirements file
alias uvpic="uv pip compile"                     # compile requirements.in -> requirements.txt
alias uvpif="uv pip freeze"
alias uvpir="uv pip install -r requirements.txt"

# --- ad-hoc tools (pipx style) ---
alias uvti="uv tool install"                     # install a CLI tool for good
alias uvtr="uv tool run"                         # run a tool without installing it
alias uvtl="uv tool list"
alias uvtup="uv tool upgrade --all"

# --- build / publish ---
alias uvbuild="uv build"
alias uvpub="uv publish"

# --- hygiene ---
alias uvc="uv cache clean"                       # empty the cache
alias uvu="uv self update"                       # upgrade uv itself
alias uvd="uv doctor"