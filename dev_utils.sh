#!/bin/bash
# development.sh -- Script para manutenção do desenvolvimento do projeto LOVEISWAR
# autor: Lucas Zunho <lucaszunho17@gmail.com>
#
# Esse script recebe os inputs do usuário/desenvolvedor pela linha de comando e retorna
# um output conforme as necessidades postas, sejam elas atividades de manutenção, teste
# ou atualização do código fonte em questão.

function echo() {
    command echo -e "$@"
}

# verificando uso do python-is-python3.
# O script é fechado caso nenhuma versão (python ou python-is-python3) seja encontrada 
# com o comando command.
if ! command -v python &> /dev/null; then
    if ! command -v python3 &> /dev/null; then
        echo "python não encontrado! Fechando o script (code: 1)..."
        exit 1
    else
        PYEXE=`command -v python3`
    fi
else
    PYEXE=`command -v python`
fi
echo "[PYEXE] '$PYEXE'"

# Verificando se o script foi executando em um ambiente virtual
INVENV=`$PYEXE -c 'import sys; print("1" if hasattr(sys, "real_prefix") else "0")'`

if [ $INVENV == 0 ]; then
    echo "virtualenv não detectado!"
    echo "\t\\-> O programa instalará as dependências no sistema,"
    echo "\tutilize um venv caso queira fazer uma instalação local."
fi

PYINST="$PYEXE -m pip install -U"

help_panel() {
    echo "PAINEL DE AJUDA:"
    echo "================"
    echo
    echo "\t-h\t=> Exibe esse painel de ajuda."
    echo "\t-r\t=> Realiza um empacotamento com o pyinstaller."
    echo "\t"
}

# build_docs() -- Monta os arquivos para construção da documentação
# e executa o sphinx para efetivamente construí-la.
build_docs() {
    proot_pwd=`pwd`
    cd docs/
    sphinx-apidoc -MPfe -o . .. ../setup.py ../loveiswar.py
    make html
    cd "$proot_pwd"
}

# make_release() -- Realiza o empacotamento da engine para redistribuição de 
# software conforme necessário - (fazer mais opções no releasing).
make_release() {
    # Verificando/Atualizando as dependências
    $PYINST pip
    $PYINST -r requirements.txt

    # Construíndo a documentação
    build_docs

    # pyinstaller - building release
    $PYINST pyinstaller
    pyinstaller loveiswar.py

    cp -r ./docs/_build/ ./dist/loveiswar/docs/ # add. Documentação
    cp -r ./loveiswar/ ./dist/loveiswar/src/ # add. Código fonte
    cp -r ./assets/ ./dist/loveiswar/ # add. Arquivos de jogo
    cp ./LICENSE ./README.rst ./dist/loveiswar
}

for arg in "$@"
do
    if [ "$arg" == "--help" -o "$arg" == "-h" ]; then
        help_panel
    fi
done