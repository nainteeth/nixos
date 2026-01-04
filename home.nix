{ inputs, config, pkgs, lib, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos/config";

  mkSymlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configDirs = {
    "nvim" = "nvim";
    "waybar" = "waybar";
    "niri" = "niri";
    "starship" = "starship";
    "kitty" = "kitty";
    "mako" = "mako";
    "wofi" = "wofi";
  };
in
{
  home = {
    username = "nainteeth";
    homeDirectory = "/home/nainteeth";
    stateVersion = "25.11";

    packages = with pkgs; [
      gcc
      keepassxc
      cava
      starship
      libnotify
    ];
  };

  gtk = {
    enable = true;
    
    theme = {
      name = "catppuccin-mocha-mauve-standard+default";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "standard";
        variant = "mocha";
      };
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  fonts.fontconfig.enable = true;

  # Automatically create symlinks for all config directories
  xdg.configFile = builtins.mapAttrs (target: source: {
    source = mkSymlink "${dotfiles}/${source}";
    recursive = true;
  }) configDirs;

  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./modules/neovim.nix
    # ./modules/emacs.nix
    ./modules/niri.nix
    ./modules/gaming.nix
    ./modules/bash.nix
  ];
}
