{ config, pkgs, lib, ... }:
{
	home = {
		packages = with pkgs; [
			hello
		];

		username = "nainteeth";
		homeDirectory = "/home/nainteeth";

    # Nicht verändern!
  	stateVersion = "25.11";
	};

  fonts.fontconfig.enable = true;
 
  #imports = [
  #];
}
