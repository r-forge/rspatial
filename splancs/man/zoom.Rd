\name{zoom}
\alias{zoom}
\title{
Graphics
}
\description{
Interactively specify a region of a plot for expansion
}
\usage{
zoom(out=F,quiet=F,\dots)
}
\arguments{
\item{out}{
If true, expand the limits of the current plot by a factor of three, centred
on the current plot.
}
\item{quiet}{
If false, prompt the user to enter two coordinates. If true, say nothing.
}
\item{...}{
Other arguments are passed through to pointmap.
}}
\value{
None


}
\section{Side Effects}{
A prompt is optionally displayed, and the user selects two points
forming the diagonal of a rectangle. A new, empty plot is created that has its
axis limits set to the bounding square of the selected rectangle. 
If \code{out=T}, no prompt is displayed, and a new blank plot is created with
its limits in x and y set to span an area three times the height and width
centred on the current centre.
}
\seealso{
pointmap
}
\examples{
uk()         # plot the uk
zoom()       # now select a region
uk(add=T)    # draws selected region
zoom(out=T)  # now zoom out again
uk(add=T)    # and replot


}
% Converted by Sd2Rd version 0.3-3.
