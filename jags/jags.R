
jags_dir = here::here("jags")

library(rjags)


#### Begin analysis
# Needed variables:
# I: Number of participants
# J: Number of intensities/durations
# y: I by J matrix of correct judgments
# N: I by J matrix of total judgments
# chance.p: Chance baseline
########

forJags <- list(
    chance.p = chance.p,
    y = y,
    N = N,
    I = nrow(y),
    J = ncol(y)
  )

## compile JAGS
foo <- jags.model(file=file.path(jags_dir, "mac3_2014.bug"),
                  data=forJags, n.chains = jags_chains)

jags_fit <- coda.samples(foo, jags_iter,
                    variable.names=c("alpha","beta","theta",
                                     "p","x","prec_alpha","prec_theta"))
