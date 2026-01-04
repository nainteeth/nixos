{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
    waybar
    wofi
    mako
    waypaper
    pavucontrol
    xwayland-satellite
    swaybg

    # niri is installed as a system package
  ];
}
