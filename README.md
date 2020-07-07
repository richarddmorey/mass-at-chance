# Mass at chance models
[JAGS](http://mcmc-jags.sourceforge.net/) and [stan](https://mc-stan.org/) code for fitting mass at chance models.

Morey, R.D., Rouder, J.N. & Speckman, P.L. A Truncated-Probit Item Response Model for Estimating Psychophysical Thresholds. Psychometrika 74, 603 (2009). https://doi.org/10.1007/s11336-009-9122-3

* `mac3.R`: Main code
* `sim_data.R`: Simulate data from the model to fit, if desired. The simulated data will also give you a sense of what format the data need to be in for model fitting.
* `jags/jags.R`: R code to specifically call `rjags` to fit the model
* `jags/mac3_2014.bug`: JAGS code for fitting the model (named 2014 because that's when I wrote this version of it)
* `jags/jags.R`: R code to specifically call `rstan` to fit the model
* `stan/mac3.stan`: stan code for fitting the model

## Quick start

1. Install JAGS and stan from the links above. 

2. Install the R packages `here`, `rjags`, and `rstan` with all dependencies:

```
install.packages(c("here", "rjags", "rstan"), dependencies = TRUE)
```
3. Run the code in `mac3.R`.
