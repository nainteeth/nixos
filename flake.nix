{
  description = "home manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
				nainteeth = home-manager.lib.homeManagerConfiguration {
					inherit pkgs;
					modules = [ ./home.nix ];
				};
			};
		};
}
