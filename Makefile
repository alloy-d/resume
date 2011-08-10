.PHONY: all

all: pdf

pdf: resume.tex
	pdflatex resume.tex
	pdflatex resume.tex
