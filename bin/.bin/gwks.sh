xprop -id $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) WM_CLASS | awk -F '"' '{print $2}' >> ~/.config/qtile/configs/game_classes
