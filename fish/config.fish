fish_vi_key_bindings

set PATH $PATH ~/.local/bin /snap/bin

function fish_greeting
  figlet avdzm | lolcat ;
  colorscript -r
end

function apti
  echo "apt installing " $argv
  sudo apt install $argv
end

function apts
  apt search $argv
end

function ex
  if test -n $argv
    switch $argv
      case '*.tar.bz2' '*.tbz2'
        tar xjf $argv
      case '*.tar.gz' '*.tgz'
        tar xzf $argv
      case '*.bz2'
        bunzip2 $argv
      case '*.rar'
        unrar x $argv
      case '*.gz'
        gunzip $argv
      case '*.tar' '*.tar.xz'
        tar xf $argv
      case '*.zip'
        unzip $argv
      case '*.Z'
        uncompress $argv
      case '*.7z'
        7z x $argv
      case '*.deb'
        ar x $argv
      case '*.tar.zst'
        tar -I zstd -xf $argv
      case '*'
        echo "'$argv' cannot be extracted via ex"
    end
  end
end



#function aptupg
#  echo "Running apt update and upgrade..."
#  sudo apt update && sudo apt uprgade
#end

alias vifm "$HOME/.config/vifm/scripts/vifmrun"
alias ls="exa --icons" 
alias ll="exa -l --icons" 
alias l.='exa -a | egrep "^\."'

alias df="df -h" 
alias free="free -h" 
alias wget="wget -c"
alias surf="tabbed -c surf -e"
alias aptac="echo 'Running apt auto clean' ;sudo apt autoclean"
alias aptupg="echo 'Running apt update and upgrade'; sudo apt update && sudo apt upgrade"
alias aptar="echo 'autoremove apt packages'; sudo apt autoremove"
