# Copyright Giovanni Petris <GPetris@uark.edu> 2001
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
###
### Calculate simulation envelope for a Poisson Cluster Process
###
Kenv.pcp <- function(rho, m, s2, region.poly, larger.region=NULL, nsim, r) {
  ## rho: intensity of the parent process
  ## m: average number of offsprings per parent
  ## s2: variance of location of offsprings relative to
  ##   their parent
  ## region.poly: a polygon defining the region in which
  ##   the process is to be generated
  ## larger.region: a rectangle containing the region of interest
  ##   given in the form (xl,xu,yl,yu)
  ## nsim: number of simulations required
  ## r: vector of distances at which the K function has to be estimated
  if (is.null(larger.region))
    larger.region <- as.vector(apply(sbox(region.poly), 2, range))
  Kenv <- list(lower=rep(99999,length(r)), ave=numeric(length(r)),
               upper=rep(-99999,length(r)))
  for(i in 1:nsim) {
    Khat <- khat(pcp.sim(rho, m, s2, region.poly, larger.region),
                 region.poly, r)
    Kenv$ave <- Kenv$ave + Khat
    Kenv$lower <- pmin(Kenv$lower, Khat)
    Kenv$upper <- pmax(Kenv$upper, Khat)
  }
  Kenv$ave <- Kenv$ave/nsim
  Kenv
}

