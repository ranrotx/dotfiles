#!/bin/bash

set -eu

export DEBIAN_FRONTEND=noninteractive

UPGRADE_PACKAGES=${1:-none}

if [ "${UPGRADE_PACKAGES}" != "none" ]; then
  echo "==> Updating and upgrading packages ..."

  # Add third party repositories
  sudo add-apt-repository ppa:keithw/mosh-dev -y
  sudo add-apt-repository ppa:jonathonf/vim -y

  sudo apt-get update
  sudo apt-get upgrade -y
fi

sudo apt-get install -qq \
  apt-transport-https \
  build-essential \
  ca-certificates \
  cmake \
  curl \
  direnv \
  dnsutils \
  docker.io \
  fakeroot-ng \
  gdb \
  git \
  git-crypt \
  gnupg \
  gnupg2 \
  htop \
  ipcalc \
  jq \
  less \
  locales \
  man \
  mosh \
  mtr-tiny \
  netcat-openbsd \
  python3 \
  python3-pip \
  python3-setuptools \
  python3-venv \
  python3-wheel \
  shellcheck \
  tmux \
  tree \
  unzip \
  wget \
  zip \
  zsh \
  --no-install-recommends \

rm -rf /var/lib/apt/lists/*

# install 1password
if ! [ -x "$(command -v op)" ]; then
  export OP_VERSION="v0.9.4"
  curl -sS -o 1password.zip https://cache.agilebits.com/dist/1P/op/pkg/${OP_VERSION}/op_linux_amd64_${OP_VERSION}.zip
  unzip 1password.zip op -d /usr/local/bin
  rm -f 1password.zip
fi

# install kubectl
if ! [ -x "$(command -v kubectl)" ]; then
  export KUBE_VERSION="1.15.0/2020-02-22"
  curl -sS -o /usr/local/bin/kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/${KUBE_VERSION}/bin/linux/amd64/kubectl
  chmod 755 /usr/local/bin/kubectl
fi

# install terraform
if ! [ -x "$(command -v terraform)" ]; then
  export TERRAFORM_VERSION="0.12.24"
  wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip 
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip 
  chmod +x terraform
  mv terraform /usr/local/bin
  rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip
fi

VIM_PLUG_FILE="${HOME}/.vim/autoload/plug.vim"
if [ ! -f "${VIM_PLUG_FILE}" ]; then
  echo " ==> Installing vim plugins"
  curl -fLo ${VIM_PLUG_FILE} --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  mkdir -p "${HOME}/.vim/plugged"
  pushd "${HOME}/.vim/plugged"
  git clone "https://github.com/AndrewRadev/splitjoin.vim"
  git clone "https://github.com/ConradIrwin/vim-bracketed-paste"
  git clone "https://github.com/Raimondi/delimitMate"
  git clone "https://github.com/SirVer/ultisnips"
  git clone "https://github.com/cespare/vim-toml"
  git clone "https://github.com/corylanou/vim-present"
  git clone "https://github.com/ekalinin/Dockerfile.vim"
  git clone "https://github.com/elzr/vim-json"
  git clone "https://github.com/fatih/vim-hclfmt"
  git clone "https://github.com/fatih/vim-nginx"
  git clone "https://github.com/fatih/vim-go"
  git clone "https://github.com/hashivim/vim-hashicorp-tools"
  git clone "https://github.com/junegunn/fzf.vim"
  git clone "https://github.com/mileszs/ack.vim"
  git clone "https://github.com/roxma/vim-tmux-clipboard"
  git clone "https://github.com/plasticboy/vim-markdown"
  git clone "https://github.com/scrooloose/nerdtree"
  git clone "https://github.com/t9md/vim-choosewin"
  git clone "https://github.com/tmux-plugins/vim-tmux"
  git clone "https://github.com/tmux-plugins/vim-tmux-focus-events"
  git clone "https://github.com/fatih/molokai"
  git clone "https://github.com/tpope/vim-commentary"
  git clone "https://github.com/tpope/vim-eunuch"
  git clone "https://github.com/tpope/vim-fugitive"
  git clone "https://github.com/tpope/vim-repeat"
  git clone "https://github.com/tpope/vim-scriptease"
  git clone "https://github.com/ervandew/supertab"
  popd
fi

if [ ! -d "${HOME}/.zsh" ]; then
  echo " ==> Installing zsh plugins"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.zsh/zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.zsh/zsh-autosuggestions"
fi

if [ ! -d "${HOME}/.tmux/plugins" ]; then
  echo " ==> Installing tmux plugins"
  git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
  git clone https://github.com/tmux-plugins/tmux-open.git "${HOME}/.tmux/plugins/tmux-open"
  git clone https://github.com/tmux-plugins/tmux-yank.git "${HOME}/.tmux/plugins/tmux-yank"
  git clone https://github.com/tmux-plugins/tmux-prefix-highlight.git "${HOME}/.tmux/plugins/tmux-prefix-highlight"
fi

echo "==> Setting shell to zsh..."
chsh -s /usr/bin/zsh

echo "==> Creating dev directories"
mkdir -p /root/workspace

if [ ! -d /root/workspace/dotfiles ]; then
  echo "==> Setting up dotfiles"
  # the reason we dont't copy the files individually is, to easily push changes
  # if needed
  cd "/root/workspace"
  git clone --recursive https://github.com/ranrotx/dotfiles.git

  cd "/root/workspace/dotfiles"
  git remote set-url origin git@github.com:ranrotx/dotfiles.git

  ln -sfn $(pwd)/vimrc "${HOME}/.vimrc"
  ln -sfn $(pwd)/zshrc "${HOME}/.zshrc"
  ln -sfn $(pwd)/tmuxconf "${HOME}/.tmux.conf"
  ln -sfn $(pwd)/git-prompt.sh "${HOME}/.git-prompt.sh"
  ln -sfn $(pwd)/gitconfig "${HOME}/.gitconfig"
fi


if [ ! -f "/root/secrets/pull-secrets.sh" ]; then
  echo "==> Creating pull-secret.sh script"

cat > pull-secrets.sh <<'EOF'
#!/bin/bash

set -eu

echo "Authenticating with 1Password"
export OP_SESSION_my=$(op signin https://my.1password.com ronnie@ronnieeichler.com --output=raw)

echo "Pulling secrets"

#op get document 'github_rsa' > github_rsa
#op get document 'zsh_private' > zsh_private
#op get document 'zsh_history' > zsh_history

rm -f ~/.ssh/github_rsa
ln -sfn $(pwd)/github_rsa ~/.ssh/github_rsa
chmod 0600 ~/.ssh/github_rsa

ln -sfn $(pwd)/zsh_private ~/.zsh_private
ln -sfn $(pwd)/zsh_history ~/.zsh_history

echo "Done!"
EOF

  mkdir -p /root/secrets
  chmod +x pull-secrets.sh
  mv pull-secrets.sh ~/secrets
fi


Set correct timezone
timedatectl set-timezone America/Chicago

echo ""
echo "==> Done!"
