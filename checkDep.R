depends <- function(pkg = "sp") {
    index <- readLines(sprintf("http://cran.r-project.org/web/packages/%s/index.html", pkg))
    if( any( grepl("Reverse.*depends", index) ) ){
        x <- index[ grep("Reverse.*depends", index) + 1L ]
        gsub( "<.*", "", strsplit( x, "<a href.*?>" )[[1L]] )[-1L]
    } else character(0L)
}

seen <- character(0)
graph <- character(0)

rec.depends <- function( pkg ){
    dep <- depends(pkg)
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
	cmd = paste("R CMD check", ret[i,2])
	#stopifnot(system(cmd) == 0)
	retval[i] = system(cmd) != 0
	#unlink(ret[i,2])
}
print(ret[retval, 1])
