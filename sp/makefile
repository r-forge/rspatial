Sdir        = S
Rdir        = R

Sdest       = ../sp.S

Sfiles      = $(wildcard $(Sdir)/*.q)
Rfiles      = $(wildcard $(Rdir)/*.R)

R-target: 
	./scripts/qtoR $(Sdir) $(Rdir) $(Sfiles)
	find $(Sdir)/* scripts/* makefile > .Rbuildignore
	cat $(Sdir)/src/rdef $(Sdir)/src/pip.c > src/pip.c # adds #define USING_R 1

S-Plus:
	./scripts/toSplus $(Sdir) $(Sdest)
	./scripts/preproc.pl -v SP5 $(Sdir)/src/pip.c > $(Sdest)/pip.c

clean:;
