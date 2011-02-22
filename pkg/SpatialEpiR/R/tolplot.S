# Last modified 7-8-00

tolplot <- function(fitout, tolout, poly, toptext = "") {

# This function simply subtracts the information needed from the output of fitsmacc
# and tolsmacc and produces an image plot with 95% tolerance contours on. The
# range of the surface values are written as subtext. A toptext is optional.
# This function mainly sets things up nicely and then calls the function plotrisk,
# so for more detailed information see this function.

  gridx      <- fitout$surface$x
  gridy      <- fitout$surface$y
  tolmat     <- tolout$probmat
  fitsurface <- fitout$surface
  pval       <- tolout$pval
  risklist   <- list(x = gridx, y = gridy, z = tolmat, est = fitsurface,
                     poly = poly, pval = pval)
  valuerange <- range(fitsurface$z, na.rm = TRUE)

  plotrisk(risklist, zlim = valuerange, pval = TRUE, toptitle = toptext)

  subtext    <- paste("range=(", round(range(fitsurface$z, na.rm = TRUE)[1],digits = 2),
                   ",", round(range(fitsurface$z, na.rm = TRUE)[2],digits = 2),
                   ")", sep = "")
  title(sub = subtext, cex = 0.8)
}
