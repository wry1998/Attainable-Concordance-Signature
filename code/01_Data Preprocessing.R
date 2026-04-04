############################### Import packages #################################
library(rugarch)


########################### build GRACH(1,1) models #############################
# scaled t innovation
model1 = ugarchspec(variance.model=list(model="sGARCH",
                                        garchOrder=c(1,1)),
                    mean.model = list(armaOrder=c(0,0),include.mean = FALSE),
                    distribution.model = "std")

# normal innovation
model2 = ugarchspec(variance.model=list(model="sGARCH",
                                        garchOrder=c(1,1)),
                    mean.model = list(armaOrder=c(0,0),include.mean = FALSE),
                    distribution.model = "norm")


####################### fit models to log returns of smi ########################
# components of SMI are loaded, cleaned, and saved in list smi
# fitting models to each stock
gfit_UBSG = ugarchfit(spec = model1, data = smi$UBSG$data)
gfit_NESN = ugarchfit(spec = model2, data = smi$NESN$data)

# coefficients
coef_UBSG = gfit_UBSG@fit$coef

# box test
Box.test(gfit_UBSG@fit$z, lag = 1, type = "Ljung-Box", fitdf = 0)

# fitted values
fit_UBSG = gfit_UBSG@fit$sigma * gfit_UBSG@fit$z
plot(smi$UBSG$data,type = "l",col  = "black",lwd  = 1, xlab = "Day", ylab = "Log returns", main = "UBSG")
lines(fit_UBSG, col = "red",lwd = 1)


############################# residuals and plots ###############################
# residual
residual_UBSG = gfit_UBSG@fit$z

# Auto-correlogram
acf(abs(residual_UBSG), main = "Auto-correlogram", xlab = "Lag")

# qqplot (scaled t innovation)
theo_q = qdist(distribution = "std",
               p = pppoints(length(residual_UBSG)), mu = 0, sigma = 1, shape = coef_UBSG["shape"])
qqplot(x = theo_q, y = sort(residual_UBSG),
       xlab = "Theoretical Quantile", ylab = "Sample Quantile", main = "QQPlot")
abline(0, 1, col = "skyblue", lwd = 2)

# qqplot (normal innovation)
qqnorm(residual_NESN, main = "QQPlot")
qqline(residual_NESN, col = "skyblue", lwd = 2)

# histogram
hist(residual_UBSG,breaks = 12,main = "histogram",xlab = "gfit_UBSG@fit$z")