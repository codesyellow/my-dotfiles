#!/usr/bin/env bash

function process_app_info() {
  id=$(echo "$1" | jq -r '.app_id // .window_class // "N/A"')
  title=$(echo "$1" | jq -r '.title // "N/A"')

  echo "TITLE=$title"
  echo "ID/CLASS=$id"

  echo -e "Title: $title\nID: $id" | wl-copy
  notify-send "App info copied!"
}

function prop() {
  local windows_json
  windows_json=$(niri msg -j windows)

  # Gera geometria para o slurp.
  # Para janelas tiled, usamos 0,0 como base pois o foco é capturar o WxH.
  local selection
  selection=$(echo "$windows_json" | jq -r '.[] | 
        if .is_floating then 
            "\(.layout.tile_pos_in_workspace_view[0]|floor),\(.layout.tile_pos_in_workspace_view[1]|floor) \(.layout.window_size[0])x\(.layout.window_size[1])" 
        else 
            "0,0 \(.layout.window_size[0])x\(.layout.window_size[1])" 
        end' | grep -v "null" | slurp -r)

  [[ -z "$selection" ]] && exit 1

  # Extrai Largura e Altura
  local w h
  w=$(echo "$selection" | awk -F'[ x]' '{print $2}')
  h=$(echo "$selection" | awk -F'[ x]' '{print $3}')

  # Busca a janela batendo o tamanho (arredondado para evitar floats do niri)
  local window
  window=$(echo "$windows_json" | jq ".[] | select((.layout.window_size[0]|floor) == ${w%.*} and (.layout.window_size[1]|floor) == ${h%.*})" | head -n 1)

  if [[ -z "$window" || "$window" == "null" ]]; then
    echo "Nenhuma janela encontrada com tamanho ${w}x${h}."
    exit 1
  fi

  if [[ "$1" == "id" ]]; then
    process_app_info "$window"
  else
    echo "$window" | jq
  fi
}

check_dependencies() {
  for cmd in jq slurp niri wl-copy; do
    command -v "$cmd" >/dev/null 2>&1 || {
      echo "Erro: $cmd não instalado."
      exit 1
    }
  done
}

check_dependencies
prop "$1"
