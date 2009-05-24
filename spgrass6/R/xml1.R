parseGRASS <- function(cmd) {
    bin_out_win <- c("d.colors.exe", "d.save.exe", "d.what.rast.exe",
      "d.what.vect.exe", "d.zoom.exe", "g.parser.exe", "gis.m.bat",
      "i.spectral.bat", "mkftcap.bat", "r.mapcalc.exe", "r.tileset.bat",
      "r3.mapcalc.exe", "v.in.gpsbabel.bat", "v.proj.exe")
    if ((get("SYS", envir=.GRASS_CACHE) == "WinNat") && cmd %in% bin_out_win)
            stop(paste("No interface description:", cmd))
    cmdCACHE <- get("cmdCACHE", envir=.GRASS_CACHE)
    res <- cmdCACHE[[cmd]]
    if (is.null(res)) {
        ext <- get("addEXE", envir=.GRASS_CACHE)
        if (get("SYS", envir=.GRASS_CACHE) == "WinNat") {
            if (any(nchar(WN_bat <- get("WN_bat", envir=.GRASS_CACHE)) == 0)) {
                WN_bat <- sub(".bat", "", 
                list.files(paste(Sys.getenv("GISBASE"), "bin", sep="/"),
                    pattern=".bat$"))
                assign("WN_bat", WN_bat, envir=.GRASS_CACHE)
            }
        } else if (get("SYS", envir=.GRASS_CACHE) == "cygwin") {
            if (any(nchar(WN_bat <- get("WN_bat", envir=.GRASS_CACHE)) == 0)) {
                WN_bat <- list.files(system(paste("cygpath -w",
                    paste(Sys.getenv("GISBASE"), "scripts", sep="/")),
                    intern=TRUE))
                assign("WN_bat", WN_bat, envir=.GRASS_CACHE)
            }
        } else if (get("SYS", envir=.GRASS_CACHE) == "msys") {
            if (any(nchar(WN_bat <- get("WN_bat", envir=.GRASS_CACHE)) == 0)) {
                WN_bat <- list.files(paste(Sys.getenv("GISBASE"), "scripts",
                    sep="/"))
                assign("WN_bat", WN_bat, envir=.GRASS_CACHE)
            }
        }
        prep <- ""
        if ((get("SYS", envir=.GRASS_CACHE) == "WinNat") && cmd %in% WN_bat)
            ext <- ".bat"
        else if ((get("SYS", envir=.GRASS_CACHE) == "msys") &&
            cmd %in% WN_bat) {
                ext <- ""
                prep <- paste("sh.exe ", Sys.getenv("GISBASE"),
                    "/scripts/", sep="")
        } else if ((get("SYS", envir=.GRASS_CACHE) == "cygwin") &&
            cmd %in% WN_bat) {
                ext <- ""
                prep <- paste("sh.exe ", Sys.getenv("GISBASE"),
                    "/scripts/", sep="")
        }
        cmd0 <- paste(paste(prep, cmd, ext, sep=""), "--interface-description")
        tr <- try(system(cmd0, intern=TRUE))
	if (class(tr) == "try-error") stop(paste(cmd, "not found"))
        tr <- try(xmlTreeParse(tr))
	if (inherits(tr, "try-error")) stop(paste(cmd, "not parsed"))
        tr1 <- xmlChildren(xmlRoot(tr))
        res <- vector(mode="list", length=9)
        names(res) <- c("cmd", "description", "keywords", "parameters", "flags",
            "pnames", "fnames", "ext", "prep")
        res$cmd <- cmd
        res$ext <- ext
        res$prep <- prep
        res$description <- xmlValue(tr1[[1]])
        res$keywords <- xmlValue(tr1[[2]])
        o0 <- names(tr1)
        pseq <- which(o0 == "parameter")
        np <- length(pseq)
        ps <- vector(mode="list", length=np)
        for (i in seq(along=pseq)) {
            obj <- tr1[[pseq[i]]]
            pv <- xmlAttrs(obj)
            pv <- c(pv, xmlValue(xmlChildren(obj)[[1]]))
            names(pv) <- c(names(xmlAttrs(obj)), "desc")
            ps[[i]] <- pv
        }
        res$parameters <- ps
        fseq <- which(o0 == "flag")
        nf <- length(fseq)
        fs <- vector(mode="list", length=nf)
        for (i in seq(along=fseq)) {
            obj <- tr1[[fseq[i]]]
            fv <- xmlAttrs(obj)
            fv <- c(fv, xmlValue(xmlChildren(obj)[[1]]))
            names(fv) <- c(names(xmlAttrs(obj)), "desc")
            fs[[i]] <- fv
        }
        res$flags <- fs
        res$pnames <- sapply(res$parameters, function(x) x["name"])
        names(res$pnames) <- NULL
        res$fnames <- sapply(res$flags, function(x) x["name"])
        names(res$fnames) <- NULL
        class(res) <- "GRASS_interface_desc"
        cmdCACHE[[cmd]] <- res
        assign("cmdCACHE", cmdCACHE, envir=.GRASS_CACHE)
    } 
    res
} 

print.GRASS_interface_desc <- function(x, ...) {
    cat("Command:", x$cmd, "\n")
    if (nchar(x$ext) > 0) cat("Extension:", x$ext, "\n")
    if (nchar(x$prep) > 0) cat("Shell prefix:", x$ext, "\n")
    cat("Description:", x$description, "\n")
    cat("Keywords:", x$keywords, "\n")
    cat("Parameters:\n")
    for (i in x$parameters) cat("  name: ", i["name"], ", type: ",
        i["type"], ", required: ", i["required"], ", multiple: ",
        i["multiple"], "\n [", i["desc"], "]\n", sep="")
    cat("Flags:\n")
    for (i in x$flags) cat("  name: ", i["name"], " [",
        i["desc"], "]\n", sep="")
    invisible(x)
}

doGRASS <- function(cmd, flags=NULL, parameters=NULL) {
    if (!is.null(flags)) stopifnot(is.character(flags))
    if (!is.null(parameters)) stopifnot(is.list(parameters))
    pcmd <- parseGRASS(cmd)
    cmd <- paste(pcmd$prep, cmd, pcmd$ext, sep="")
    res <- cmd
    if (!is.null(flags)) {
        fm <- match(flags, pcmd$fnames)
        if (any(is.na(fm))) {
            print(pcmd)
            stop(paste("Invalid flag value:", flags[is.na(fm)]))
        }
        dble_dash <- c("verbose", "overwrite", "quiet")
        dbm <- na.omit(match(dble_dash, flags))
        if (length(dbm) > 0) flags[dbm] <- paste("-", flags[dbm], sep="")
        res <- paste(res, paste("-", flags, collapse=" ", sep=""))
    }
    pt <- do.call("rbind", pcmd$parameters)
    req <- pt[pt[, "required"] != "no", "name"]
# patch for multiple values Patrick Caldon 090524
    mult <- pt[pt[, "multiple"] != "no", "name"]
    if (length(req) > 0 && is.null(parameters)) {
        print(pcmd)
        stop("No parameters given where some are required")
    }
    if (!is.null(parameters)) {
        parnms <- names(parameters)
        pm <- match(parnms, pcmd$pnames)
        if (any(is.na(pm))) {
            print(pcmd)
            stop(paste("Invalid parameter name:", parnms[is.na(pm)]))
        }
        if (length(req) > 0) {
            pmr <- match(req, parnms)
            if (any(is.na(pmr))) {
                print(pcmd)
                stop(paste("Missing required parameter:", req[is.na(pmr)]))
            }
        }
        pmv <- pt[pm, "type"]
# patch for multiple values Patrick Caldon 090524
        pmmult <- match(mult, parnms)
        for (i in seq(along=parameters)) {
# patch for multiple values Patrick Caldon 090524
             if (length(parameters[[i]]) > 1 && !(i %in% pmmult))
                stop(paste("Parameter <", names(parameters)[i],
                    "> has multiple values", sep=""))
            if (pmv[i] == "string") {
                if (!is.character(parameters[[i]]))
                    stop(paste("Parameter <", names(parameters)[i],
                    "> does not have string value", sep=""))
            } else if (pmv[i] == "float") {
                if (!is.numeric(parameters[[i]]))
                    stop(paste("Parameter <", names(parameters)[i],
                    "> does not have float value", sep=""))
            } else if (pmv[i] == "integer") {
                if (!is.integer(parameters[[i]]))
                    stop(paste("Parameter <", names(parameters)[i],
                    "> does not have integer value", sep=""))
            } else warning("unknown parameter type")
# patch for multiple values Patrick Caldon 090524
            param <- paste(parameters[[i]], collapse=",")
            res <- paste(res, paste(names(parameters)[i], param,
                sep="="))
        }
    }
    res
}

execGRASS <- function(cmd, flags=NULL, parameters=NULL, intern=FALSE,
    ignore.stderr=FALSE) {
    syscmd <- doGRASS(cmd, flags=flags, parameters=parameters)
    res <- system(syscmd, intern=intern, ignore.stderr=ignore.stderr)
    if (intern) return(res)
    invisible(res)
}


