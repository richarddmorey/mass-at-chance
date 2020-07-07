
stan_dir = here::here("stan")

library(rstan) 
rstan_options(auto_write = TRUE)

#### Begin analysis
# Needed variables:
# I: Number of participants
# J: Number of intensities/durations
# y: I by J matrix of correct judgments
# N: I by J matrix of total judgments
# chance_p: Chance baseline
########

forStan <- list(
    chance_p = chance.p,
    y = y,
    N = N,
    I = nrow(y),
    J = ncol(y)
  )


stan_fit = stan(file = file.path(stan_dir, "mac3.stan"), 
                data = forStan
                , control = list(adapt_delta = .95)
                , iter = stan_iter)



