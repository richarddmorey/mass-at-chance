library(shinystan)

### Simulate data with proper structure
source("sim_data.R")

### Fit generalized MAC 3.0 with JAGS

# Number of MCMC iterations
## You probably want many more, 4000 is only for testing
jags_iter = 4000
jags_chains = 4
source( here::here("jags", "jags.R") )

## JAGS chain diagnostics
launch_shinystan(as.shinystan(jags_fit))

## JAGS model diagnostics, posteriors

## Which chains belong to which parameters?
jags_cnames = colnames(jags_fit[[1]])
alpha_cols = grepl("alpha[", jags_cnames, fixed = TRUE)
beta_cols = grepl("beta[", jags_cnames, fixed = TRUE)
theta_cols = grepl("theta[", jags_cnames, fixed = TRUE)
x_cols = grepl("x[", jags_cnames, fixed = TRUE)

## Posterior probability at chance
jags_postPrAtChance = rowMeans(sapply(jags_fit, function(chn){
  colMeans(chn[,x_cols]<=0)
}))
dim(jags_postPrAtChance) = c(I, J)

## Plot of posterior probabilities by performance
plot(y/N,jags_postPrAtChance, col=rep(1:J,each=I),pch=19, ylab="Post. prob. at chance", xlab="Observed accuracy")
for(i in 1:I)
  lines((y/N)[i,],jags_postPrAtChance[i,],lty=3, col="gray")
abline(h=.9,col="gray", lty=2)
abline(v=chance.p, col="gray",lty=2)
title("JAGS")

## Residuals at posterior mean x[i,j]
summary_jags = summary(jags_fit)
jags_x_est = summary_jags[[1]][ x_cols, "Mean" ]
dim(jags_x_est) = c(I,J)
jags_p_est = jags_x_est * (jags_x_est > 0)
jags_p_est = (pnorm(jags_p_est) - .5) * 2 * ( 1-chance.p ) + chance.p
jags_pstar_est = (pnorm(jags_x_est) - .5) * 2 * ( 1-chance.p ) + chance.p
jags_std_resid = (y - N*jags_p_est) / sqrt(N * jags_p_est * ( 1 - jags_p_est) )

plot(jags_pstar_est, jags_std_resid, pch=19, col="black", ylab="Standardized residual", xlab="Transformed prediction")
for(i in 1:I)
  lines(jags_pstar_est[i,],jags_std_resid[i,],lty=1, col="gray")
abline(h=0, lty=2)
abline(v=chance.p)
abline(h=c(-1.96,1.96), col="red", lty=2)
title("JAGS")

### Fit generalized MAC 3.0 with stan

# Number of MCMC iterations
## You probably want many more, 10000 is only for testing
stan_iter = 10000
options(mc.cores = parallel::detectCores())
source( here::here("stan", "stan.R") )

## stan chain diagnostics
launch_shinystan(stan_fit)

stan_chains = As.mcmc.list(stan_fit)

stan_cnames = colnames(stan_chains[[1]])
alpha_cols = grepl("alpha[", stan_cnames, fixed = TRUE)
beta_cols = grepl("beta[", stan_cnames, fixed = TRUE)
theta_cols = grepl("theta[", stan_cnames, fixed = TRUE)
x_cols = grepl("x[", stan_cnames, fixed = TRUE)


## Posterior probability at chance
stan_postPrAtChance = rowMeans(sapply(stan_chains, function(chn){
  colMeans(chn[,x_cols]<=0)
}))
dim(stan_postPrAtChance) = c(J, I)
stan_postPrAtChance = t(stan_postPrAtChance)

## Plot of posterior probabilities by performance
plot(y/N,stan_postPrAtChance, col=rep(1:J,each=I),pch=19, ylab="Post. prob. at chance", xlab="Observed accuracy")
for(i in 1:I)
  lines((y/N)[i,],stan_postPrAtChance[i,],lty=3, col="gray")
abline(h=.9,col="gray", lty=2)
abline(v=chance.p, col="gray",lty=2)
title("stan")

## Residuals at posterior mean x[i,j]
summary_stan = summary(stan_chains)
stan_x_est = summary_stan[[1]][ x_cols, "Mean" ]
dim(stan_x_est) = c(J,I)
stan_x_est = t(stan_x_est)
stan_p_est = stan_x_est * (stan_x_est > 0)
stan_p_est = (pnorm(stan_p_est) - .5) * 2 * ( 1-chance.p ) + chance.p
stan_pstar_est = (pnorm(stan_x_est) - .5) * 2 * ( 1-chance.p ) + chance.p
stan_std_resid = (y - N*stan_p_est) / sqrt(N * stan_p_est * ( 1 - stan_p_est) )

plot(stan_pstar_est, stan_std_resid, pch=19, col="black", ylab="Standardized residual", xlab="Transformed prediction")
for(i in 1:I)
  lines(stan_pstar_est[i,],stan_std_resid[i,],lty=1, col="gray")
abline(h=0, lty=2)
abline(v=chance.p)
abline(h=c(-1.96,1.96), col="red", lty=2)
title("stan")


# Compare JAGS and stan x[i,j] posterior means
plot(jags_x_est, stan_x_est)
abline(0, 1)

# Compare stan estimates with true values
# Uncomment these lines for for testing with simulated data
# plot(summary_stan[[1]][alpha_cols,"Mean"], alpha)
# abline(0,1)
# 
# plot(summary_stan[[1]][beta_cols,"Mean"], beta)
# abline(0,1)
# 
# plot(summary_stan[[1]][theta_cols,"Mean"], theta)
# abline(0,1)
##

