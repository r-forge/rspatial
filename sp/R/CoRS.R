# Copyright (c) 2003 by Barry Rowlingson and Roger Bivand

setClass("CoRS", representation(projargs = "character"),
    		prototype(projargs = character(1)),
		validity = function(object) {
			if (!is.na(object@projargs))
				res <- .Call("checkCoRSArgs", object@projargs,
					PACKAGE="sp")
			else res <- list(TRUE, as.character(NA))
			if (!res[[1]]) {
			    return(res[[2]])
			} else {
			return(res[[1]])
			}
		}
)

"CoRS" <- function(projargs) {
    res <- new("CoRS", projargs=projargs)
    tst <- validObject(res)
    if (is(tst, "logical") & tst) return(res)
    else stop(tst)
}

"print.CoRS" <- function(x, ...)
{
	cat("CoRS arguments:", x@projargs, "\n")
}

setMethod("show", "CoRS", function(object) print.CoRS(object))

"CoRSargs" <- function(object) {
	if (!is(object, "CoRS")) stop("not a CoRS object")
	if (!is.na(object@projargs))
		return(.Call("checkCoRSArgs", object@projargs, 
			PACKAGE="sp")[[2]])
	else return(as.character(NA))
}


