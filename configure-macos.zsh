HOSTNAME="Kasumi"
sudo scutil --set HostName $HOSTNAME
sudo scutil --set LocalHostName $HOSTNAME
sudo scutil --set ComputerName $HOSTNAME
dscacheutil -flushcache

# Create SSH key for GitHub etc.
# https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
ssh-keygen -t ed25519 -C "hideo54@${HOSTNAME}.local"
cat ~/.ssh/id_ed25519.pub
echo 'Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519' >> ~/.ssh/config
ssh-add -K ~/.ssh/id_ed25519

# Deprecated because this configuration will not be reflected on System Preferences UI.
# Set up manually on System Preferences app.
# Replace caps lock with control
# keyboardid="$(ioreg -c AppleEmbeddedKeyboard -r | grep -Eiw "VendorID|ProductID" | awk '{ print $4 }' | paste -s -d'-\n' -)-0"
# defaults -currentHost write -g com.apple.keyboard.modifiermapping.${keyboardid} \
#     -array-add \
#     '<dict>
#       <key>HIDKeyboardModifierMappingDst</key>
#       <integer>2</integer>
#       <key>HIDKeyboardModifierMappingSrc</key>
#       <integer>0</integer>
#     </dict>' # REBOOT REQUIRED
# # Configure Dock
# defaults write com.apple.dock tilesize -int 128 # set maximum icon size
# defaults write com.apple.dock orientation -string "left"
# killall Dock

# Save screenshots to ~/Screenshots
mkdir ~/Screenshots
defaults write com.apple.screencapture location ~/Screenshots
killall SystemUIServer

# Create Products directory
mkdir ~/Products

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
UNAME_MACHINE="$(uname -m)"
if [[ "$UNAME_MACHINE" == "arm64" ]]; then # なんで arm64 に限ってるのか正直わからんが、上のスクリプトに従っている
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

sudo softwareupdate --install-rosetta

# Formulae
brew install go
brew install jq
brew install mas
brew install n
brew install pyenv
brew install rbenv

# Install the latest Node.js
sudo n latest

# Install the latest Python
latest_python_version=$(pyenv install --list | grep -E ' 3\.\d\.\d' | tail -n 1 | tr -d ' ')
pyenv install $latest_python_version
pyenv global $latest_python_version
echo 'eval "$(pyenv init --path)"' >> ~/.zprofile
source ~/.zprofile

latest_ruby_version=$(rbenv install -L | grep -e '^\d.*\d$' | tail -n 1)
rbenv install $latest_ruby_version
rbenv global $latest_ruby_version
echo 'eval "$(rbenv init -)"' >> ~/.zprofile
source ~/.zprofile

# Casks
brew install clipy
brew install cmd-eikana
brew install discord
brew install google-chrome
brew install google-japanese-ime
brew install iterm2
brew install keepingyouawake
brew install krisp # Reboot required for audio devices
brew install macos-trash
brew install mactex-no-gui
brew install mongodb-compass
brew install ngrok
brew install visual-studio-code
brew install vlc
brew install zoom
brew install 1password # because Mac App Store version does not support device license

# Fonts
brew tap hideo54/cask-fonts git@github.com:hideo54/homebrew-cask-fonts.git
brew install font-noto-sans-cjk-jp
brew install font-firge

# Set up menubar applications
open -a /Applications/⌘英かな.app
open -a /Applications/BetterTouchTool.app
open -a /Applications/Clipy.app
open -a /Applications/KeepingYouAwake.app

# Open Google Chrome to urge manual sign in before auto setting
open -a /Applications/Google\ Chrome.app

# Mac App Store applications
open -a /System/Applications/App\ Store.app # sign in manually
mas install 411213048 # LadioCast
mas install 417375580 # BetterSnapTool
mas install 497799835 # Xcode
mas install 539883307 # LINE
mas install 1295203466 # Microsoft Remote Desktop

# Install userscripts made by hideo54
curl https://api.github.com/repos/hideo54/userscripts/contents | jq '.[] | .path | "https://raw.githubusercontent.com/hideo54/userscripts/master/" + select(.|endswith(".user.js"))' | xargs open
curl https://api.github.com/repos/hideo54/userscripts/contents | jq '.[] | .path | "https://raw.githubusercontent.com/hideo54/userscripts/master/" + select(.|endswith(".user.css"))' | xargs open

# Set up essential git config
git config --global user.email "hideo54@hideo54.com"
git config --global user.name "Hideo Yasumoto"
git config --global pull.rebase false
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh > ~/.git-completion.zsh
