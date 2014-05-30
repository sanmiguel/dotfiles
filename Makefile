.PHONY: prezto oh-my-zsh bash vim git kerl ripit

ripit:
	ln -nsf $(PWD)/ripit/ripit.symlink ~/.ripit

kerl:
	ln -nsf $(PWD)/kerl/kerlrc.symlink ~/.kerlrc

git:
	ln -nsf $(PWD)/git/gitconfig.symlink ~/.gitconfig

vim:
	ln -nsf $(PWD)/vim/vim.symlink ~/.vim
	ln -nsf $(PWD)/vim/vimrc.symlink ~/.vimrc
	ln -nsf $(PWD)/vim/vimrc-after.symlink ~/.vimrc-after

oh-my-zsh:
	ln -nsf $(PWD)/oh-my-zsh/zshrc.symlink ~/.zshrc
	ln -nsf $(PWD)/oh-my-zsh/zshenv.symlink ~/.zshenv

prezto-deps:
	if [ ! -d ~/.zprezto ]; then \
		git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto; \
	else \
		( cd ~/.zprezto; git pull ; git submodule update --init --recursive ) \
	fi

prezto:
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

shell: oh-my-zsh

all: shell vim git ripit
