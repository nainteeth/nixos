{
  description = "home manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ...}:
		let
			lib = nixpkgs.lib;
			system = "x86_64-linux";
			pkgs = import nixpkgs { inherit system; };

		in {
			homeConfiguration = {
				nainteeth = home-manager.lib.homeManagerConfigurations {
					inherit pkgs;
					modules = [ ./home.nix ];
				};
			};
		};
}
