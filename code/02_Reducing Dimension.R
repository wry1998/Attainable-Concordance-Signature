# this is a sample code of reducing dimension and obtaining the smoothed kendall's tau for smi
# please run contents from https://github.com/samperochkin/learning-block-exchangeability/tree/master before running this code
# residuals are obtained by fitting GARCH(1,1) models to each component in smi, they were saved as a csv file

# load residuals
X = read.table('residuals.csv')

# generated Kendall’s tau matrix from residuals
Tau.hat <- cor.fk(X) 

# generate the partitions
path <- pathBuilder(Tau.hat, Theta.hat, nrow(X), 1)

# Plot p-value against iteration
a <- stoppingCriterion(Tau.hat, path$D, path$S)
plot(0:(ncol(X)-1),a,pch=19,xlab="step",ylab="critere")
lines(0:(ncol(X)-1),a)
abline(h=.05,col="red")

# Choose optimal clustering and generate smoothed tau
D.final = path$D[[6]]
new.list <- sapply(1:ncol(D.final), function(i){
  which(D.final[,i] == 1)
})
pairs <- t(combn(1:length(new.list),2))
tt.small <- sapply(1:nrow(pairs), function(i){
  j1 <- pairs[i,1]
  j2 <- pairs[i,2]
  mean(path$Th[new.list[[j1]],new.list[[j2]]])
})
Tt.small <- matrix(nrow = length(new.list), ncol = length(new.list))
Tt.small[rbind(pairs,pairs[,2:1])] <- tt.small
diag(Tt.small) <- 1

Tt.small # the smoothed kendall’s tau matrix