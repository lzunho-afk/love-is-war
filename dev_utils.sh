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

# verifica o uso do python-is-python3 e armazena o executável do python em $PYEXE.
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

# Armazenando as escape strings de cores do shell
ESC_RST="\e[0m"
ESC_RED="\e[1;31m"
ESC_GREEN="\e[1;32m"
ESC_BLUE="\e[1;34m"

# Verificando se o script foi executando em um ambiente virtual
INVENV=`$PYEXE -c 'import sys; print("1" if hasattr(sys, "real_prefix") else "0")'`

if [ $INVENV == 0 ]; then
    echo "$ESC_RED""virtualenv não detectado!$ESC_RST"
    echo "\t\\-> O programa instalará as dependências no sistema,"
    echo "\tutilize um venv caso queira fazer uma instalação local."
fi

PYINST="$PYEXE -m pip install -U"

help_panel() {
    cargs=("$@")
    echo "================"
    echo "PAINEL DE AJUDA:"
    echo "================"
    echo
    for arg in "${cargs[@]}";do
        IFS=";" read -r -a split_arg <<< "${arg}"
        echo "\t${split_arg[0]}/${split_arg[1]} => ${split_arg[2]}"
    done
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

declare -a cmd_args
cmd_args[0]="-h;--help;Exibe esse painel de ajuda"
cmd_args[1]="-r;--release;Realiza um empacotamento com o pyinstaller"
cmd_args[2]="-ideps;--install-dependencies;Instala/Atualiza as dependências do projeto com o pip"
cmd_args[3]="-d;--make-docs;Reúne e compila a documentação do código com sphinx"
cmd_args[4]="-cdocs;--clean-documentation;Remove a documentação gerada pelo sphinx"
cmd_args[5]="-ccache;--clean-cachefiles;Remove os arquivos de cache do projeto"

for arg in "$@"
do
    if [ "$arg" == "--help" -o "$arg" == "-h" ]; then
        help_panel "${cmd_args[@]}"
    fi
done
