import setuptools
import os

proj_root = os.path.dirname(os.path.realpath(__file__))

with open(proj_root + "/README.rst") as f:
    readme = f.read()

with open(proj_root + "/LICENSE") as f:
    license = f.read()

setuptools.setup(
    name='loveiswar',
    version='07.12.2023',
    description='Core Engine do jogo onde se deve guerrear pelo amor (LOVERPG)',
    long_description=readme,
    author='Lucas Zunho',
    author_email='lucaszunho17@gmail.com',
    url='https://lzunho-afk.github.io/love-is-war',
    locense=license,
    py_modules=setuptools.find_packages(exclude=('tests', 'docs'))
    )
