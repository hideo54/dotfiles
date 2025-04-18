setopt PROMPT_SUBST # to call functions in PROMPT every time
PROMPT='
%K{green}%D{%H:%M:%S}%k $(cat /Users/hideo54/random-wikipedia-article.txt)

%F{#444444}%~%f $ '
HISTFILE=${HOME}/.zsh_history
SAVEHIST=1000
setopt appendhistory

set -u

preexec() {
    local current_time=$(date '+%H:%M:%S')

    echo -e "\e[42m$current_time\e[0m\n"
}


alias l='ls'
alias s='ls'
alias sl='ls'
alias sls='ls'

alias la='ls -a'

function lss() {
  ls -lh -d $(find $1)
}

# Use macos-trash (move files to trash)
if [ -f '/opt/homebrew/bin/trash' ]; then alias rm='trash'; fi

fpath=(~/.zsh $fpath)

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
  uplatex $1
  upbibtex ${1%tex}aux
  uplatex $1
  uplatex $1
  dvipdfmx ${1%tex}dvi
  rm ${1%tex}aux
  rm ${1%tex}bbl
  rm ${1%tex}blg
  rm ${1%tex}dvi
  rm ${1%tex}log
  rm ${1%tex}out
  rm ${1%tex}bcf
  rm ${1%tex}run.xml
  open ${1%tex}pdf
}

if [ -f '/opt/homebrew/bin/qpdf' ]; then
  function decrypt-pdf() {
    qpdf --decrypt --password=$2 $1 ${1%.pdf}_decrypted.pdf
    mv ${1%.pdf}_decrypted.pdf $1
  }
;fi

function mkv2mp4() {
  ffmpeg -i $1 -vf bwdif=1 -vcodec h264 -crf 18 -preset slow -acodec copy -c:s dvdsub ${1%mkv}mp4
}

function m2ts2mp4() {
  stream=(`ffmpeg -i "$1" 2>&1 | grep "Audio" | grep -o -e "0:[0-9]*" | sed -e "s/0:/-map 0:/"`)
  # numOfSubs=(`ffprobe -i "$1" -show_streams -select_streams s -loglevel fatal | grep '\[STREAM\]' | wc -l`)
  # if [ $numOfSubs -gt 0 ]; then
  if [ echo $1 | grep 字 ]; then
    ffmpeg -fix_sub_duration -itsoffset 0.7 -i "$1" "${1%.*}.srt"
    ffmpeg -i "$1" -vf bwdif=1 -vcodec h264 -crf 18 -preset slow -map 0:v ${stream[@]} -b:a 192k -map -0:s -c:s mov_text "${1%.*}.mp4"
  else
    ffmpeg -i "$1" -vf bwdif=1 -vcodec h264 -crf 18 -preset slow -map 0:v ${stream[@]} -b:a 192k "${1%.*}.mp4"
  fi
  touch -cm -d "$(stat -c "%.19y" $1)" "${1%.*}.mp4"
}

function anime2mp4 () {
  stream=(`ffmpeg -i "$1" 2>&1 | grep "Audio" | grep -o -e "0:[0-9]*" | sed -e "s/0:/-map 0:/"`)
  # numOfSubs=(`ffprobe -i "$1" -show_streams -select_streams s -loglevel fatal | grep '\[STREAM\]' | wc -l`)
  # if [ $numOfSubs -gt 0 ]; then
  if [ echo $1 | grep 字 ]; then
    #ffmpeg -fix_sub_duration -itsoffset 0.7 -i "$1" "${1%.*}.srt"
    #ffmpeg -i "$1" -vf bwdif=1 -vcodec h264 -tune animation -crf 18 -preset slow -map 0:v ${stream[@]} "${1%.*}.mp4"
  else
    ffmpeg -i "$1" -vf bwdif=1 -vcodec h264 -tune animation -crf 18 -b:a 192k -preset slow -map 0:v ${stream[@]} "${1%.*}.mp4"
  fi
  touch -cm -d "$(stat -c "%.19y" $1)" "${1%.*}.mp4"
}

function m3u82mp4() {
  ffmpeg -protocol_whitelist file,http,https,tcp,tls,crypto -i $1 -movflags faststart -c copy ${1%m3u8}mp4
}

function touchWithFile() {
  echo $1 | sed -r 's/^\[([0-9]+)-([0-9]+).*$/\1\2/' | xargs -I {} touch -cm -t {} $1
}

function yt-dlp-sub() {
  yt-dlp --write-auto-sub --sub-lang ja --convert-subs=srt --skip-download $1
}

if [ -f '/Applications/Hex\ Fiend.app' ]; then alias bin='open -a /Applications/Hex\ Fiend.app'; fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

eval "$(rbenv init -)"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

case `uname` in
    Darwin)
        ssh-add -q --apple-use-keychain
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

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

export GPG_TTY=$(tty)

eval "$(direnv hook zsh)"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true
