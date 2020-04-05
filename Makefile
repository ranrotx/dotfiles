all: sync

sync:

	[ -f ~/.vimrc ] || ln -s $(PWD)/vimrc ~/.vimrc
	[ -f ~/.zshrc ] || ln -s $(PWD)/zshrc ~/.zshrc
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmuxconf ~/.tmux.conf
	[ -f ~/.curlrc ] || ln -s $(PWD)/curlrc ~/.curlrc
	#[ -f ~/.git-prompt.sh ] || ln -s $(PWD)/git-prompt.sh ~/.git-prompt.sh
	#[ -f ~/.gitconfig ] || ln -s $(PWD)/gitconfig ~/.gitconfig

	# don't show last login message
	touch ~/.hushlogin

clean:
	rm -f ~/.vimrc
	rm -f ~/.zshrc
	rm -f ~/.tmux.conf
	rm -f ~/.curlrc
	#rm -f ~/.git-prompt.sh
	#rm -f ~/.gitconfig

.PHONY: all clean sync build run kill
