if(!exists("Sys.setenv", envir = baseenv()))
   Sys.setenv <- Sys.putenv
   .GRASS_old.GRASS_PAGER <- ""
   .GRASS_old.GRASS_MESSAGE_FORMAT <- ""

.First.lib <- function(lib, pkg) {
  if (Sys.getenv("OSTYPE") == "cygwin") {
    cygwin_clean_temp(verbose=FALSE)
    packageStartupMessage("Cygwin temp directory flushed\n", appendLF = FALSE)
  }
  require("sp")
  .GRASS_old.GRASS_PAGER <- Sys.getenv("GRASS_PAGER")
  Sys.setenv("GRASS_PAGER"="cat")
  .GRASS_old.GRASS_MESSAGE_FORMAT <- Sys.getenv("GRASS_MESSAGE_FORMAT")
  Sys.setenv("GRASS_MESSAGE_FORMAT"="text")

  gv <- Sys.getenv("GRASS_VERSION")
  if (nchar(gv) == 0) gv <- "(GRASS not running)"
  loc <- Sys.getenv("LOCATION_NAME")

  Smess <- paste('GRASS GIS interface loaded ',
    'with GRASS version: ', gv, '\n',
    ifelse(nchar(loc) == 0, '', paste('and location: ', loc, '\n', sep="")),
      sep="")
  packageStartupMessage(Smess, appendLF = FALSE)
  require("rgdal")
}

.Last.lib <- function(lib, pkg) {
    Sys.setenv("GRASS_PAGER"=.GRASS_old.GRASS_PAGER)
    Sys.setenv("GRASS_MESSAGE_FORMAT"=.GRASS_old.GRASS_MESSAGE_FORMAT)
}

