.north.arrow = function() {
	x1 = c(0.1653, 0.2241, 0.2241, 0.2830, 0.1947, 0.1065, 0.1653, 0.1653)
	x2 = c(0, 0.0967, 0.0967, 0.2928, 0.3908, 0.3908, 0.2928, 0.2928, 0.1032, 0, 0)
	y1 = c(0, 0, 0.8823, 0.8235, 1, 0.8235, 0.8823, 0)
	y2 = c(0.2352, 0.2352, 0.5686, 0.2352, 0.2352, 0.7189, 0.7189, 0.3986, 0.7189, 0.7189, 0.2352 )
	SpatialRings(list(Srings(list(Sring(cbind(x1,y1)), Sring(cbind(rev(x2),rev(y2)))), ID="north")))
}
north.arrow = .north.arrow()

.scale.bar = function(height = 0.05) {
	x1 = c(0, 0.5, 0.5, 0, 0)
	y1 = c(0, 0, height, height, 0)
	x2 = x1 + 0.5
	y2 = y1
	SpatialRings(list(Srings(list(Sring(cbind(x1,y1))), ID="left"), 
			Srings(list(Sring(cbind(rev(x2),rev(y2)))), ID="right")))
}
scale.bar = .scale.bar()
