Sdir        = S
Rdir        = R
Sdest       = ../sp.S
SEXEC       = Splus

Sfiles      = $(wildcard $(Sdir)/*.q)
Rfiles      = $(wildcard $(Rdir)/*.R)

R-target:  # can't use `R' as make target -- it's a directory
	./scripts/qtoR $(Sdir) $(Rdir) $(Sfiles)
	find $(Sdir)/* scripts/* makefile > .Rbuildignore
	echo CHANGES >> .Rbuildignore
	cat $(Sdir)/src/rdef $(Sdir)/src/pip.c > src/pip.c # adds #define USING_R 1
	cat $(Sdir)/src/rdef $(Sdir)/src/insiders.c > src/insiders.c # adds #define USING_R 1

S-Plus:
	./scripts/toSplus $(Sdir) $(Sdest)
	./scripts/preproc.pl -v SP5 $(Sdir)/src/pip.c > $(Sdest)/pip.c
	./scripts/preproc.pl -v SP5 $(Sdir)/src/insiders.c > $(Sdest)/insiders.c
	(cd $(Sdest); $(SEXEC) CHAPTER)
	rm -f $(Sdest)/.Data/.Audit
	(cd $(Sdest); $(SEXEC) make)
	make S-test

S-test:
	echo "options(echo=T)" > $(Sdest)/tests.pass
	tail -q -n +3 tests/[^f]*.R >> $(Sdest)/tests.pass
	echo "options(echo=T)" > $(Sdest)/tests.fail
	tail -q -n +3 tests/f*.R >> $(Sdest)/tests.fail
	(cd $(Sdest); $(SEXEC) < tests.fail > tests.fail.out 2>&1 )
	(cd $(Sdest); $(SEXEC) < tests.pass > tests.pass.out 2>&1 )

clean:
	rm -f $(Rdir)/*.R ; rm -f src/*.c src/*.o src/*.so

veryclean:
	rm -fr $(Sdest)
