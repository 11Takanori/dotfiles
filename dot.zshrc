# 環境変数
export LANG=ja_JP.UTF-8
export KCODE=u # KCODEにUTF-8を設定

## 色を使用出来るようにする
autoload -Uz colors
colors
export LESS='-R'

## 補完機能を有効にする
autoload -Uz compinit
compinit

## タブ補完時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

## 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1

## 補完候補の色づけ
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

## 日本語ファイル名を表示可能にする
setopt print_eight_bit

# 第1引数がディレクトリだと自動的に cd を補完
setopt auto_cd

## 色を使う
setopt prompt_subst

## ビープを鳴らさない
setopt nobeep

## 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs

## 補完候補一覧でファイルの種別をマーク表示
setopt list_types

## サスペンド中のプロセスと同じコマンド名を実行した場合はリジューム
setopt auto_resume

## 補完候補を一覧表示
setopt auto_list

## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups

## cd 時に自動で push
setopt autopushd

## 同じディレクトリを pushd しない
setopt pushd_ignore_dups

## ファイル名で #, ~, ^ の 3 文字を正規表現として扱う
setopt extended_glob

## TAB で順に補完候補を切り替える
setopt auto_menu

## zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history

## =command を command のパス名に展開する
setopt equals

## --prefix=/usr などの = 以降も補完
setopt magic_equal_subst

## ヒストリを呼び出してから実行する間に一旦編集
setopt hist_verify

# ファイル名の展開で辞書順ではなく数値的にソート
setopt numeric_glob_sort

## 出力時8ビットを通す
setopt print_eight_bit

## ヒストリを共有
setopt share_history

## カッコの対応などを自動的に補完
setopt auto_param_keys

## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

## スペルチェック
#setopt correct

# ディレクトリ移動履歴保存
setopt auto_pushd

## 出力の文字列末尾に改行コードが無い場合でも表示
unsetopt promptcr

## コアダンプサイズを制限
limit coredumpsize 102400

## ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# エイリアスコマンド
# alias diff=colordiff

alias ls='ls -GF'
alias la='ls -a'
alias ll='ls -al'
alias l='ls -CF'

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

alias be='bundle exec'
alias bu='bundle update'
alias bi='bundle install'

alias g='git'

## cdしたあとでlsする
function chpwd() { ls }

# bindkey
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^X^F' forward-word
bindkey '^X^B' backward-word
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

## PROMPT
local HOSTNAME_COLOR=$'%{\e[38;5;190m%}'
local USERNAME_COLOR=$'%{\e[38;5;199m%}'
local PATH_COLOR=$'%{\e[38;5;61m%}'
local RUBY_COLOR=$'%{\e[38;5;31m%}'
local VCS_COLOR=$'%{\e[38;5;248m%}'

# vcs_infoロード
autoload -Uz vcs_info

# vcsの表示
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b] (%a)'

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '¹'  # display ¹ if there are unstaged changes
zstyle ':vcs_info:git:*' stagedstr '²'    # display ² if there are staged changes
zstyle ':vcs_info:git:*' formats '[%b]%c%u'
zstyle ':vcs_info:git:*' actionformats '[%b|%a]%c%u'

# rubyバージョンの表示
function ruby_prompt {
result=`rbenv version | sed -e 's/ .*//'`
if [ "$result" ] ; then
echo "[$result]"
fi
}

# ホスト名
local HOSTNAME=`scutil --get LocalHostName`
function box_name {
  echo ${HOSTNAME} || hostname
}

# プロンプト表示直前にvcs_info呼び出し
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

RUBY_INFO=$'%{$RUBY_COLOR%}$(ruby_prompt)%{${reset_color}%}'
RPROMPT="${RUBY_INFO}%{${reset_color}%}"
PROMPT=$'%{$fg[yellow]%}%n%{$fg[red]%}@$fg[green]%}$(box_name) %{$fg[cyan]%}%~ %1(v|%F{green}%1v%f|)\n%{$fg[green]%}%#%{$reset_color%}'

# rbenvの設定
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi

# 3秒以上かかった処理は詳細表示
REPORTTIME=3

export PATH=/usr/local/sbin:$PATH
export PATH=$PATH:/usr/local/opt/mysql@5.6/bin
# export PATH=$PATH:/usr/local/Cellar/redis@2.6/2.6.17/bin
# export PATH=$PATH:/usr/local/Cellar/redis/4.0.0/bin
export GOPATH=$HOME/src/go

fpath=(/usr/local/share/zsh-completions $fpath)

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

function peco-less {
  exec ack "$@" . | peco --exec 'awk -F : '"'"'{print "+" $2 " " $1}'"'"' | xargs less -N '
}
alias pl="peco-less"

function peco-open-by-atom {
  exec ack "$@" . | peco --exec 'awk -F : '"'"'{print $1 ":" $2}'"'"' | xargs atom '
}
alias pa="peco-open-by-atom"

function peco-select-history {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

function peco-pkill() {
  for pid in `ps aux | peco | awk '{ print $2 }'`
  do
    kill $pid
    echo "Killed ${pid}"
  done
}
alias pk="peco-pkill"

function peco-git-add() {
  git status -s | peco | awk '{ print $2 }' | xargs git add
}
alias pga="peco-git-add"

# tmux上でのコピーをクリップボードへ
if [ -n "$TMUX" ]; then
  alias pbcopy="reattach-to-user-namespace pbcopy"
fi
alias tc='tmux save-buffer - | pbcopy'
