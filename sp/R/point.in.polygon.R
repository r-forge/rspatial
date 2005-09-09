"point.in.polygon" = function(point.x, point.y, pol.x, pol.y) {
	.Call("R_point_in_polygon_sp", 
		as.numeric(point.x),
		as.numeric(point.y),
		as.numeric(pol.x),
		as.numeric(pol.y), 
		PACKAGE = "sp"
	)
}

pointsInPolygon = function(pts, Polygon) {
	pts = coordinates(pts)
	cc = getPolygonCoordsSlot(Polygon)
	point.in.polygon(pts[,1], pts[,2], cc[,1], cc[,2])
}

pointsInPolygons = function(pts, Polygons, which = FALSE) {
	rings = getPolygonsPolygonsSlot(Polygons)
	holes <- sapply(rings, getPolygonHoleSlot)
	res = unlist(lapply(rings[!holes], function(x, pts) 
		pointsInPolygon(pts, x), pts = pts))
	if (any(holes)) {
		resH = unlist(lapply(rings[holes], function(x, pts) 
			pointsInPolygon(pts, x), pts = pts))
		ret <- xor(res > 0 , resH > 0)
	} else {
		ret <- res > 0
	}
	if (which) {
		reti = as.integer(res)
		is.na(reti) <- !ret
		return(reti)
		
	}
	ret
}

pointsInSpatialPolygons = function(pts, SpPolygons) {
	sr = getSpPpolygonsSlot(SpPolygons)
	res = lapply(sr, function(x, pts) pointsInPolygons(pts, x), pts = pts)
	ret = rep(as.numeric(NA), nrow(coordinates(pts)))
	for (i in seq(along = res))
		ret[res[[i]] > 0] = i
	ret
}
