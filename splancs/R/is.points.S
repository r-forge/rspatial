is.points <- function(thing)
{
	is <- F
	if(is.array(thing))
		if(length(dim(thing))==2)
			if(dim(thing)[2]>=2) is <- T
	is
}

