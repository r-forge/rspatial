# Copyright Barry Rowlingson <b.rowlingson@lancaster.ac.uk>
# moderately generic .First.lib function
#
.First.lib <- function(lib,pkg)
{
  cat("\nEpiR alpha-test version\n")
  library.dynam("EpiR", pkg, lib)
  invisible(0)
}

