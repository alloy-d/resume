redo-ifchange $1.tex
TMPDIR="$3-dir"
TEXARGS="-output-directory $TMPDIR $1.tex"
mkdir $TMPDIR
pdflatex $TEXARGS > /dev/null
pdflatex $TEXARGS > /dev/null
mv $TMPDIR/resume.pdf $3
rm -rf $TMPDIR
