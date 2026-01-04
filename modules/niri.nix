{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    waybar
    wofi
    mako
    grim
    slurp
    wl-clipboard
  ];
}
