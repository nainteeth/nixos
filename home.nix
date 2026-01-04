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
      libsForQt5.qtstyleplugin-kvantum
      kdePackages.qtstyleplugin-kvantum
      catppuccin-kvantum
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

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "mauve";
      };
    };

    cursorTheme = {
      name = "catppuccin-mocha-mauve-cursors";
      package = pkgs.catppuccin-cursors.mochaMauve;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  fonts.fontconfig.enable = true;

  # Automatically create symlinks for all config directories
  xdg.configFile = (builtins.mapAttrs (target: source: {
    source = mkSymlink "${dotfiles}/${source}";
    recursive = true;
  }) configDirs) // {
    "Kvantum/kvantum.kvconfig" = {
      text = ''
        [General]
        theme=Catppuccin-Mocha-Mauve
      '';
    };
    "Kvantum/Catppuccin-Mocha-Mauve" = {
      source = "${pkgs.catppuccin-kvantum}/share/Kvantum/Catppuccin-Mocha-Mauve";
      recursive = true;
    };
  };

  imports = [
    ./modules/neovim.nix
    # ./modules/emacs.nix
    ./modules/niri.nix
    ./modules/gaming.nix
    ./modules/bash.nix
  ];
}
