stdiagn_function(pts,stkh,stse,stmc=0,Dzero=F)
{
# set up the 2x2 layout
par(mfrow=c(2,2))

# map the points
par(pty='s')
pointmap(as.points(pts))
title('Data map')

# plot the D surface
# 2/9/94  added Dzero option
oprod_outer(stkh$ks,stkh$kt)
st.D_stkh$kst-oprod
st.R_st.D/(stse)

par(pty='m')
if(!Dzero){
persp(stkh$s, stkh$t, st.D,xlab='Distance',ylab='Time',zlab='D',cex=.5,lab=c(3,3,7))
title('D plot')
} else {
persp(stkh$s, stkh$t, st.D/oprod,xlab='Distance',ylab='Time',zlab='Dzero',cex=.5,lab=c(3,3,7))
title('Dzero plot')
}


plot(outer(stkh$ks, stkh$kt), st.R,xlab='K(s)K(t)',ylab='R')
abline(h=0)
title('Residual Plot')
if(length(stmc)>1){
 hist(stmc,nclass=50,density=-1,inside=T,xlab='Test statistic')
 y.75_par()$usr[4]*.75
 y.8_par()$usr[4]*.8
 lines(rep(stmc[1],2),c(0,y.75),lwd=2)
 text(stmc[1],y.8,'Data Statistic')
 title('MC results')
}else{
 plot(c(0,1),c(0,1),type='n',axes=F,xlab='',ylab='')
 ad_par()$adj
 par(adj=.5)
 text(0.5,.5,'No MC available')
 par(adj=ad)
}

invisible(0)

}
# Local Variables:
# mode:S
# S-temp-buffer-p:t
# End:
