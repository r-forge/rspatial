SWEAVE	= 	../../scripts/Sweave
R_LIBS	=	"/home/edzer/S/library"

all:	sp.tex
	TEXINPUTS="$$TEXINPUTS:.:/usr/lib/R/share/texmf" pdflatex sp.tex
	TEXINPUTS="$$TEXINPUTS:.:/usr/lib/R/share/texmf" pdflatex sp.tex
	make clean

sp.tex:	sp.Rnw
	$(SWEAVE) sp.Rnw

clean:
	rm -f sp.aux sp.log sp.out sp.tex texput.log Rplots.ps sp-*.pdf sp-*.eps
