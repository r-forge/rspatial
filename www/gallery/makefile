.SUFFIXES: .pdf .png .ps .R
VPATH = ..

R		= R --vanilla --quiet
figdir	= fig

RFILES	= $(wildcard ../fig*.R)
RRFILES	= $(wildcard fig*.R)
HTML	= figs.html

#PDFS	= $(RFILES:.R=.pdf)
#PDFS	= $(addprefix $(figdir)/,$(RFILES:.R=.pdf))
PDFS	= $(notdir $(RFILES:.R=.pdf))
PDFOPTS	= ", width=8, height=8, version=\"1.4\""

PNGS	= $(notdir $(RFILES:.R=.png))
PNGOPTS	= ", w=800, h=800"

PSS		= $(notdir $(RFILES:.R=.ps))
PSOPTS	= ", width=8, height=8, onefile=FALSE, paper=\"special\""

all:
	(cd fig; make -f ../makefile figs)
	make index.html gallery.R

figs:	$(PDFS) $(PNGS) $(PSS)

allnox:
	(cd fig; make -f ../makefile noxfigs)
	make index.html

noxfigs:	$(PDFS) $(PSS)

index.html:	$(RRFILES) makehtml
	./makehtml $(RRFILES) > index.html

gallery.R:	$(RRFILES)
	cat $(RRFILES) > gallery.R
	cp gallery.R ../../sp/demo

.R.pdf:
	echo "pdf(\""$@"\"" $(PDFOPTS) ")" > first.R
	cat first.R $< > all.R
	$(R) < all.R

.R.png:
	#echo "png(\""$@"\"" $(PNGOPTS) ")" > first.R
	#echo "library(GDD); GDD(\""$@"\"" $(PNGOPTS) ")" > first.R
	echo "png(\""$@"\"" $(PNGOPTS) ")" > first.R
	cat first.R $< > all.R
	$(R) < all.R

.R.ps:
	echo "postscript(\""$@"\"" $(PSOPTS) ")" > first.R
	cat first.R $< > all.R
	$(R) < all.R
	
.tex.dvi:
	latex $<

clean:
	rm -f fig/*pdf fig/*ps fig/*png fig/*.R
