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

set.stop_on_no_flags_parasOption <- function(value) {
	if (!is.logical(value)) stop ("logical argument required")
	res <- get("stop_on_no_flags_paras", env = .GRASS_CACHE)
	assign("stop_on_no_flags_paras", value, env = .GRASS_CACHE)
	res
}

get.stop_on_no_flags_parasOption <- function() {
	get("stop_on_no_flags_paras", env = .GRASS_CACHE)
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

set.pluginOption <- function(value) {
	if (!is.logical(value) || !is.null(value))
            stop ("logical argument required")
	res <- get("plugin", env = .GRASS_CACHE)
	assign("plugin", value, env = .GRASS_CACHE)
	res
}

get.pluginOption <- function() {
	get("plugin", env = .GRASS_CACHE)
}

set.echoCmdOption <- function(value) {
	if (!is.logical(value)) stop ("logical argument required")
	res <- get("echoCmd", env = .GRASS_CACHE)
	assign("echoCmd", value, env = .GRASS_CACHE)
	res
}

get.echoCmdOption <- function() {
	get("echoCmd", env = .GRASS_CACHE)
}


