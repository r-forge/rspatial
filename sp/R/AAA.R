#require(methods)
#
#.First.lib <- function(libname, pkgname){
#    library.dynam("sp", pkgname, libname)
#}
.noGenerics <- TRUE

.onLoad <- function(lib, pkg) require(methods)

.onUnload <- function(libpath)
    library.dynam.unload("sp", libpath)

