REPO_URL = git@github.com:yourusername/dotfiles.git
DOTFILES_DIR = $(HOME)/.dotfiles
ALIAS_CMD = alias dotfiles='git --git-dir=$(DOTFILES_DIR) --work-tree=$(HOME)'

.PHONY: init backup clone restore

init:
	@git init --bare $(DOTFILES_DIR)
	@echo "$(ALIAS_CMD)" >> $(HOME)/.bashrc
	@echo ".dotfiles" >> $(HOME)/.gitignore
	@echo "[INFO] Initialized bare repo and added alias."

backup:
	@git --git-dir=$(DOTFILES_DIR) --work-tree=$(HOME) add .bashrc .config/vim/vimrc .Xresources Makefile .tern-project
	@git --git-dir=$(DOTFILES_DIR) --work-tree=$(HOME) commit -m "Backup dotfiles"
	@proxychains git --git-dir=$(DOTFILES_DIR) --work-tree=$(HOME) push origin master
	@echo "[INFO] Dotfiles backed up."

clone:
	@git clone --bare $(REPO_URL) $(DOTFILES_DIR)
	@$(ALIAS_CMD)
	@git --git-dir=$(DOTFILES_DIR) --work-tree=$(HOME) checkout
	@git --git-dir=$(DOTFILES_DIR) --work-tree=$(HOME) config --local status.showUntrackedFiles no
	@echo "[INFO] Cloned and checked out dotfiles."

restore: clone
