\name{n2dist}
\alias{n2dist}
\title{
Point Summary Statistics
}
\description{
Calculate nearest neighbours for two point patterns
}
\usage{
n2dist(pts1,pts2)
}
\arguments{
\item{pts1,pts2}{
 Point data sets
}}
\value{
Returns a list with components \fC$dists} and \fC$neighs}.
\fC$dists[i]} is the distance
of the nearest neighbour of point \fCpts1[i,]}  
in \fCpts2} and \fC$neighs[i]}
is the index in \fCpts2} of the point nearest to \fCpts1[i,]}.


}
\seealso{
\fCnndistF},\fCFhat},\fCGhat},\fCFzero}
}
% Converted by Sd2Rd version 0.3-3.
