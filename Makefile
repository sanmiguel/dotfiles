.PHONY: powerline prezto oh-my-zsh zsh-sheldon bash nvim vim git kerl ripit slate claude

ripit:
	ln -nsf $(PWD)/ripit/ripit.symlink ~/.ripit

kerl:
	ln -nsf $(PWD)/kerl/kerlrc.symlink ~/.kerlrc

slate:
	ln -nsf $(PWD)/slate/slate.symlink ~/.slate
git:
	ln -nsf $(PWD)/git/gitconfig.symlink ~/.gitconfig
	ln -nsf $(PWD)/git/gitconfig.github ~/.gitconfig.github
	ln -nsf $(PWD)/git/gitconfig.telesystems ~/.gitconfig.telesystems

claude:
	mkdir -p ~/.claude ~/.claude-personal
	# Shared global instructions for both profiles (work + personal)
	ln -nsf $(PWD)/claude/CLAUDE.md ~/.claude/CLAUDE.md
	ln -nsf $(PWD)/claude/CLAUDE.md ~/.claude-personal/CLAUDE.md
	# Statusline: one script (referenced by repo path in settings.base.json),
	# per-profile config, plus the usage fetcher (only the work profile uses it)
	ln -nsf $(PWD)/claude/statusline-config.work.txt ~/.claude/statusline-config.txt
	ln -nsf $(PWD)/claude/statusline-config.personal.txt ~/.claude-personal/statusline-config.txt
	ln -nsf $(PWD)/claude/fetch-claude-usage.swift ~/.claude/fetch-claude-usage.swift
	# Settings: shared base merged with each profile's overrides. jq '*' lets
	# overrides win on scalars/objects but REPLACES arrays, so keep shared
	# arrays (permissions.allow, hooks) in settings.base.json, not the overrides.
	jq -s '.[0] * .[1]' $(PWD)/claude/settings.base.json $(PWD)/claude/settings.work.json > ~/.claude/settings.json
	jq -s '.[0] * .[1]' $(PWD)/claude/settings.base.json $(PWD)/claude/settings.personal.json > ~/.claude-personal/settings.json
	# Skills: symlink shared skill dirs into both profiles (SKILL.md + scripts travel together)
	mkdir -p ~/.claude/skills ~/.claude-personal/skills
	ln -nsf $(PWD)/claude/skills/worktree-context ~/.claude/skills/worktree-context
	ln -nsf $(PWD)/claude/skills/worktree-context ~/.claude-personal/skills/worktree-context

nvim:
	ln -nsf $(PWD)/nvim/nvim.symlink ~/.config/nvim

vim:
	ln -nsf $(PWD)/vim/vim.symlink ~/.vim
	ln -nsf $(PWD)/vim/vimrc.symlink ~/.vimrc
	ln -nsf $(PWD)/vim/vimrc-after.symlink ~/.vimrc-after

oh-my-zsh:
	ln -nsf $(PWD)/oh-my-zsh/zshrc.symlink ~/.zshrc
	ln -nsf $(PWD)/oh-my-zsh/zshenv.symlink ~/.zshenv
	ln -nsf $(PWD)/oh-my-zsh/p10k.zsh.symlink ~/.p10k.zsh

zsh-sheldon:
	ln -nsf $(PWD)/zsh-sheldon/zshrc.symlink ~/.zshrc
	ln -nsf $(PWD)/zsh-sheldon/zshenv.symlink ~/.zshenv
	mkdir -p ~/.config/sheldon
	ln -nsf $(PWD)/zsh-sheldon/plugins.toml ~/.config/sheldon/plugins.toml

prezto-deps:
	if [ ! -d ~/.zprezto ]; then \
		git clone --recursive https://github.com/sanmiguel/prezto.git ~/.zprezto; \
	else \
		( cd ~/.zprezto; git pull ; git submodule update --init --recursive ) \
	fi

prezto: prezto-deps
	# Install prezto
	ln -nsf $(PWD)/prezto/prezto-install ~/.zprezto
	ln -nsf $(PWD)/prezto/zshenv ~/.zshenv
	ln -nsf $(PWD)/prezto/zprofile ~/.zprofile
	ln -nsf $(PWD)/prezto/zshrc ~/.zshrc
	ln -nsf $(PWD)/prezto/zpreztorc ~/.zpreztorc
	ln -nsf $(PWD)/prezto/zlogin ~/.zlogin
	ln -nsf $(PWD)/prezto/zlogout ~/.zlogout

unprezto:
	rm ~/.zshenv ~/.zprofile ~/.zshrc ~/.zpreztorc ~/.zlogin ~/.zlogout

powerline:
	[ ! -d ~/.config ] && mkdir ~/.config || echo
	ln -nsf $(PWD)/powerline/powerline ~/.config/powerline

shell: prezto

all: shell vim git ripit
