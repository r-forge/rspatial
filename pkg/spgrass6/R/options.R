# Interpreted GRASS 6+ interface functions
# Copyright (c) 2011 Roger S. Bivand
#

set.ignore.stderrOption <- function(value) {
	if (!is.logical(value)) stop ("logical argument required")
	res <- get("ignore.stderr", env = .GRASS_CACHE)
	assign("ignore.stderr", value, env = .GRASS_CACHE)
	res
}

get.ignore.stderrOption <- function() {
	get("ignore.stderr", env = .GRASS_CACHE)
}

set.useGDALOption <- function(value) {
	if (!is.logical(value)) stop ("logical argument required")
	res <- get("useGDAL", env = .GRASS_CACHE)
	assign("useGDAL", value, env = .GRASS_CACHE)
	res
}

get.useGDALOption <- function() {
	get("useGDAL", env = .GRASS_CACHE)
}


