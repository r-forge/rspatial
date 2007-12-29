siggam <- function(formula, cc, pts, poly, start, prev.sims = NULL)
{
# Relabels the cases and controls and fits the surface for the new
# data set keeping track of previous simulations. For calculating the
# tolerance contours this function should be called 99 times feeding
# previous simulations to the next one. If loops were less of a pain
# in Splus this could easily have been done for you - sorry.


        if(is.null(prev.sims)) {
               prev.sims <- list(m = 0,
                                 tval = NULL,
                                 tvalobs = start$tvalobs,
                                 pval = NULL,
                                 sigmat = matrix(0, nrow = length(start$surf.est[, 1]),
                                                    ncol = length(start$surf.est[1,  ])),
                                 x = start$x,
                                 y = start$y)
        }
        null.prob        <- start$prob
        surface.est      <- start$surf.est
        h                <- start$h

        why              <- cc
        simcase          <- sample(1:length(why), size = sum(why), replace = FALSE, prob =
                                   null.prob)
        simwhy           <- rep(0, length(why))
        simwhy[simcase]  <- 1
#       gam.data$why     <- simwhy

        sim              <- fitloggam(formula, simwhy, pts, start$h, poly=poly,
                                      ngrid=ngrid)

        tval             <- mean(sim$g2^2)
        below            <- as.numeric(sim$g2est$z < surface.est)

        prev.sims$m      <- prev.sims$m + 1
        prev.sims$tval   <- c(prev.sims$tval, tval)
        prev.sims$sigmat <- prev.sims$sigmat + below
        prev.sims$pval   <- (sum(prev.sims$tval >= start$tvalobs) + 1)/(prev.sims$
                                 m + 1)
        cat("\n\n ********* DONE", prev.sims$m, "GAM FITS *********\n\n")
        prev.sims
}
