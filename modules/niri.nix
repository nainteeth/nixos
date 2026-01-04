{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
    # niri is installed as a system package
  ];
}
