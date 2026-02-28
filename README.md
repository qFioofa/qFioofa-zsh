# qFioofa-zsh

Personal zsh config.

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
bash deploy_config.sh -r && exec zsh
```

# Plugins

The plugin manager is [zinit](https://github.com/zdharma-continuum/zinit)
Show status of plugin manager

```bash
zinit zstatus
```

## Prompt

```bash
sudo apt install starship
```

## Player

- Install universall Player

```bash
sudo apt install playerctl
```
