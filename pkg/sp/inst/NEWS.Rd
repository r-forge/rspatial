\name{NEWS} 
\title{News for Package 'sp'}

\section{Changes in version 1.2-0 (2015-09-01)}{
  \itemize{
    \item Support for \code{SpatialMultiPoints} and
    \code{SpatialMultiPointsDataFrame} objects. Where \code{SpatialPoints}
	are set of points, \code{SpatialMultiPoints} are sets of point sets.
	\code{SpatialPointsDataFrame} objects bind points to attribute values,
	\code{SpatialMultiPointsDataFrame} bind point sets to attribute values.
	Methods supported are subsetting (\code{[}),
	\code{plot}, \code{spplot}, \code{over}, and coercion to
	\code{SpatialPoints} or \code{SpatialPointsDataFrame}. Functions in 
	\CRANpkg{rgeos} support this feature class. See also \code{demo(mp)}.

    \item Support for Google Earth or OpenStreetMap background maps in
	\code{sp::plot} and \code{spplot}. Maps returned by
    \itemize{
      \item function \code{GetMap} in package \CRANpkg{RgoogleMaps}
	  \item function \code{get_map} in package \CRANpkg{ggmap}
    }
	are now understood by plotting functions in \CRANpkg{sp}. In particular,
	\code{sp::plot} now has an argument \code{bgMap}, \code{spplot}
	now has panel functions \code{panel.RgoogleMaps} and \code{panel.ggmap};
	See \code{demo(webmap)} for examples.

	As these maps assume a web mercator projection, \code{sp::plot} issues a warning 
	if the object to be plotted does not have a CRS containing \code{"+init=epsg:3857"}
  }
}
