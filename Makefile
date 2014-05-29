.PHONY: zsh bash vim git kerl ripit

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

zsh:
	ln -nsf $(PWD)/zsh/zshrc.symlink ~/.zshrc
	ln -nsf $(PWD)/zsh/zshenv.symlink ~/.zshenv

shell: zsh

all: shell vim git ripit
