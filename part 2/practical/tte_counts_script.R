# main script to run BUGS code
# simplified version of Saramago (2014) model


library(tibble)
library(R2OpenBUGS)


##########
# inputs #
##########

## IPD
ipd_data <- 
  tribble(~treat, ~baseline, ~t.obs, ~t.cens,
          1,	     1,	       3.50,	  0,
          1,	     1,	       2.33,	  0,
          2,	     1,	       NA,      11.90)

ipd_const <- 
  list(n.subjects = nrow(ipd_data),  # Number of participants in IPD
       n.treat = 2                   # Number of treatments
  )

# treat = treatment arm (coded 1,2)
# baseline = reference treatment code, 
# t.obs = time to event in months (under censoring)
# t.cens = time of censoring in months


## AD evidence
ad_data <- 
  tribble(~a.id,	~a.treat, ~r, ~n, ~a.base, ~a.time,
          1,	    1,	      11,	25,	1,	     12,
          1,	    2,	      10,	25,	1,	     12,
          2,	    2,	      10,	25,	1,	     12)
          
ad_const <- 
  list(n.agg.trials = length(unique(ad_data$a.id)),  # Number of AD studies
       n.agg.arms = 2)                               # Number of AD study arms

# a.id = study number
# a.treat = treatment arm code (coded from 1 to number of treatments)
# r = number of events in trial arm
# n = number of patients in trial arm
# a.base = reference treatment code
# a.time = follow-up time of trial

## Initial values
inits <- 
  list(list(
    d = c(NA, 0),
    mu = -1,
    mu.a = c(-1,-1)   # for each trial
  ))

input_dat <- 
  c(ipd_const,
    ad_const,
    ipd_data,
    ad_data)

input_dat

save(input_dat, file = "part 2/practical/tte_counts_input_data.RData")

#############
# run model #
#############

res <-
  bugs(
    model = here::here("part 2/tte_counts_BUGS_code.txt"),
    data = input_dat,
    inits = inits,
    parameters = "d",
    n.chains = 1,
    n.burnin = 100,
    n.iter = 10000,
    debug = TRUE)
