% Copyright Barry Rowlingson  and 
% Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
% R port: copyright 1998-2000 by Roger S. Bivand
%
%  This program is free software; you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation; either version 2 of the License, or
%  (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%

\name{bodmin}
\title{Bodmin Moors granite tors}
\usage{data(bodmin)}
\alias{bodmin}
\format{A list corresponding to a Venables and Ripley point object with 35 observations
  \tabular{lll}{
    x  \tab numeric  \tab grid eastings\cr
    y   \tab numeric  \tab grid northings\cr
    area \tab	list	\tab bounding box with xl, xu, yl, yu\cr
    poly \tab array \tab polygon boundary with columns x and y\cr
  }
}
\source{Pinder and Witherick, 1977 - Bailey and Gatrell 1995, ch. 3.
}
\description{Locations of 35 granite tors on Bodmin Moor, taken from Infomap data set (northings multiplied by -1 to correspond to Figure 3.2, p. 82, Bailey and Gatrell.
}
\references{Bailey, T. C. and Gatrell, A. C. 1995, Interactive spatial data analysis. Longman, Harlow.

}
\keyword{datasets}
