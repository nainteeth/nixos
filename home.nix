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
      # Qt theming packages
      (catppuccin-kvantum.override {
        accent = "mauve";
        variant = "mocha";
      })
      libsForQt5.qtstyleplugin-kvantum
      libsForQt5.qt5ct
      kdePackages.qtstyleplugin-kvantum
      kdePackages.qt6ct
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
    platformTheme.name = "qt5ct";
    style.name = "kvantum";
  };

  fonts.fontconfig.enable = true;

  xdg.configFile = (builtins.mapAttrs (target: source: {
    source = mkSymlink "${dotfiles}/${source}";
    recursive = true;
  }) configDirs) // {
    # Kvantum theme config
    "Kvantum/kvantum.kvconfig".text = lib.generators.toINI {} {
      General.theme = "Catppuccin-Mocha-Mauve";
    };
    # Qt5ct config
    "qt5ct/qt5ct.conf".text = lib.generators.toINI {} {
      Appearance = {
        icon_theme = "Papirus-Dark";
        style = "kvantum";
      };
    };
    # Qt6ct config
    "qt6ct/qt6ct.conf".text = lib.generators.toINI {} {
      Appearance = {
        icon_theme = "Papirus-Dark";
        style = "kvantum";
      };
    };
  };

  imports = [
    ./modules/neovim.nix
    ./modules/niri.nix
    #./modules/emacs.nix
    ./modules/gaming.nix
    ./modules/bash.nix
  ];
}
