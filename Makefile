all: sync

init:

	# Create .zsh dirctory if doesn't exist
	[ -d ~/.zsh ] || mkdir -p ~/.zsh

	# Install ZSH plugins if they don't exist
	[ -d ~/.zsh/zsh-syntax-highlighting ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
	[ -d ~/.zsh/zsh-autosuggestions ] || git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

	# Create tmux plugin directory if it doesn't exist
	[ -d ~/.tmux/plugins ] || mkdir -p ~/.tmux/plugins

	# Install Tmux plugins if they don't exist
	[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
	[ -d ~/.tmux/plugins/tmux-open ] || git clone https://github.com/tmux-plugins/tmux-open.git "${HOME}/.tmux/plugins/tmux-open"
	[ -d ~/.tmux/plugins/tmux-yank ] || git clone https://github.com/tmux-plugins/tmux-yank.git "${HOME}/.tmux/plugins/tmux-yank"
	[ -d ~/.tmux/plugins/tmux-prefix-highlight ] || git clone https://github.com/tmux-plugins/tmux-prefix-highlight.git "${HOME}/.tmux/plugins/tmux-prefix-highlight"

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
