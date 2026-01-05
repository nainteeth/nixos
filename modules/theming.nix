 { config, pkgs, ... }:

 {
  home.packages = with pkgs; [
    kdePackages.breeze
    kdePackages.breeze.qt5
  ];

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style = {
      name = "breeze";
      package = pkgs.kdePackages.breeze;
    };
  };
}
