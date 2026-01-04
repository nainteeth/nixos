{ config, pkgs, lib, ... }:

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
    ];
  };

  fonts.fontconfig.enable = true;

  # Automatically create symlinks for all config directories
  xdg.configFile = builtins.mapAttrs (target: source: {
    source = mkSymlink "${dotfiles}/${source}";
    recursive = true;
  }) configDirs;

  imports = [
    ./modules/neovim.nix
    # ./modules/emacs.nix
    ./modules/niri.nix
    ./modules/gaming.nix
    ./modules/bash.nix
  ];
}
