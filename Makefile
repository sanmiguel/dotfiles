.PHONY: powerline prezto oh-my-zsh bash nvim vim git kerl ripit slate

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

nvim:
	ln -nsf $(PWD)/nvim/nvim.symlink ~/.config/nvim

vim:
	ln -nsf $(PWD)/vim/vim.symlink ~/.vim
	ln -nsf $(PWD)/vim/vimrc.symlink ~/.vimrc
	ln -nsf $(PWD)/vim/vimrc-after.symlink ~/.vimrc-after

oh-my-zsh:
	ln -nsf $(PWD)/oh-my-zsh/zshrc.symlink ~/.zshrc
	ln -nsf $(PWD)/oh-my-zsh/zshenv.symlink ~/.zshenv
	ln -nsf $(PWD)/oh-my-zsh/p10k.sh.symlink ~/.p10k.sh

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
