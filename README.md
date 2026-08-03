# qFioofa-zsh

Personal zsh config.

# Showcase

## Overview

![ex1](./images/ex1.png)

![ex2](./images/ex2.png)

## Syntax highlight

![highlight](./images/highlight.png)

> Note: [file for testing terminal highlighs](./extra/highlight_test.bash)

## Music switch

![music_switch](./images/music.gif)

# Install

Install the zsh throw package manager

```bash
sudo apt install zsh
```

- Make it the main shell

```bash
chsh -s $(which zsh)
```

- Enter password if needed
- Reload terminal
- Deploy from cloned repo

```bash
bash scripts/deploy.sh -r && exec zsh
```

# Plugins

The plugin manager is [zinit](https://github.com/zdharma-continuum/zinit)
Show status of plugin manager

```bash
zinit zstatus
```

## Prompt

The prompt is [starship](https://starship.rs) with a shared config living in
the separate `starship` repo. `scripts/deploy.sh` installs starship and
deploys that config automatically when the `starship/` repo sits next to this
one; otherwise set it up by hand:

```bash
bash ../starship/scripts/deploy.sh
```

## Player

- Install universall Player

```bash
sudo apt install playerctl
```

## CLI tools

The config auto-detects these and degrades gracefully if they are missing
(each is guarded with `command -v`). Install for the full experience:

```bash
sudo apt install git-delta lazygit fd-find bat eza fzf ripgrep
```

- `delta` — git's diff pager, themed with yugen-ash (`plugins/git-tools.zsh`)
- `lazygit` — terminal git UI, aliased to `lg`
- `fd`, `bat`, `eza` — power the fzf previews in `plugins/fzf-extras.zsh`
- `fzf` previews/`fkill`, plus `Ctrl+X Ctrl+E` to edit the command line in `$EDITOR`

# Nix

Ships a `flake.nix` exposing a Home Manager module (`homeManagerModules.default`).
It symlinks `./src` to `~/.config/zsh` via `xdg.configFile` and also writes a
`~/.zshenv` that sets `ZDOTDIR` so zsh loads `.zshrc` from there — the declarative
equivalent of `scripts/deploy.sh`.

```nix
# flake inputs
qFioofa-zsh.url = "github:qFioofa/qFioofa-zsh";

# home configuration
imports = [ qFioofa-zsh.homeManagerModules.default ];
```
