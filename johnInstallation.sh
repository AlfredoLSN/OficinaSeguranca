#!/bin/bash
set -e

echo "=== Instalando dependências básicas ==="
sudo apt-get update
sudo apt-get -y install git build-essential libssl-dev zlib1g-dev

echo "=== Instalando pacotes recomendados (extra formatos e desempenho) ==="
sudo apt-get -y install yasm pkg-config libgmp-dev libpcap-dev libbz2-dev

echo "=== Clonando o repositório bleeding-jumbo do John the Ripper ==="
if [ -d "john" ]; then
    echo "Repositório 'john' já existe. Atualizando..."
    cd john
    git pull
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
echo "O binário está disponível em: ~/src/john/run/john"
