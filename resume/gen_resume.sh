#!/bin/bash

cd $(dirname $0) || exit 1
julia gen_resume.jl

latexmk --xelatex -silent --interaction=nonstopmode resume.tex
mv resume.pdf ../downloads
