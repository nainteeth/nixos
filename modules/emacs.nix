{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    emacs
  ];

  programs.emacs = {
    enable = true;
  };
}
