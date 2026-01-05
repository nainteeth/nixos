{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    lua-language-server
    nil
    nixpkgs-fmt
    nodejs
    catppuccin
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };
}
