#require(methods)
#
#.First.lib <- function(libname, pkgname){
#    library.dynam("sp", pkgname, libname)
#}

.onLoad <- function(lib, pkg) require(methods)

