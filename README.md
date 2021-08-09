# dotfiles

## for macOS

1. `./configure-macos.zsh` installs essential softwares, taking a long time. Note that there are some manual tasks.
1. `cp .zshrc ~/`
1. VS Code: `cp vscode.json ~/Library/Application\ Support/Code/User/settings.json` (vice versa for export)
1. VS Code Extensions: `for e in $(cat vscode-extensions.txt); do code --install-extension $e; done` (export: `code --list-extensions > vscode-extensions.txt`)
1. Google IME: `cp JapaneseInput/*.db ~/Library/Application\ Support/Google/JapaneseInput/` (REBOOT REQUIRED) (vice versa for export)

## for Windows

1. ``cp .zshrc ~/` on WSL.
1. VS Code: `cp vscode.json /mnt/c/Users/hideo54/AppData/Roaming/Code/User/settings.json` on WSL. Restarting VS Code is required to reflect font settings.
1. VS Code Extensions: `for e in $(cat vscode-extensions.txt); do code --install-extension $e; done` on WSL. Some may fail.
1. TBA

## 日本語等幅フォント

日本語等幅フォントとして [Firge](https://github.com/yuru7/Firge) を気に入ったが、Homebrew の [cask-fonts](https://github.com/Homebrew/homebrew-cask-fonts) には収録されていない。足そうかと思ったが、[CONTRIBUTING.md](https://github.com/Homebrew/homebrew-cask-fonts/blob/master/CONTRIBUTING.md) に

> We accept fonts from other sources but they must be provably popular, like JetBrains Mono and iA Fonts.

と書いてあるのを見てチキってしまった。というわけで、[手動でインストール](https://github.com/yuru7/Firge/releases)されたい。
