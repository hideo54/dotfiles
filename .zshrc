PROMPT='%K{blue}%* %~%k $ '
HISTFILE=${HOME}/.zsh_history
SAVEHIST=1000
setopt appendhistory

set -u

alias l='ls'
alias s='ls'
alias sl='ls'
alias sls='ls'

alias la='ls -a'

function lss() {
  ls -lh -d $(find $1)
}

# Use rmtrash (move files to trash)
if [ -f '/usr/local/bin/rmtrash' ]; then alias rm='rmtrash'; fi

alias conf='vim ~/.zshrc && source ~/.zshrc'

alias suod='sudo'

alias gs='git status'
alias ga='git add'
alias gch='git checkout'
alias gc='git commit'
alias gpo='git push origin'

alias b='npm run build'
alias d='npm run develop'

function extract() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf $1;;
    *.tar.xz) tar Jxvf $1;;
    *.zip) unzip $1;;
    *.lzh) lha e $1;;
    *.tar.bz2|*.tbz) tar xjvf $1;;
    *.tar.Z) tar zxvf $1;;
    *.gz) gzip -d $1;;
    *.bz2) bzip2 -dc $1;;
    *.Z) uncompress $1;;
    *.tar) tar xvf $1;;
    *.arj) unarj $1;;
  esac
}

function gpp() {
  g++-9 $1 && ./a.out
}

function tehu() {
  platex $1
  platex $1
  dvipdfmx ${1%tex}dvi
  rm ${1%tex}log
  rm ${1%tex}aux
  rm ${1%tex}dvi
  open ${1%tex}pdf
}

function saty() {
  satysfi $1 -o ${1%saty}pdf
  rm ${1%saty}satysfi-aux
  open ${1%saty}pdf
}

function mkv2mp4() {
  ffmpeg -i $1 -vcodec h264 -acodec copy -c:s dvdsub ${1%mkv}mp4
}

function m2ts2mp4() {
  ffmpeg -i $1 -vcodec h264 -c:s mov_text ${1%m2ts}mp4
}

function anime2mp4 () {
  stream=(`ffmpeg -i "$1" 2>&1 | grep "Audio" | grep -o -e "0:[0-9]*" | sed -e "s/0:/-map 0:/"`)
  ffmpeg -i "$1" -vf bwdif=1 -vcodec h264 -tune animation -crf 18 -preset slow -map 0:v ${stream[@]} "${1%.*}.mp4"
  touch -cm -d "$(stat -c "%.19y" $1)" "${1%.*}.mp4"
}

function m3u82mp4() {
  ffmpeg -protocol_whitelist file,http,https,tcp,tls,crypto -i $1 -movflags faststart -c copy ${1%m3u8}mp4
}

if [ -f '/Applications/Hex\ Fiend.app' ]; then alias bin='open -a /Applications/Hex\ Fiend.app'; fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

case `uname` in
    Darwin)
        ssh-add -q -A
    ;;
    # Linux)
    # ;;
esac

# https://github.com/zsh-users/zsh/blob/master/Functions/Zle/url-quote-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/hideo54/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/hideo54/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/hideo54/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/hideo54/google-cloud-sdk/completion.zsh.inc'; fi