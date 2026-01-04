{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    waybar
    waypaper
    pavucontrol
    wofi
    mako
    grim
    slurp
    wl-clipboard
    kitty
  ];
}
