\name{kerview}
\alias{kerview}
\title{
Space-time kernel functions
}
\description{
A linked-window system for browsing space-time data.
}
\usage{
kerview(pts, times, k3, map=T, addimg=T, ncol=1)
}
\arguments{
\item{pts}{
A matrix of event x,y coordinates.
}
\item{times}{
A vector of event times.
}
\item{k3}{
An object returned from \fCkernel3d}, the space-time kernel smoothing
function
}
\item{map}{
If false, don't plot the map display.
}
\item{addimg}{
If true, overwrite successive images in the image display, else
make a fresh image plot each time.
}
\item{ncol}{
Number of columns and rows for multiple images and maps.
}}
\details{
This function displays three linked views of the data. In the current
graphics window a temporal slice from the kernel smoothing is displayed. 
Another graphics device is started to display a map of the data that
contributed to that time-slice. A third graphics device shows a 
histogram of the times of the events. Clicking with the mouse
in this window with button 1 sets the time for the other
displays to the time on the x-axis of the histogram at the clicked point.


In this way the 3-dimensional kernel smoothed function can be browsed, 
and the corresponding map of the data compared.


}
\seealso{
kernel3d


}
% Converted by Sd2Rd version 0.3-3.
