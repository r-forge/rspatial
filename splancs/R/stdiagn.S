# Copyright Barry Rowlingson <b.rowlingson@lancaster.ac.uk> and 
# Peter Diggle (c) 1991-3; http://www.maths.lancs.ac.uk/~rowlings/Splancs/
# R port: copyright 1998-2000 by Roger S. Bivand
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

stdiagn <- function(pts,stkh,stse,stmc=0,Dzero=F)
{
# set up the 2x2 layout
oldpar <- par(mfrow=c(2,2))

# map the points
#par(pty='s')
pointmap(as.points(pts))
title('Data map')

# plot the D surface
# 2/9/94  added Dzero option
oprod <- outer(stkh$ks,stkh$kt)
st.D <- stkh$kst-oprod
st.R <- st.D/(stse)

#par(pty='m')
if(!Dzero){
persp(stkh$s, stkh$t, st.D,xlab='Distance',ylab='Time',zlab='D', expand=0.5, ticktype="detailed", theta=-30, shade=0.4, cex=0.7)
title('D plot')
} else {
persp(stkh$s, stkh$t, st.D/oprod,xlab='Distance',ylab='Time',zlab='Dzero', expand=0.5, ticktype="detailed", theta=-30, shade=0.4, cex=0.7)
title('Dzero plot')
}


plot(outer(stkh$ks, stkh$kt), st.R,xlab='K(s)K(t)',ylab='R')
abline(h=0)
title('Residual Plot')
if(length(stmc)>1){
 hist(stmc,nclass=50,include.lowest=T,xlab='Test statistic',main="")
 y.75 <- par()$usr[4]*.75
 y.8 <- par()$usr[4]*.8
 lines(rep(stmc[1],2),c(0,y.75),lwd=2)
 text(stmc[1],y.8,'Data Statistic')
 title('MC results')
}else{
 plot(c(0,1),c(0,1),type='n',axes=F,xlab='',ylab='')
 ad <- par()$adj
 par(adj=.5)
 text(0.5,.5,'No MC available')
 par(adj=ad)
}
par(oldpar)
#invisible(0)

}
# Local Variables:
# mode:S
# S-temp-buffer-p:t
# End:
