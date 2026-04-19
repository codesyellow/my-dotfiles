sud=sudo

function :wi() {
  xprop | awk '
  /^WM_CLASS/{sub(/.* =/, "instance:"); sub(/,/, "\nclass:"); print}
  /^WM_NAME/{sub(/.* =/, "title:"); print}'
}

alias change_title='xdotool selectwindow set_window --name "scratchpad"'
alias change_class='xdotool selectwindow set_window --class "esdf"'

alias lp='{(comm -23 <(yay -Qqe | sort) <({(pactree -u -d 1 base)&&(yay -Qqg base-devel);} | sort))&&(comm -23 <(yay -Qqtt | sort) <(yay -Qqt | sort));} | sort | uniq  | less'

# defaults
alias :c='clear'
alias :m='mkdir -p'
alias :fp='chmod +x'
alias :tx='tar xvf'
alias :r='rm'
alias :rr='rm -rf'

# systemctl
alias :st="systemctl start"
alias :ss="systemctl status"
alias :sp="systemctl stop"
alias :sr="systemctl restart"
alias :se="systemctl enable"
alias :sen="systemctl enable --now"
alias :sd="systemctl daemon-reload"
# user
alias :set="systemctl --user start"
alias :ses="systemctl --user status"
alias :sep="systemctl --user stop"
alias :ser="systemctl --user restart"
alias :see="systemctl --user enable"
alias :seen="systemctl --user enable --now"
alias :sed="systemctl --user daemon-reload"

# move
alias :m3="mv ~/Downloads/*.mp3 ~/.music"

# tmux
alias :tl="tmux ls"

alias :!s="sudo !!"
# dotfiles
:dotfiles() {
  /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME "$@"
}

:dd() {
  :dotfiles diff
}

:ds() {
  :dotfiles push -u origin main
}

:dt() {
  :dotfiles status
}

:dc() {
  :dotfiles commit -m "$@"
}

:da() {
  :dotfiles add "$@"
}

# qtile
alias getWInfo='qtile cmd-obj -o cmd -f windows | less'

# arch
alias search='pacman -Ss'
alias lsm="exa -al --color=always --group-directories-first --icons"
alias ls="exa --icons"
alias :pu='yay'
alias :pc='checkupdates | wc -l'
alias :ps='pacman -Ss'
alias :pi='sudo pacman -S'
alias :pr='sudo pacman -Rs'
alias :po='$sud pacman -Qtdq | $sud pacman -Rns - && flatpak uninstall --unused'
alias :rma='rm -rf'

# niri
alias :sys_niri_add='systemctl --user add-wants niri.service'

alias :fi='flatpak install'
alias :fu='flatpak update'
alias :fr='flatpak uninstall'
alias :fo='flatpak uninstall --unused'

# make
alias smi='$sud rm config.h; make; $sud make install'

# xclip
alias pbcopy='xclip -selection clipboard'

# zsh
alias :sc='vim ~/.zshrc'
alias :sz='source ~/.zshrc'

# configs
alias :cp='$EDITOR ~/.config/picom/picom.conf'
alias :cz='$EDITOR ~/.zshrc'
alias :cza='$EDITOR ~/.aliases.zsh'
alias :czp='$EDITOR ~/.zshenv'
alias :cq='$EDITOR ~/.config/qtile/config.py'
alias :cv='$EDITOR ~/.vimrc'
alias :cvd='$EDITOR ~/.vim/defaults.vim'

# cpupower
alias boost="sudo cpupower frequency-set -g performance"
alias powersave="sudo cpupower frequency-set -g powersave"

# terminal apps
alias :v='$EDITOR'
alias :V='sudoedit'

# translate shell
alias :t="trans -sp -brief en:pt-br"
alias :tb="trans -p -brief pt-br:en"

# translate shell
translate() {
  trans -brief $1:$2 $3
}

:chd() {
    chdman createcd -i $1 -o $2
}
