# /bin/bash

mkdir -p generated
mkdocs build -f config/en/mkdocs.yml
mkdocs build -f config/zh/mkdocs.yml
cp docs/index.html generated/index.html