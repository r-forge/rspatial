siggamstart <- function(formula, cc, pts, h, poly,ngrid)
{
        # sets things up for doing signicance...

        fit      <- glm(formula, family = binomial)
        prob     <- predict(fit, type = "response")

        fit      <- fitloggam(formula, cc, pts, h, poly=poly,ngrid=ngrid)
        surf.est <- fit$g2est$z

        list(prob = prob, surf.est = surf.est, h = h, ngrid = ngrid, x = fit$
                g2est$x, y = fit$g2est$y, tvalobs = mean(fit$g2^2))
}
