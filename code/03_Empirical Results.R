###################################### import packages ###########################
library(KendallSignature)
library(copula)
library(rcdd)
library(gMOIP)
library(rgl)


############################## inputs from previous steps #######################
# load residuals of GARCH(1,1) models
# select a subset {UBSG, LHN, LONN} from the smoothed kendall's tau
X = read.table('residuals.csv')
Y = Tt.small[1:3,1:3] 



#################### attainability of higher-order independence #################
Y = X[c(1,3,4,6,7)]
kappa = estsignature(as.matrix(Y))
kappa[12:16]=0
attainable(kappa)


########################## attainable concordance signature #####################
# calculate concordance signature
k = consignature(Y)

# generate the set of attainable concordance signature
w = findpolytope(k, d = 4)
allkappa = Amatrix(4) %*% t(w)
vertices = t(allkappa[c(4,6:8), ])

# plot the attainable set (forms a convex hull)
# clean.dupli() is a function I wrote to clean up duplicated vertices. plotHull functions could not handle duplicated values.
plot3d(vertices[,1:3],xlab='PGHN-UBSG',ylab='PGHN-LHN',zlab='PGHN-LONN')
plotHull3D(clean.dupli(vertices[,1:3]),drawPoints=TRUE)
plotHull2D(clean.dupli(vertices[,1:2]),drawPoints=TRUE)
 +xlab('PGHN-UBSG')+ylab('PGHN-LHN')


########################### estimate pairwise signature #########################
# pairwise signature among PGHN, LHN, UBSG, using the common observation window
Y = cbind(X[182:251,c(1,3)],gfit_PGHN@fit$z)
estsignature(as.matrix(Y))
