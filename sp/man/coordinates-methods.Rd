\name{coordinates-methods}
\docType{methods}
\alias{coordinates-methods}
% \alias{coordinates}
\alias{coordinates,list-method}
\alias{coordinates,data.frame-method}
\alias{coordinates,matrix-method}
\alias{coordinates,SpatialPoints-method}
\alias{coordinates,SpatialPointsDataFrame-method}
\title{ retrieves spatial coordinates }
\description{ retrieves spatial coordinates from spatial data }
\section{Methods}{
\describe{

\item{obj = "list"}{ list with (at least) two numeric components of equal length }

\item{obj = "data.frame"}{ data.frame with at least two numeric components }

\item{obj = "matrix"}{ numeric matrix with at least two columns }

\item{obj = "SpatialPoints"}{ object of, or deriving from, SpatialPoints }

\item{obj = "SpatialPointsDataFrame"}{ object of, or deriving from, 
	SpatialPointsDataFrame }
}}
\keyword{methods}
