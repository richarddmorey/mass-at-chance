# For reproducibility
set.seed(123)

### Simulate data for testing
I = 25  # Number of participants
J = 4   # Number of items (ie, stimulus intensities / durations)
chance.p = .25

alpha = rnorm(I, 0, .5)
theta = abs(rnorm(I,0,1))
beta = seq(0,-1.5, len=J)

q = pmax(outer(alpha, beta, '-') * theta, 0)
p = ( pnorm(q) - .5 ) * 2 * (1 - chance.p) + chance.p
Nall = 50
y = rbinom(p,Nall,p)
dim(y) <- dim(p)
N = y * 0 + Nall

####### End simulation of data
