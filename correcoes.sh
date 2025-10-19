#!/usr/bin/env bash
set -euo pipefail

ARQ="100k-most-used-passwords-NCSC.txt"
SAIDA="listaSenhas.txt"
LINHAS=2500

echo "=== Instalando dependências básicas ==="
sudo apt-get update
sudo apt-get -y install git build-essential libssl-dev zlib1g-dev

echo "=== Instalando pacotes recomendados (extra formatos e desempenho) ==="
sudo apt-get -y install yasm pkg-config libgmp-dev libpcap-dev libbz2-dev

echo "=== Clonando/atualizando o repositório bleeding-jumbo do John the Ripper ==="

if [ -d "john" ]; then
    echo "Repositório 'john' já existe. Atualizando..."
    cd john
    git pull --rebase --autostash || git pull
else
    git clone https://github.com/openwall/john -b bleeding-jumbo john
    cd john
fi

echo "=== Compilando o John the Ripper ==="
cd src
./configure
make -s clean
make -sj4

echo "=== Compilação concluída com sucesso! ==="
echo "O binário está disponível em: $HOME/src/john/run/john"

echo "=== Verificando arquivo de senhas ==="
cd /home/ice/security_workshop
if [ ! -f "$ARQ" ]; then
  echo "Arquivo '$ARQ' não encontrado no diretório $(pwd) ou no diretório atual onde o script foi executado."
  echo "Coloque '$ARQ' no diretório corrente e execute novamente, ou altere a variável ARQ no script."
  exit 1
fi

TOTAL=$(wc -l < "$ARQ" | tr -d ' ')
if [ "$TOTAL" -le "$LINHAS" ]; then
  echo "O arquivo tem $TOTAL linhas (<= $LINHAS). Nada a cortar. Produzindo arquivo de saída vazio."
fi

echo "=== Removendo as primeiras $LINHAS linhas de $ARQ ==="
sed "1,${LINHAS}d" "$ARQ" > "$SAIDA"

echo "Arquivo gerado: $SAIDA"
