# Copyright (c) 2003-4 by Barry Rowlingson and Roger Bivand

setClass("CRS", representation(projargs = "character"),
    		prototype(projargs = character(1)),
		validity = function(object) {
			if (!is.na(object@projargs)) {
#modernise try() later TODO
				res <- try(library(spproj))
				if (class(res) == "try-error") {
					res <- list(FALSE, "No spproj library")
				} else {
					res <- .Call("checkCRSArgs", 
						object@projargs,
						PACKAGE="spproj")
				}
			} else res <- list(TRUE, as.character(NA))
			if (!res[[1]]) {
			    return(res[[2]])
			} else {
			return(res[[1]])
			}
		}
)

"CRS" <- function(projargs) {
    res <- new("CRS", projargs=projargs)
    tst <- validObject(res)
    if (is(tst, "logical") & tst) return(res)
    else stop(tst)
}


"CRSargs" <- function(object) {
	if (!is(object, "CRS")) stop("not a CRS object")

# check dependencies later TODO
	if (!is.na(object@projargs) && 
			is.loaded("checkCRSArgs", PACKAGE="spproj"))
		return(.Call("checkCRSArgs", object@projargs, 
			PACKAGE="spproj")[[2]])
	else return(as.character(NA))
}


"print.CRS" <- function(x, ...)
{
	cat("CRS arguments:", x@projargs, "\n")
}

setMethod("show", "CRS", function(object) print.CRS(object))

