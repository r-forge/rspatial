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
### Generate a Poisson Cluster Process
###
pcp.sim <- function(rho, m, s2, region.poly, larger.region=NULL) {
  ## rho: intensity of the parent process
  ## m: average number of offsprings per parent
  ## s2: variance of location of offsprings relative to
  ##   their parent
  ## region.poly: a polygon defining the region in which
  ##   the process is to be generated
  ## larger.region: a rectangle containing the region of interest
  ##   given in the form (xl,xu,yl,yu)
  if (is.null(larger.region))
    larger.region <- as.vector(apply(sbox(region.poly), 2, range))
  sim.events <- c(0,0)
  ## 1. Generate the parents on [xl,xu]x[yl,yu]
  n <- rpois(1,lambda=rho*(larger.region[2]-larger.region[1])*
             (larger.region[4]-larger.region[3]))
  parents <- cbind(runif(n,larger.region[1],larger.region[2]),
                   runif(n,larger.region[3],larger.region[4]))
  ## 2. Generate the children
  sd <- sqrt(s2)
  for (j in 1:n) {
    num.child <- rpois(1,lambda=m)
    for (k in 1:num.child) {
      new.child <- parents[j,]+rnorm(2,0,sd=sd)
      sim.events <- rbind(sim.events,new.child)
    }
  }
  sim.events <- sim.events[-1,]  
  ## return only the events within the region of interest
  pip(as.points(sim.events),region.poly)
}

