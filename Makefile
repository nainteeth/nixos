.PHONY: help
help: ## Show this help message
	@echo "NixOS Configuration Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Quick Start:"
	@echo "  make deploy     - Rebuild + commit + push (main workflow)"
	@echo "  make save       - Commit + push config changes (no rebuild) ONLY use this if you changed config/ files!"
	@echo "  make sync       - Pull latest from remote"
	@echo "  make help       - Show this help message"
	@echo ""
	@echo "Note: Edit config/ files? Just 'make save' (no rebuild needed!)"
	@echo "      Edit .nix files? Use 'make deploy' (rebuilds then saves)"

# === Main Workflow Commands ===

.PHONY: deploy
deploy: ## Rebuild everything, commit and push if successful
	@git add .
	@echo "Building configuration..."
	@if sudo nixos-rebuild switch --flake ~/nixos#nixos; then \
		echo ""; \
		echo "✓ Build successful!"; \
		echo ""; \
		git diff --cached --stat; \
		echo ""; \
		echo "Enter commit message:"; \
		read -p "> " msg; \
		if [ -n "$$msg" ]; then \
			git commit -m "$$msg"; \
			echo ""; \
			echo "Pushing to remote..."; \
			git push; \
			echo ""; \
			echo "✓ Deployed and pushed successfully!"; \
		else \
			echo "✗ Empty commit message. Aborting."; \
			git reset; \
			exit 1; \
		fi \
	else \
		echo ""; \
		echo "✗ Build failed! Not committing."; \
		exit 1; \
	fi

.PHONY: save
save: ## Commit and push config changes (no rebuild)
	@if git diff --quiet && git diff --cached --quiet; then \
		echo "✗ No changes to save!"; \
		exit 1; \
	fi
	@git add .
	@git diff --cached --stat
	@echo ""
	@echo "Enter commit message:"
	@read -p "> " msg; \
	if [ -n "$$msg" ]; then \
		git commit -m "$$msg"; \
		echo ""; \
		echo "Pushing to remote..."; \
		git push; \
		echo ""; \
		echo "✓ Changes saved and pushed!"; \
	else \
		echo "✗ Empty commit message. Aborting."; \
		git reset; \
		exit 1; \
	fi

.PHONY: pull 
pull: ## Pull latest changes from remote
	@echo "Pulling latest changes..."
	@git pull --rebase
	@echo "✓ Synced with remote!"

.PHONY: pull-deploy
pull-deploy: ## Pull latest changes and rebuild
	@echo "Pulling latest changes..."
	@git pull --rebase
	@echo ""
	@echo "Rebuilding configuration..."
	@sudo nixos-rebuild switch --flake ~/nixos#nixos

# === Testing Commands (No Git) ===

.PHONY: test
test: ## Test config without committing (reverts on reboot)
	sudo nixos-rebuild test --flake ~/nixos#nixos

.PHONY: check
check: ## Validate flake syntax and structure
	nix flake check ~/nixos

# === Package Management ===

.PHONY: update
update: ## Update flake.lock to latest packages
	nix flake update ~/nixos
	@echo ""
	@echo "✓ Flake updated! Review with 'git diff flake.lock'"
	@echo "  Then run 'make deploy' to apply and save changes."

.PHONY: search
search: ## Search for packages (usage: make search PACKAGE=name)
	@if [ -z "$(PACKAGE)" ]; then \
		echo "Usage: make search PACKAGE=package-name"; \
		echo "Example: make search PACKAGE=firefox"; \
	else \
		nix search nixpkgs $(PACKAGE); \
	fi

# === Cleanup Commands ===

.PHONY: clean
clean: ## Remove old system generations (free space)
	sudo nix-collect-garbage -d

.PHONY: clean-all
clean-all: ## Deep clean: remove old generations + optimize store
	sudo nix-collect-garbage -d
	sudo nix-store --gc
	sudo nix-store --optimize

.PHONY: gc-check
gc-check: ## Show how much space garbage collection will free
	nix-store --gc --print-dead

# === Info & History Commands ===

.PHONY: status
status: ## Show git status and system info
	@echo "=== Git Status ==="
	@git status --short
	@echo ""
	@echo "=== Current Generation ==="
	@sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -n 1

.PHONY: diff
diff: ## Show what changed in last rebuild
	nix store diff-closures /nix/var/nix/profiles/system-*-link | tail -n 20

.PHONY: history
history: ## List all system generations
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

.PHONY: log
log: ## Show recent git commits
	@git log --oneline --graph --decorate -10

.PHONY: show
show: ## Show available configurations in flake
	nix flake show ~/nixos

# === Rollback & Recovery ===

.PHONY: rollback
rollback: ## Rollback to previous generation (does not affect git)
	@echo "⚠ This will rollback the system but NOT git!"
	@echo "Press Enter to continue, Ctrl+C to cancel..."
	@read
	sudo nixos-rebuild switch --rollback

.DEFAULT_GOAL := help
