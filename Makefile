.PHONY: update
update:
	home-manager switch --flake .#nainteeth 

.PHONY: clean
	nix-collect-garbage -d
