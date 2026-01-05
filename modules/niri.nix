{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
    # waybar
    ags
    wofi
    mako
    waypaper
    pavucontrol
    xwayland-satellite
    swaybg

    # niri is installed as a system package
  ];
}
