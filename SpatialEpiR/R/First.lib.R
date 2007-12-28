# Copyright Barry Rowlingson <b.rowlingson@lancaster.ac.uk>
# moderately generic .First.lib function
#
.First.lib <- function(lib,pkg)
{
  cat("\nSPatialEpiR alpha-test version\n")
  library.dynam("SpatialEpiR", pkg, lib)
  invisible(0)
}

