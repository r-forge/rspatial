\name{addpoints}
\alias{addpoints}
\title{
Point Operations
}
\description{
Add points interactively to a point data set.
}
\usage{
addpoints(pts=NULL,plot=F,quiet=F)
}
\arguments{
\item{pts}{
A points data set.
}
\item{plot}{
if true, plot the \fCpts} data, using \fCpointmap}. If false,
 or if \fCpts} is missing,
don't plot the data. 
}
\item{quiet}{
if true, don't print a prompt to enter points.
}}
\value{
A points data set consisting of \fCpts} and the points entered on the current 
graphics device.


}
\section{Side Effects}{
The points entered are displayed on the current graphics device.
}
\seealso{
\fCdelpoints}
}
\examples{
uk()	# display united kingdom map
uk.points_addpoints()        # now click on some points on the map
}
% Converted by Sd2Rd version 0.3-3.
