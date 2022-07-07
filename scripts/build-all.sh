# /bin/bash

mkdir -p build
mkdocs build -f config/en/mkdocs.yml
mkdocs build -f config/zh/mkdocs.yml
cp docs/index.html build/index.html