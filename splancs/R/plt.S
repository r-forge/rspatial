plt <- function(data, value)
{
	data <- sort(data)
	nv <- length(value)
	nd <- length(data)
	res <- NULL
	for(iv in 1:nv) {
		nlt <- length(data[data < value[iv]])
		res <- c(res, nlt/nd)
	}
}
