{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;
    bashrcExtra = builtins.readFile ../config/bash/.bashrc; 
  };
}
