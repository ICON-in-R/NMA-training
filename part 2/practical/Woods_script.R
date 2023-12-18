# Woods () BUGS code
# main script


library(tibble)
library(R2OpenBUGS)

########
# data #
########

# Data set descriptors
consts <- 
  list(LnObs = 5,
       BnObs = 8,
       nTx = 4,
       nStudies = 5)

# Log hazard ratio and log hazard data
lhr_dat <- 
  tribble(~Lstudy, ~Ltx, ~Lbase, ~Lmean, ~Lse, ~multi,
          1, 1, 1,  0,     0.066, 1,
          1, 2, 1,  0.055, 0.063, 1,
          1, 3, 1, -0.154, 0.070, 1,
          1, 4, 1, -0.209, 0.072, 1,
          2, 2, 1, -0.276, 0.203, 0)

# Binary data
bin_dat <- 
  tribble(~Bstudy, ~Btx, ~Bbase, ~Br, ~Bn,
          3, 3, 1, 1, 229,
          3, 1, 1, 1, 227,
          4, 2, 1, 4, 374,
          4, 3, 1, 3, 372,
          4, 4, 1, 2, 358,
          4, 1, 1, 7, 361,
          5, 3, 1, 1, 554,
          5, 1, 1, 2, 270)

# Initial values
inits <- 
  list(
    list(
      alpha = c(-0.50, -0.50, -0.50, -0.50, -0.50),
      beta = c(NA, -0.5, -0.5, -0.5)),
    list(
      alpha = c(0.50, 0.50, 0.50, 0.50, 0.50),
      beta = c(NA, 0.5, 0.5, 0.5)))
    

# Data as for fixed effects analysis
inits_RE <- 
  list(
    list(
      alpha = c(-0.50, -0.50, -0.50, -0.50, -0.50),
      beta = c(NA, -0.5, -0.5, -0.5),
      sd = 0.1),
    list(
      alpha = c(0.50, 0.50, 0.50, 0.50, 0.50),
      beta = c(NA, 0.5, 0.5, 0.5),
      sd = 1))

input_dat <- 
  c(consts,
    lhr_dat,
    bin_dat)

input_dat

save(input_dat, file = "part 2/practical/hr_counts_input_data.RData")

#############
# run model #
#############

res <-
  bugs(
    model = here::here("part 2/practical/Woods_BUGS_code_FE.txt"),
    data = input_dat,
    inits = inits,
    parameters = c("hr", "rk"),
    n.chains = 2,
    n.burnin = 100,
    n.iter = 10000,
    debug = TRUE)

# res <-
#   bugs(
#     model = here::here("part 2/practical/Woods_BUGS_code_RE.txt"),
#     data = input_dat,
#     inits = inits_RE,
#     parameters = c("hr", "rk"),
#     n.chains = 2,
#     n.thin = 100,
#     n.burnin = 1000,
#     n.iter = 20000
#     # debug = TRUE
#     )

