\name{as.points}
\alias{as.points}
\title{
Creates data in spatial point format
}
\description{
Creates data in spatial point format.
}
\usage{
as.points(p)
}
\arguments{
\item{p}{
any S-PLUS object(s).
}
}
\value{
\code{as.points} tries to return \code{p} as a points object. Valid options for 
\code{p} are:
\(bu a points object ; returns it unaltered.
\(bu a list with x and y elements of the same length ; returns a
points object with the x and y elements as the coordinates of the points.
\(bu two vectors of equal length ; returns a points object with the 
first vector as the x coordinates, the second vector as the y-coordinates.
}
% Converted by Sd2Rd version 0.3-3.
