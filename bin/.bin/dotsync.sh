#!/usr/bin/env bash

cd "$HOME/.dotfiles" || {
  echo "Erro: Diretório ~/.dotfiles não encontrado."
  exit 1
}

# Adiciona possíveis mudanças
git add -A

# Verifica se há algo no 'staging area'
if git diff --cached --quiet; then
  echo "Nada para commitar. Tudo atualizado!"
  exit 0
fi

# Se chegou aqui, há mudanças
echo -e "\n--- Arquivos para o commit ---"
git status --short

echo -e "\nDigite a mensagem do commit (ou Enter para 'update'):"
read -r message

[ -z "$message" ] && message="update"

git commit -m "$message"
git push origin main
