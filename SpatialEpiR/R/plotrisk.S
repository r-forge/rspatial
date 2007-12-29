# Last modified 10-8-00

plotrisk <- function(risk, zlim, clevels = default, tolvals = c(0.025, 0.975),
                     toptitle = NA, pval = FALSE) {

# Julia Kelsall
# Sara Morris (1995)
# Plots an image of the given risk estimate with added tolerance contours
# on the current graphics device. If pval=T an overall P-value for the
# hypothesis of constant risk is displayed on the graph.
# risk       a list of the form (x, y, z, est, poly) where (x,y) are the
#            spatial locations (probably in a regular grid), z is the matrix of
#            the proportion of simulated data sets below the observed value in
#            each point, est is the (x,y,z) values of the observed relative risk
#            surface calculated by the function relrisk and poly is a polygon which
#            contains the original points.
# zlim       the minimum and maximum level for the Splus function image
# clevels    the contour levels to be plotted
# tolvals    the tolerance contours required - default is 95%
# toptitle   a title for the plot
# pval       logical value. If true the overall P-value is displayed on the plot

  default <- c(-20, -15, -10, -8, -6, -5, -4, seq(-3, 3, 0.5), 4, 5, 6, 8, 10, 15, 20)
  if (missing(zlim)) {
    zl    <- quantile(as.vector(risk$est$z), c(0.25, 0.75), na.rm = TRUE)
    zlim  <- c(2 * zl[1], 10 * zl[2])
  }
  risk$est$z[(risk$est$z) > (zlim[2])] <- zlim[2]
  par(pty = "s", font = 3)
  pointmap(risk$poly, type = "n", cex = 0.7)
  image(risk$est, add = TRUE, zlim = zlim)
  polymap(risk$poly, add = TRUE)
  contour(risk$est, lwd = 0.1, cex = 0.4, levels = clevels, add = TRUE, lty = 2)
  if ((tolvals[1] == 0.025) & (tolvals[2] == 0.975)) {
    contour(risk, levels = 0.975, cex = 0.001, lwd = 3, add = TRUE, lty = 1)
    contour(risk, levels = 0.025, cex = 0.001, lwd = 3, add = TRUE, lty = 3)
  } else {
    contour(risk, levels = tolvals, cex = 0.7, lwd = 3, add = TRUE, lty = 3)
  }
  if (is.na(toptitle)) {
    toptitle <- " "
  }
  if (pval) {
    toptitle <- paste(toptitle, " (p =", as.character(round(risk$pval, digits = 3)), ")")
  }
  title(toptitle, cex = 0.8)
}
