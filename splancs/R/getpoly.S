getpoly <- function(quiet=F)
{
	if(!quiet){
		cat("Enter points with button 1\n")
		cat("Finish with button 2\n")
		cat("Don't try to join the polygon up - it is done for you.\n")
	}
	raw <- locator(type = "l")
	resloc <- cbind(raw$x, raw$y)
	lines(c(raw$x[1], raw$x[length(raw$x)]),
	      c(raw$y[1], raw$y[length(raw$y)]))
	resloc
}
