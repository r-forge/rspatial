spkernel2d <- function(pts, poly, h0, grd, kernel = "quartic") {
    require(sp, quietly=TRUE)
    pts <- coordinates(pts)
    nptsk <- nrow(pts)
    npoly <- length(poly[, 1])
    poly <- rbind(poly, c(poly[1, 1], poly[1, 2]))
    a1 <- slot(grd, "cellcentre.offset")[1]
    a2 <- a1 + slot(grd, "cellsize")[1] * slot(grd, "cells.dim")[1]
    b1 <-  slot(grd, "cellcentre.offset")[2]
    b2 <- b1 + slot(grd, "cellsize")[2] * slot(grd, "cells.dim")[2]
    nx <- slot(grd, "cells.dim")[1]
    ny <- slot(grd, "cells.dim")[2]
    xgrid <- rep(0, nx)
    ygrid <- rep(0, ny)
    zgrid <- matrix(0, nx, ny)
    storage.mode(zgrid) <- "double"
    if (kernel == "quartic") {
        klist <- .Fortran("krnqrt", as.double(pts[, 1]), as.double(pts[, 
            2]), as.integer(nptsk), as.double(poly[, 1]), as.double(poly[, 
            2]), as.integer(npoly), as.double(h0), as.double(a1), 
            as.double(a2), as.double(b1), as.double(b2), as.integer(nx), 
            as.integer(ny), xgrid = as.double(xgrid), ygrid = as.double(ygrid), 
            zgrid = (zgrid), PACKAGE = "splancs")
        is.na(klist$zgrid) <- klist$zgrid < 0
        res <- c(klist$zgrid[,ncol(zgrid):1])
    }
    else {
        stop("Invalid kernel function specification")
    }
    res
}

.sp_lt_0.9 <- function() {
    sI <- sessionInfo(package="sp")
    spver <- sI$otherPkgs$sp$Version
    as.numeric(substring(spver, 1, 3)) < 0.9
}
