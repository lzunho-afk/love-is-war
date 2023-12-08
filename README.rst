Love is War
===========
Eliw (Engine Love is War) é uma engine para construção de jogos 2D e de jogos
no estilo clássico de **DOOM** com suporte frágil para dispositivos Android, 
sendo uma opção ótima para construção de um verdadeiro passatempo para todos os
casais de plantão! Aqui, é possível ter todas as armas necessárias para a vitória
nessa grande guerra do amor-*cof-cof*.

Esse repositório armazena o código e metadados da engine principal
LoveIsWar (engine 2D). Para acessar a engine em desenvolvimento,
voltada para jogos no estilo *DOOM*, acesse o `repositório
secundário`.

.. _repositório secundário: https://github.com/lzunho-afk/love-is-war-doom

Para acessar a documentação do código e os textos de desenvolvimento,
por favor acesse o `pages do projeto`_. Como alternativa, é possível realizar
a compilação da documentação com o sphinx de maneira manual, processo explicado
em `Compilando a Documentação do Projeto`_.

.. _pages do projeto: https://lzunho-afk.github.io/love-is-war

Compilando a Documentação do Projeto
====================================
Para compilar a documentação e os respectivos comentários do código-fonte 
é possível utilizar o make (para usuários baseados em linux), o script
batch "make.bat" (para usuário de windows) ou o próprio sphinx (suporte
múltiplo).

* Para compilar com o make, utilize o comando ``make sphinx-docs``
* Com o script batch, execute-o da seguinte forma ``make.bat bdocs``
* Com o sphinx, utilizamos o **sphinx-apidoc** dentro do diretório *docs* e executamos o **sphinx-build**, da seguinte forma:

  .. code-block:: bash

    $ sphinx-apidoc -MPfe -o . .. ../setup.py ../loveiswar.py

  .. code-block:: bash

    $ sphinx-build . _build/
