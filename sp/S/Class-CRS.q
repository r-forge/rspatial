# Copyright (c) 2003-4 by Barry Rowlingson and Roger Bivand

setClass("CRS", representation(projargs = "character"),
    		prototype = list(projargs = character(1)))

#ifdef SP5
strsplit <- function(a,b) { 
	if (a == as.character(NA)) 
		return(as.character(NA)) 
	else list(unlist(unpaste(a, b))) 
} 
#endif

"CRS" <- function(projargs) {
    if (is.na(projargs)) uprojargs <- projargs
    else uprojargs <- paste(unique(unlist(strsplit(projargs, " "))), 
	collapse=" ")
    res <- new("CRS", projargs=uprojargs)
    res
	## added test = TRUE; S-Plus otherwise breaks on the following is-test.
#    tst <- validObject(res, test = TRUE)
#    if (is(tst, "logical") && tst) 
#		return(res)
#    else 
#		stop(tst)
}



"print.CRS" <- function(x, ...)
{
	cat("CRS arguments:", x@projargs, "\n")
}

setMethod("show", "CRS", function(object) print.CRS(object))

