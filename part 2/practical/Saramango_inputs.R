
### Dataset 1: Constants to define for IPD evidence

list(n.subjects1 = 386,  # Number of participants in IPD 1
     n.subjects2 = 454,  # Number of participants in IPD 2
     treat = 9,  # Number of treatments being evaluated
     C1 = 9,  # Number of centres in IPD 1  
     C2 = 35  # Number of centres in IPD 2
     )

### Dataset 2: Constants to define for AD evidence###

list(n.agg.trials = 14,  # Number of AD studies
     n.agg.arms = 28)    # Number of AD study arms

### Dataset 3: IPD 1 ###
treat1[]	baseline1[]	t.obs1[]	t.cens1[]	cov1[]	centre1[]
1	1	3.50	0	1.95	3
1	1	2.33	0	1.94	9
2	1	NA	11.90	2.49	4
...	... 	... 	... 	... 	... 
...	... 	... 	... 	... 	... 
END
# treat1 = treatment arm (coded 1,2), baseline1 = reference treatment code, 
# t.obs1 = time to event in months (under censoring), t.cens1 = time of censoring in months,
# cov1 = continuous covariate of interest (R+), centre1 = trial centre code (coded 1-9)

### Dataset 4: IPD 2 ###
treat2[]	baseline2[]	t.obs2[]	t.cens2[]	cov1[]	centre2[]
1	1	NA	21.28	5.15	1
1	1	1.15	0	0.94	16
3	1	8.41	0	2.31	2
...	... 	... 	... 	... 	... 
...	... 	... 	... 	... 	... 
END
# treat2 = treatment arm (coded 1,2), baseline2 = reference treatment code, 
# t.obs2 = time to event in months (under censoring), t.cens2 = time of censoring in months,
# cov1 = continuous covariate of interest (R+), centre2 = trial centre code (coded 1-35)

### Dataset 5: AD evidence ###
a.s[]	a.treat []	r[]	n[]	a.base[]	a.time[]
1	1	11	25	1	12
1	2	10	25	1	12
...	... 	... 	... 	... 	... 
...	... 	... 	... 	... 	... 
END
# a.s = study number, a.treat = treatment arm code (coded from 1 to number of treatments), 
# r = number of events in trial arm, n = number of patients in trial arm,
# a.base = reference treatment code, a.time = follow-up time of trial (in months)

### Initial values, either need specifying or generating for the below scalars and vectors ###
list(
  d = c(NA, 0, 0, 0, 0, 0, 0, 0, 0),
  mu1 = -1,
  mu2 = -1,
  mu.a = c(-1, -1, -1, -1, -1,-1, -1, -1, -1, -1,-1, -1, -1, -1),
  beta_cov = 0,
  shape = 1,
  betac.new = 0,
  betac1 = c(0, 0, 0, 0, 0, 0, 0, 0, 0),
  betac2 = c(
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  )
)

