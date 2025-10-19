#!/usr/bin/env bash
set -euo pipefail

ARQ="100k-most-used-passwords-NCSC.txt"
SAIDA="listaSenhas.txt"

if [ ! -f "$ARQ" ]; then
  echo "Arquivo '$ARQ' não encontrado!"
  exit 1
fi

# Remove as primeiras 2000 linhas e grava no arquivo de saída
sed '1,2500d' "$ARQ" > "$SAIDA"

echo "Arquivo gerado: $SAIDA"
