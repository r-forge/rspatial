#ifdef R
require(methods)

.First.lib <- function(libname, pkgname){
	library.dynam("sp", pkgname, libname)
}
#else
NROW <- nrow
NCOL <- ncol
llines <- lines
ltext <- text
lpoints <- points
#endif
