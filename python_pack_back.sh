#!/bin/bash
pip freeze >  req.txt
pip install -r  req.txt
pip download  -r req.txt -d  ./backup
pip install --no-index --find-links=./backup -r req.txt
