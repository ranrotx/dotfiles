all: sync

init:

	# Create .zsh dirctory if doesn't exist
	[ -f ~/.zsh ] || mkdir -p ~/.zsh

	# Install plugins if they don't exist
	[ -f ~/.zsh/zsh-syntax-highlighting ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
	[ -f ~/.zsh/zsh-autosuggestions ] || git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions


sync:

	[ -f ~/.vimrc ] || ln -s $(PWD)/vimrc ~/.vimrc
	[ -f ~/.zshrc ] || ln -s $(PWD)/zshrc ~/.zshrc
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmuxconf ~/.tmux.conf
	[ -f ~/.curlrc ] || ln -s $(PWD)/curlrc ~/.curlrc
	[ -f ~/.git-prompt.sh ] || ln -s $(PWD)/git-prompt.sh ~/.git-prompt.sh
	[ -f ~/.gitconfig ] || ln -s $(PWD)/gitconfig ~/.gitconfig

	# don't show last login message
	touch ~/.hushlogin

clean:
	rm -f ~/.vimrc
	rm -f ~/.zshrc
	rm -f ~/.tmux.conf
	rm -f ~/.curlrc
	rm -f ~/.git-prompt.sh
	rm -f ~/.gitconfig

.PHONY: all clean sync build run kill
