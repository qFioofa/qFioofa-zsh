{
  description = "qFioofa Zsh config — Home Manager module";

  # See scripts/deploy.sh: src/ is the config root, target is ~/.config/zsh.
  # deploy.sh also writes ~/.zshenv with `export ZDOTDIR=...` so zsh loads
  # .zshrc out of ~/.config/zsh instead of the home directory.
  outputs = { self }: {
    homeManagerModules.default = { config, lib, pkgs, ... }: {
      xdg.configFile."zsh" = {
        recursive = true;
        source = ./src;
      };

      home.file.".zshenv".text = ''
        export ZDOTDIR="${config.xdg.configHome}/zsh"
      '';
    };
  };
}
