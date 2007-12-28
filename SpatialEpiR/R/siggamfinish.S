siggamfinish <- function(poly, gamfit, lastsim)
{
# gathers the information produced by fitloggam and the final siggam
# and assembles it in a list ready to feed to plotrisk for plotting
  

        list(est = gamfit$g2est, poly = poly, x = lastsim$x,
             y = lastsim$y, z = lastsim$sigmat/lastsim$m, h = gamfit$hlast,
             pval = lastsim$pval, tval = lastsim$tval, tvalobs = lastsim$tvalobs,
             beta = gamfit$beta, m = lastsim$m)
}
