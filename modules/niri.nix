{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
    waybar
    wofi
    mako
    waypaper

    # niri is installed as a system package
  ];
}
