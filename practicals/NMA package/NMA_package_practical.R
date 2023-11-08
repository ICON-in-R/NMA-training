#' ---
#' title: "NMA package practical"
#' format: pdf
#' editor: visual
#' ---
#' 
#' ## Introduction
#' 
#' In this practical we repeat the analysis from the previous practical but using the `NMA` package.
#' 
#' ## Install `NMA` package
#' 
#' Obtain `NMA` from GitHub using the following.
#' 
## ----warning=FALSE, message=FALSE----------------------------------------------------------------------------------------------------------------------------------------------------------------
if (!require(NMA)) remotes::install_github("ICON-in-R/NMA")

#' 
#' ## Data preparation
#' 
#' Firstly, load the study data in to the workspace from the `NMA-tutorial` project.
#' 
## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
load(here::here("practicals","BUGS","smoke.Rdata"))

#' 
#' The original data are in an R `list` format and look like this
#' 
## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
smoke.list

#' 
#' In many cases, the data you are provided with is not in the correct format to plug into the code for the NMA, and this is the case here.
#' 
#' We need to rearrange this data in to the format that the `NMA` function requires before we can do the analysis. Generally, learning how to *munge* or *wrangle* is worth the time and effort.
#' 
#' We want a single array with a column for "study", "treatment", "n" and "r". There are several ways to achieve this but we will make use of the `reshape2` package to *melt* the data in to the shape we want. That is, we change the shape of the data from a wide array to a long array so that we will only have one column with values in.
#' 
#' Specifically, the following code converts the original data to a long format, renames the columns and then removed rows which don't have any values in.
#' 
#' We do this for both number of counts ($r$) and sample size ($n$).
#' 
## ----warning=FALSE, message=FALSE----------------------------------------------------------------------------------------------------------------------------------------------------------------
library(dplyr)
library(reshape2)

r_data <- melt(smoke.list$r) |>               # rearrange to 'long' format
  `names<-`(c("study", "treatment", "r")) |>  # rename columns
  na.omit()

n_data <- melt(smoke.list$n) |>
  `names<-`(c("study", "treatment", "n")) |>
  na.omit()

head(r_data)

#' 
#' The last thing to do is combine these two arrays into a single object. We can simply append one to another or a more elegant and robust way is to *join* them. This will ensure that the correct rows are match up between arrays. The command to do this in base R is `merge()`. We just rearrange the columns in to a nice order at the end.
#' 
## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
data <- merge(r_data, n_data,
              by = c("study", "treatment")) |>  # which columns to match
  arrange(study)                                # ascending order

head(data)

#' 
#' ## Analysis
#' 
#' The workflow is to first create and NMA object separately to actually doing the fitting. This then means that we can perform modified fits but we don't have to redo any of the preparatory work.
#' 
#' We define the BUGS specific parameter values in the same way as for the first practical and also some extra values to specify whether fixed or random effects model.
#' 
## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
library(NMA)

bugs_params <-
  list(
    PROG = "openBugs",  # which version of BUGS to use to run the MCMC
    N.BURNIN = 10,#00,  # number of steps to throw away
    N.SIMS = 150,#0,    # total number of simulations
    N.CHAINS = 2,       # number of chains
    N.THIN = 1,         # thinning rate
    PAUSE = TRUE)

RANDOM <- FALSE             # is this a random effects model?
REFTX <- "X"                # reference treatment
data_type <- "bin_data"     # which type of data to use
label_name <- "label_name"

nma_model <-
  new_NMA(binData = data,
          bugs_params = bugs_params,
          is_random = RANDOM,
          data_type = data_type,
          refTx = REFTX,
          effectParam = "d",  # which parameters to 'monitor' i.e. record
          label = "",
          endpoint = "")

nma_model

#' 
#' The `NMA` object can simply be passed to the `NMA_run()` function to do the analysis using BUGS.
#' 
## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
nma_res <- NMA_run(nma_model, save = FALSE)
nma_res

#' 
#' -   `totresdev` is the total residual deviance
