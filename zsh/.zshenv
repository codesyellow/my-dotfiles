set -U PATH path
path=(
    "$HOME/.bin" 
    "$HOME/.cargo/bin" 
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
    "$HOME/.projects/python/own" 
    "$HOME/.wk" 
    "$HOME/.local/share/cargo/bin"
    "$HOME/.local/bin" 
    "$HOME/.dwm/bar-scripts/" 
    "$HOME/.config/emacs.d/bin" 
    "$HOME/.local/share/gem/ruby/3.2.0/bin"
    "$HOME/.nix-profile/bin"
    "$HOME/.local/share/flatpak/exports/bin"
    "/var/lib/flatpak/exports/bin"
    "$path[@]"
)
export PATH

export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share"
