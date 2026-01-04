{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
    # niri is installed as a system package
  ];

  # The DMS Shell Module is also in configuration.nix
}
