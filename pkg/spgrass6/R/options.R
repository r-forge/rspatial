# Interpreted GRASS 6+ interface functions
# Copyright (c) 2011 Roger S. Bivand
#

set.ignore.stderrOption <- function(value) {
	if (!is.logical(value)) stop ("logical argument required")
	res <- get("ignore.stderr", envir = .GRASS_CACHE)
	assign("ignore.stderr", value, envir = .GRASS_CACHE)
	res
}

get.ignore.stderrOption <- function() {
	get("ignore.stderr", envir = .GRASS_CACHE)
}

set.stop_on_no_flags_parasOption <- function(value) {
	if (!is.logical(value)) stop ("logical argument required")
	res <- get("stop_on_no_flags_paras", envir = .GRASS_CACHE)
	assign("stop_on_no_flags_paras", value, envir = .GRASS_CACHE)
	res
}

get.stop_on_no_flags_parasOption <- function() {
	get("stop_on_no_flags_paras", envir = .GRASS_CACHE)
}

set.useGDALOption <- function(value) {
	if (!is.logical(value)) stop ("logical argument required")
	res <- get("useGDAL", envir = .GRASS_CACHE)
	assign("useGDAL", value, envir = .GRASS_CACHE)
        if (value) require(rgdal)
	res
}

get.useGDALOption <- function() {
	get("useGDAL", envir = .GRASS_CACHE)
}

set.pluginOption <- function(value) {
	res <- get("plugin", envir = .GRASS_CACHE)
        if (is.null(value)) {
	    assign("plugin", value, envir = .GRASS_CACHE)
        } else if (is.logical(value)) {
	    assign("plugin", value, envir = .GRASS_CACHE)
        } else stop ("logical or NULL argument required")
	res
}

get.pluginOption <- function() {
	get("plugin", envir = .GRASS_CACHE)
}

set.echoCmdOption <- function(value) {
	if (!is.logical(value)) stop ("logical argument required")
	res <- get("echoCmd", envir = .GRASS_CACHE)
	assign("echoCmd", value, envir = .GRASS_CACHE)
	res
}

get.echoCmdOption <- function() {
	get("echoCmd", envir = .GRASS_CACHE)
}

set.useInternOption <- function(value) {
	if (!is.logical(value)) stop ("logical argument required")
	res <- get("useIntern", envir = .GRASS_CACHE)
	assign("useIntern", value, envir = .GRASS_CACHE)
	res
}

get.useInternOption <- function() {
	get("useIntern", envir = .GRASS_CACHE)
}


