"point.in.polygon" <-
function(point.x, point.y, pol.x, pol.y) {
	.Call("R_point_in_polygon_sp", 
		as.numeric(point.x),
		as.numeric(point.y),
		as.numeric(pol.x),
		as.numeric(pol.y) 
#ifdef R
		, PACKAGE = "sp"
#endif
		)
}
