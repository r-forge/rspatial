depends <- function(pkg = "sp") {
    index <- readLines(sprintf("http://cran.r-project.org/web/packages/%s/index.html", pkg))
    res <- character(0L)
    if( any( grepl("Reverse.*depends", index)) || any(grepl("Reverse.*imports", index)) ){
        if (any(grepl("Reverse.*depends", index))) x <- index[ grep("Reverse.*depends", index) + 1L ]
        res <- gsub( "<.*", "", strsplit( x, "<a href.*?>" )[[1L]] )[-1L]
        if (any(grepl("Reverse.*imports", index))) {x <- index[ grep("Reverse.*imports", index) + 1L ]
        res <- c(res, gsub( "<.*", "", strsplit( x, "<a href.*?>" )[[1L]] )[-1L])}
    }
    res 
}

seen <- character(0)
graph <- character(0)

rec.depends <- function( pkg ){
    dep <- unique(depends(pkg))
    if( !length(dep) ) return(NULL)
    graph <<- c( graph, sprintf( "%s->%s", pkg, dep ) )
    for(p in dep[!dep %in% seen]) rec.depends( p )
    seen <<- c( dep[!dep %in% seen] , seen )
}

rec.depends("sp")

url = "http://cran.at.r-project.org/src/contrib"
#install.packages(seen, contriburl = url, 
#	dependencies = c("Depends", "Imports", "LinkingTo", "Suggests"))
update.packages(contriburl=url)
ret = download.packages(seen, destdir = "/tmp", contriburl = url)
retval = rep(as.logical(NA), nrow(ret))
for (i in 1:nrow(ret)) {
	cmd = paste("_R_CHECK_FORCE_SUGGESTS_=FALSE R CMD check", ret[i,2])
#_R_CHECK_FORCE_SUGGESTS_=FALSE 
	#stopifnot(system(cmd) == 0)
	retval[i] = system(cmd) != 0
	#unlink(ret[i,2])
}
print(ret[retval, 1])
