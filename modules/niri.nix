{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
    waybar
    wofi
    mako
    waypaper
    pavucontrol

    # niri is installed as a system package
  ];
}
