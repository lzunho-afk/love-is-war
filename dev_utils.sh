#!/bin/bash
# development.sh -- Script para manutenção do desenvolvimento do projeto LOVEISWAR
# autor: Lucas Zunho <lucaszunho17@gmail.com>
#
# Esse script recebe os inputs do usuário/desenvolvedor pela linha de comando e retorna
# um output conforme as necessidades postas, sejam elas atividades de manutenção, teste
# ou atualização do código fonte em questão.

INVENV=$(python -c 'import sys; print("1" if hasattr(sys, "real_prefix") else "0")')

# Verificando se o script foi executando em um ambiente virtual
# e realizando um alias caso o sistema não utilize python-is-python3.
if [ $INVENV == 0 ]; then
    echo "virtualenv não detectado!"
    echo -e "\t\\-> O programa instalará as dependências no sistema,"
    echo -e "\tutilize um venv caso queira fazer uma instalação local."
    if ! command -v python &> /dev/null; then
        echo "Exe. 'python' não encontrado, utilizando alias para 'python3'"
        alias python='python3'
    fi
fi

alias pyInst='python -m pip install -U'

help_panel() {
    alias echo='echo -e'
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
    pyInst pip
    pyInst -r requirements.txt

    # Construíndo a documentação
    build_docs

    # pyinstaller - building release
    pyInst pyinstaller
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
