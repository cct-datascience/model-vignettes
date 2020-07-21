How to Reproduce BioCro Results for Night Time Temperature Experiments
================
Kristina Riemer, University of Arizona

For these experiments, **Setaria** were grown under two experimental treatments. The control plants were at 31C during the day and 22C at night, while high night time temp treatment was 31C at all times.

Biomass for these two treatments are estimated using BioCro version 0.95.

Section 1: BioCro Run for Control Parameters & Weather
======================================================

In `model-vignettes/BioCro/DARPA/`, there is a folder called `temp_exps_inputs1`.

Within that folder is a PEcAn Settings file called `temp.exps1.xml`. To learn more about the pecan settings file, see the [PEcAn Documentation](https://pecanproject.github.io/pecan-documentation/master/pecanXML.html#). There is also the R script that runs PEcAn and BioCro called `workflow.R`.

The Setaria constants are in the file `setaria.constants.xml`. This has biomass coefficients and starting biomass values. The same will be used for all runs. These parameters are defined in the `BioCro::BioGro` function documentation.

Generate control weather data file `danforth-control-chamber.2019.csv` with the R script `generate_control_weather.R` as shown below.

``` r
source("temp_exps_inputs1/generate_control_weather.R")
```

Then run the model for the treatment control.

``` bash
temp_exps_inputs1/workflow.R --settings temp_exps_inputs1/temp.exps1.xml
```

    ## Loading required package: PEcAn.DB
    ## Loading required package: PEcAn.settings
    ## Loading required package: PEcAn.MA
    ## Loading required package: XML
    ## Loading required package: lattice
    ## Loading required package: MASS
    ## Loading required package: PEcAn.utils
    ## 
    ## Attaching package: ‘PEcAn.utils’
    ## 
    ## The following object is masked from ‘package:utils’:
    ## 
    ##     download.file
    ## 
    ## Loading required package: PEcAn.logger
    ## 
    ## Attaching package: ‘PEcAn.logger’
    ## 
    ## The following objects are masked from ‘package:PEcAn.utils’:
    ## 
    ##     logger.debug, logger.error, logger.getLevel, logger.info,
    ##     logger.setLevel, logger.setOutputFile, logger.setQuitOnSevere,
    ##     logger.setWidth, logger.severe, logger.warn
    ## 
    ## Loading required package: PEcAn.uncertainty
    ## Loading required package: PEcAn.priors
    ## Loading required package: ggplot2
    ## Loading required package: ggmap
    ## Loading required package: gridExtra
    ## 
    ## Attaching package: ‘PEcAn.uncertainty’
    ## 
    ## The following objects are masked from ‘package:PEcAn.utils’:
    ## 
    ##     get.ensemble.samples, read.ensemble.output, write.ensemble.configs
    ## 
    ## Loading required package: PEcAn.data.atmosphere
    ## Loading required package: PEcAn.data.land
    ## Loading required package: datapack
    ## Loading required package: dataone
    ## Loading required package: redland
    ## Loading required package: sirt
    ## - sirt 3.1-80 (2019-01-04 12:08:59)
    ## Loading required package: sf
    ## Linking to GEOS 3.5.1, GDAL 2.1.2, PROJ 4.9.3
    ## Loading required package: PEcAn.data.remote
    ## Loading required package: PEcAn.assim.batch
    ## Loading required package: PEcAn.emulator
    ## Loading required package: mvtnorm
    ## Loading required package: mlegp
    ## Loading required package: MCMCpack
    ## Loading required package: coda
    ## ##
    ## ## Markov Chain Monte Carlo Package (MCMCpack)
    ## ## Copyright (C) 2003-2020 Andrew D. Martin, Kevin M. Quinn, and Jong Hee Park
    ## ##
    ## ## Support provided by the U.S. National Science Foundation
    ## ## (Grants SES-0350646 and SES-0350613)
    ## ##
    ## Loading required package: PEcAn.benchmark
    ## Loading required package: PEcAn.remote
    ## Loading required package: PEcAn.workflow
    ## 
    ## Attaching package: ‘PEcAn.workflow’
    ## 
    ## The following objects are masked from ‘package:PEcAn.utils’:
    ## 
    ##     do_conversions, run.write.configs, runModule.run.write.configs
    ## 
    ## Loading required package: bitops
    ## 2020-07-01 21:40:59 INFO   [PEcAn.settings::read.settings] : 
    ##    Loading --settings= temp_exps_inputs1/temp.exps1.xml 
    ## 2020-07-01 21:40:59 INFO   [fix.deprecated.settings] : 
    ##    Fixing deprecated settings... 
    ## 2020-07-01 21:40:59 INFO   [fix.deprecated.settings] : 
    ##    settings$run$host is deprecated. uwe settings$host instead 
    ## 2020-07-01 21:40:59 INFO   [update.settings] : 
    ##    Fixing deprecated settings... 
    ## 2020-07-01 21:40:59 INFO   [check.settings] : Checking settings... 
    ## 2020-07-01 21:41:00 INFO   [check.database] : 
    ##    Successfully connected to database : PostgreSQL bety bety postgres bety 
    ##    FALSE 
    ## 2020-07-01 21:41:00 WARN   [check.database.settings] : 
    ##    Will not write runs/configurations to database. 
    ## 2020-07-01 21:41:00 WARN   [check.bety.version] : 
    ##    Last migration 20181129000515 is more recent than expected 
    ##    20141009160121. This could result in PEcAn not working as expected. 
    ## 2020-07-01 21:41:00 INFO   [check.ensemble.settings] : 
    ##    No start date passed to ensemble - using the run date ( 2019 ). 
    ## 2020-07-01 21:41:00 INFO   [check.ensemble.settings] : 
    ##    No end date passed to ensemble - using the run date ( 2019 ). 
    ## 2020-07-01 21:41:00 INFO   [check.ensemble.settings] : 
    ##    We are updating the ensemble tag inside the xml file. 
    ## 2020-07-01 21:41:00 INFO   [fn] : 
    ##    No start date passed to sensitivity.analysis - using the run date ( 2019 
    ##    ). 
    ## 2020-07-01 21:41:00 INFO   [fn] : 
    ##    No end date passed to sensitivity.analysis - using the run date ( 2019 
    ##    ). 
    ## 2020-07-01 21:41:00 INFO   [fn] : 
    ##    Setting site name to Donald Danforth Plant Science Center Growth Chamber 
    ## 2020-07-01 21:41:00 INFO   [fn] : 
    ##    Setting site lat to 38.674593 
    ## 2020-07-01 21:41:00 INFO   [fn] : 
    ##    Setting site lon to -90.397189 
    ## 2020-07-01 21:41:00 INFO   [check.model.settings] : 
    ##    Setting model id to 9000000002 
    ## 2020-07-01 21:41:00 INFO   [check.model.settings] : 
    ##    Option to delete raw model output not set or not logical. Will keep all 
    ##    model output. 
    ## 2020-07-01 21:41:00 WARN   [PEcAn.DB::dbfile.file] : 
    ##    no files found for 9000000002 in database 
    ## 2020-07-01 21:41:00 WARN   [check.settings] : 
    ##    settings$database$dbfiles pathname temp_exps_results1/dbfiles is invalid 
    ##   
    ##    placing it in the home directory /home/kristinariemer 
    ## 2020-07-01 21:41:00 INFO   [fn] : 
    ##    Missing optional input : soil 
    ## 2020-07-01 21:41:00 WARN   [PEcAn.DB::dbfile.id] : 
    ##    no id found for 
    ##    ~/model-vignettes/BioCro/DARPA/temp_exps_inputs1/danforth-control-chamber 
    ##    in database 
    ## 2020-07-01 21:41:00 INFO   [fn] : 
    ##    path 
    ##    ~/model-vignettes/BioCro/DARPA/temp_exps_inputs1/danforth-control-chamber 
    ## 2020-07-01 21:41:00 INFO   [fn] : 
    ##    path 
    ##    ~/model-vignettes/BioCro/DARPA/temp_exps_inputs1/danforth-control-chamber 
    ## 2020-07-01 21:41:00 INFO   [check.workflow.settings] : 
    ##    output folder = 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1 
    ## 2020-07-01 21:41:00 INFO   [check.settings] : 
    ##    Storing pft SetariaWT_ME034 in 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/pft/SetariaWT_ME034 
    ## [1] "/home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/pecan.CHECKED.xml"
    ## 2020-07-01 21:41:01 DEBUG  [PEcAn.workflow::do_conversions] : 
    ##    do.conversion outdir /home/kristinariemer/temp_exps_results1/dbfiles 
    ## 2020-07-01 21:41:01 INFO   [PEcAn.workflow::do_conversions] : PROCESSING:  met 
    ## 2020-07-01 21:41:01 INFO   [PEcAn.workflow::do_conversions] : 
    ##    calling met.process: 
    ##    ~/model-vignettes/BioCro/DARPA/temp_exps_inputs1/danforth-control-chamber 
    ## 2020-07-01 21:41:01 WARN   [PEcAn.data.atmosphere::met.process] : 
    ##    met.process only has a path provided, assuming path is model driver and 
    ##    skipping processing 
    ## 2020-07-01 21:41:01 DEBUG  [PEcAn.workflow::do_conversions] : 
    ##    updated met path: 
    ##    ~/model-vignettes/BioCro/DARPA/temp_exps_inputs1/danforth-control-chamber 
    ## 2020-07-01 21:41:01 DEBUG  [PEcAn.DB::get.trait.data] : 
    ##    `trait.names` is NULL, so retrieving all traits that have at least one 
    ##    prior for these PFTs. 
    ## 2020-07-01 21:41:05 DEBUG  [FUN] : 
    ##    All posterior files are present. Performing additional checks to 
    ##    determine if meta-analysis needs to be updated. 
    ## 2020-07-01 21:41:05 WARN   [FUN] : 
    ##    The following files are in database but not found on disk: 
    ##    'trait.data.Rdata', 'prior.distns.Rdata', 'cultivars.csv' .  Re-running 
    ##    meta-analysis. 
    ## 2020-07-01 21:41:05 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:41:05 INFO   [query.trait.data] : stomatal_slope.BB 
    ## 2020-07-01 21:41:05 INFO   [query.trait.data] : 
    ##    Median stomatal_slope.BB : 4.19 
    ## 2020-07-01 21:41:05 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:41:05 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:41:05 INFO   [query.trait.data] : 
    ##    leaf_respiration_rate_m2 
    ## 2020-07-01 21:41:05 INFO   [query.trait.data] : 
    ##    Median leaf_respiration_rate_m2 : 1.2 
    ## 2020-07-01 21:41:05 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:41:05 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:41:05 INFO   [query.trait.data] : Vcmax 
    ## 2020-07-01 21:41:05 INFO   [query.trait.data] : Median Vcmax : 18.9 
    ## 2020-07-01 21:41:05 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:41:05 INFO   [FUN] : 
    ##  Number of observations per trait for PFT  'SetariaWT_ME034' :
    ##  # A tibble: 3 x 2
    ##   trait                       nn
    ##   <chr>                    <int>
    ## 1 leaf_respiration_rate_m2    15
    ## 2 stomatal_slope.BB            5
    ## 3 Vcmax                       15 
    ## 2020-07-01 21:41:06 INFO   [FUN] : 
    ##  Summary of prior distributions for PFT  'SetariaWT_ME034' :
    ##                                   distn parama paramb   n
    ## Vcmax                            lnorm  3.750   0.30  12
    ## c2n_leaf                         gamma  4.180   0.13  95
    ## cuticular_cond                   lnorm  8.400   0.90   0
    ## SLA                            weibull  2.060  19.00 125
    ## leaf_respiration_rate_m2         lnorm  0.632   0.65  32
    ## stomatal_slope.BB                lnorm  1.240   0.28   2
    ## growth_respiration_coefficient    beta 26.000  48.00  NA
    ## extinction_coefficient_diffuse   gamma  5.000  10.00  NA 
    ## 2020-07-01 21:41:06 DEBUG  [FUN] : The following posterior files found in PFT outdir  ( '/home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/pft/SetariaWT_ME034' ) will be registered in BETY  under posterior ID  9000000389 :  'cultivars.csv', 'prior.distns.csv', 'prior.distns.Rdata', 'trait.data.csv', 'trait.data.Rdata' .  The following files (if any) will not be registered because they already existed:   
    ## 
    ## Attaching package: ‘dplyr’
    ## 
    ## The following object is masked from ‘package:gridExtra’:
    ## 
    ##     combine
    ## 
    ## The following object is masked from ‘package:MASS’:
    ## 
    ##     select
    ## 
    ## The following objects are masked from ‘package:stats’:
    ## 
    ##     filter, lag
    ## 
    ## The following objects are masked from ‘package:base’:
    ## 
    ##     intersect, setdiff, setequal, union
    ## 
    ## [1] "/home/kristinariemer/model-vignettes/BioCro/DARPA"
    ## [1] TRUE
    ## 2020-07-01 21:41:07 INFO   [FUN] : 
    ##    ------------------------------------------------------------------- 
    ## 2020-07-01 21:41:07 INFO   [FUN] : 
    ##    Running meta.analysis for PFT: SetariaWT_ME034 
    ## 2020-07-01 21:41:07 INFO   [FUN] : 
    ##    ------------------------------------------------------------------- 
    ## 2020-07-01 21:41:07 INFO   [check_consistent] : 
    ##    OK!  stomatal_slope.BB data and prior are consistent: 
    ## 2020-07-01 21:41:07 INFO   [check_consistent] : 
    ##    stomatal_slope.BB P[X<x] = 0.754341900665641 
    ## 2020-07-01 21:41:07 INFO   [check_consistent] : 
    ##    OK!  leaf_respiration_rate_m2 data and prior are consistent: 
    ## 2020-07-01 21:41:07 INFO   [check_consistent] : 
    ##    leaf_respiration_rate_m2 P[X<x] = 0.244527389092738 
    ## 2020-07-01 21:41:07 WARN   [check_consistent] : 
    ##    CHECK THIS: Vcmax data and prior are inconsistent: 
    ## 2020-07-01 21:41:07 INFO   [check_consistent] : 
    ##    Vcmax P[X<x] = 0.00158979470946304 
    ## Each meta-analysis will be run with: 
    ## 3000 total iterations,
    ## 4 chains, 
    ## a burnin of 1500 samples,
    ## , 
    ## thus the total number of samples will be 6000
    ## ################################################
    ## ------------------------------------------------
    ## starting meta-analysis for:
    ## 
    ##  stomatal_slope.BB 
    ## 
    ## ------------------------------------------------
    ## prior for stomatal_slope.BB
    ##                      (using R parameterization):
    ## lnorm(1.24, 0.28)
    ## data max: 5.75 
    ## data min: 1.67 
    ## mean: 4 
    ## n: 5
    ## stem plot of data points
    ## 
    ##   The decimal point is at the |
    ## 
    ##   1 | 7
    ##   2 | 
    ##   3 | 5
    ##   4 | 29
    ##   5 | 8
    ## 
    ## stem plot of obs.prec:
    ## 
    ##   The decimal point is at the |
    ## 
    ##   0 | 0001
    ##   0 | 
    ##   1 | 
    ##   1 | 6
    ## 
    ## Read 28 items
    ## Compiling model graph
    ##    Resolving undeclared variables
    ##    Allocating nodes
    ## Graph information:
    ##    Observed stochastic nodes: 10
    ##    Unobserved stochastic nodes: 4
    ##    Total graph size: 56
    ## 
    ## Initializing model
    ## 
    ## 
    ## Iterations = 1002:4000
    ## Thinning interval = 2 
    ## Number of chains = 4 
    ## Sample size per chain = 1500 
    ## 
    ## 1. Empirical mean and standard deviation for each variable,
    ##    plus standard error of the mean:
    ## 
    ##                Mean      SD Naive SE Time-series SE
    ## beta.o       4.2575  0.7083 0.009144       0.016130
    ## beta.trt[2] -0.7898  0.9394 0.012128       0.022025
    ## sd.trt       6.2374 69.3061 0.894738       0.899941
    ## sd.y         1.7168  0.3123 0.004032       0.005259
    ## 
    ## 2. Quantiles for each variable:
    ## 
    ##                2.5%     25%     50%      75%  97.5%
    ## beta.o       2.9549  3.7675  4.2170  4.70454  5.737
    ## beta.trt[2] -2.9744 -1.4173 -0.5671 -0.06495  0.583
    ## sd.trt       0.1049  0.3996  1.0765  2.78585 28.473
    ## sd.y         1.1406  1.4999  1.7040  1.91847  2.360
    ## 
    ## ################################################
    ## ------------------------------------------------
    ## starting meta-analysis for:
    ## 
    ##  leaf_respiration_rate_m2 
    ## 
    ## ------------------------------------------------
    ## prior for leaf_respiration_rate_m2
    ##                      (using R parameterization):
    ## lnorm(0.632, 0.65)
    ## data max: 2.17 
    ## data min: 0.746 
    ## mean: 1.28 
    ## n: 15
    ## stem plot of data points
    ## 
    ##   The decimal point is at the |
    ## 
    ##   0 | 789
    ##   1 | 00112334
    ##   1 | 579
    ##   2 | 2
    ## 
    ## stem plot of obs.prec:
    ## 
    ##   The decimal point is 2 digit(s) to the right of the |
    ## 
    ##   0 | 1444
    ##   0 | 556899
    ##   1 | 133
    ##   1 | 66
    ## 
    ## Read 28 items
    ## Compiling model graph
    ##    Resolving undeclared variables
    ##    Allocating nodes
    ## Graph information:
    ##    Observed stochastic nodes: 30
    ##    Unobserved stochastic nodes: 4
    ##    Total graph size: 116
    ## 
    ## Initializing model
    ## 
    ## 
    ## Iterations = 1002:4000
    ## Thinning interval = 2 
    ## Number of chains = 4 
    ## Sample size per chain = 1500 
    ## 
    ## 1. Empirical mean and standard deviation for each variable,
    ##    plus standard error of the mean:
    ## 
    ##                Mean       SD Naive SE Time-series SE
    ## beta.o       1.4624  0.09300 0.001201       0.001681
    ## beta.trt[2] -0.4597  0.15050 0.001943       0.002725
    ## sd.trt       3.0194 36.94027 0.476897       0.476940
    ## sd.y         0.3754  0.03571 0.000461       0.000503
    ## 
    ## 2. Quantiles for each variable:
    ## 
    ##                2.5%     25%     50%     75%   97.5%
    ## beta.o       1.2780  1.4025  1.4635  1.5233  1.6447
    ## beta.trt[2] -0.7468 -0.5609 -0.4648 -0.3625 -0.1539
    ## sd.trt       0.1421  0.3784  0.6627  1.4167 13.5363
    ## sd.y         0.3083  0.3507  0.3743  0.3989  0.4498
    ## 
    ## ################################################
    ## ------------------------------------------------
    ## starting meta-analysis for:
    ## 
    ##  Vcmax 
    ## 
    ## ------------------------------------------------
    ## prior for Vcmax
    ##                      (using R parameterization):
    ## lnorm(3.75, 0.3)
    ## data max: 22.5 
    ## data min: 14.4 
    ## mean: 18.4 
    ## n: 12
    ## stem plot of data points
    ## 
    ##   The decimal point is at the |
    ## 
    ##   14 | 489
    ##   16 | 0338
    ##   18 | 9
    ##   20 | 059
    ##   22 | 5
    ## 
    ## stem plot of obs.prec:
    ## 
    ##   The decimal point is 6 digit(s) to the right of the |
    ## 
    ##   0 | 00111122336
    ##   1 | 
    ##   2 | 
    ##   3 | 0
    ## 
    ## Read 28 items
    ## Compiling model graph
    ##    Resolving undeclared variables
    ##    Allocating nodes
    ## Graph information:
    ##    Observed stochastic nodes: 24
    ##    Unobserved stochastic nodes: 4
    ##    Total graph size: 98
    ## 
    ## Initializing model
    ## 
    ## 
    ## Iterations = 1002:4000
    ## Thinning interval = 2 
    ## Number of chains = 4 
    ## Sample size per chain = 1500 
    ## 
    ## 1. Empirical mean and standard deviation for each variable,
    ##    plus standard error of the mean:
    ## 
    ##                Mean        SD  Naive SE Time-series SE
    ## beta.o      19.3324 9.748e-02 0.0012584      1.844e-03
    ## beta.trt[2] -1.9420 1.350e-01 0.0017432      2.449e-03
    ## sd.trt      13.8876 1.940e+02 2.5045667      2.505e+00
    ## sd.y         0.3369 4.663e-03 0.0000602      6.229e-05
    ## 
    ## 2. Quantiles for each variable:
    ## 
    ##                2.5%     25%     50%    75%   97.5%
    ## beta.o      19.1454 19.2647 19.3333 19.398 19.5224
    ## beta.trt[2] -2.2073 -2.0335 -1.9420 -1.851 -1.6737
    ## sd.trt       0.8471  1.6921  2.9068  6.216 53.3386
    ## sd.y         0.3278  0.3337  0.3369  0.340  0.3462
    ## 
    ## 2020-07-01 21:41:09 INFO   [check_consistent] : 
    ##    OK!  stomatal_slope.BB data and prior are consistent: 
    ## 2020-07-01 21:41:09 INFO   [check_consistent] : 
    ##    stomatal_slope.BB P[X<x] = 0.762857356899334 
    ## 2020-07-01 21:41:09 INFO   [check_consistent] : 
    ##    OK!  leaf_respiration_rate_m2 data and prior are consistent: 
    ## 2020-07-01 21:41:09 INFO   [check_consistent] : 
    ##    leaf_respiration_rate_m2 P[X<x] = 0.349421657734449 
    ## 2020-07-01 21:41:09 WARN   [check_consistent] : 
    ##    CHECK THIS: Vcmax data and prior are inconsistent: 
    ## 2020-07-01 21:41:09 INFO   [check_consistent] : 
    ##    Vcmax P[X<x] = 0.00430521540116437 
    ## 2020-07-01 21:41:09 INFO   [pecan.ma.summary] : 
    ##    JAGS model converged for SetariaWT_ME034 stomatal_slope.BB GD MPSRF = 
    ##    1.003 
    ## 2020-07-01 21:41:10 INFO   [pecan.ma.summary] : 
    ##    JAGS model converged for SetariaWT_ME034 leaf_respiration_rate_m2 GD 
    ##    MPSRF = 1.002 
    ## 2020-07-01 21:41:10 INFO   [pecan.ma.summary] : 
    ##    JAGS model converged for SetariaWT_ME034 Vcmax GD MPSRF = 1.001 
    ## 2020-07-01 21:41:13 INFO   [PEcAn.uncertainty::get.parameter.samples] : 
    ##    Selected PFT(s): SetariaWT_ME034 
    ## Warning in rm(prior.distns, post.distns, trait.mcmc) :
    ##   object 'prior.distns' not found
    ## Warning in rm(prior.distns, post.distns, trait.mcmc) :
    ##   object 'post.distns' not found
    ## Warning in rm(prior.distns, post.distns, trait.mcmc) :
    ##   object 'trait.mcmc' not found
    ## 2020-07-01 21:41:13 INFO   [PEcAn.uncertainty::get.parameter.samples] : 
    ##    PFT SetariaWT_ME034 has MCMC samples for: stomatal_slope.BB 
    ##    leaf_respiration_rate_m2 Vcmax 
    ## 2020-07-01 21:41:13 INFO   [PEcAn.uncertainty::get.parameter.samples] : 
    ##    PFT SetariaWT_ME034 will use prior distributions for: c2n_leaf 
    ##    cuticular_cond SLA growth_respiration_coefficient 
    ##    extinction_coefficient_diffuse 
    ## 2020-07-01 21:41:13 INFO   [PEcAn.uncertainty::get.parameter.samples] : 
    ##    using 5004 samples per trait 
    ## 2020-07-01 21:41:14 INFO   [PEcAn.uncertainty::get.parameter.samples] : 
    ##    Selected Quantiles: 
    ##    '0.001','0.023','0.159','0.5','0.841','0.977','0.999' 
    ## 2020-07-01 21:41:14 INFO   [get.ensemble.samples] : 
    ##    Using uniform random sampling 
    ## Loading required package: PEcAn.BIOCRO
    ## 2020-07-01 21:41:15 INFO   [PEcAn.workflow::run.write.configs] : 
    ##    ----- Writing model run config files ---- 
    ## Read 34 items
    ## 2020-07-01 21:41:16 WARN   [write.config.BIOCRO] : 
    ##    the following traits parameters are not added to config file: 
    ##    'type','canopyControl','iPlantControl','photoParms','phenoControl','seneControl','soilControl','phenoParms' 
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## 2020-07-01 21:41:26 INFO   [PEcAn.workflow::run.write.configs] : 
    ##    ###### Finished writing model run config files ##### 
    ## 2020-07-01 21:41:26 INFO   [PEcAn.workflow::run.write.configs] : 
    ##    config files samples in 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/run 
    ## 2020-07-01 21:41:26 INFO   [PEcAn.workflow::run.write.configs] : 
    ##    parameter values for runs in 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/samples.RData 
    ## 2020-07-01 21:41:26 INFO   [start.model.runs] : 
    ##    ------------------------------------------------------------------- 
    ## 2020-07-01 21:41:26 INFO   [start.model.runs] : 
    ##    Starting model runs BIOCRO 
    ## 2020-07-01 21:41:26 INFO   [start.model.runs] : 
    ##    ------------------------------------------------------------------- 
    ## 
      |                                                                            
      |                                                                      |   0%2020-07-01 21:41:26 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:41:29 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=                                                                     |   2%2020-07-01 21:41:29 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:41:32 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==                                                                    |   3%2020-07-01 21:41:32 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:41:34 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |====                                                                  |   5%2020-07-01 21:41:34 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:41:36 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=====                                                                 |   7%2020-07-01 21:41:36 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:41:39 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |======                                                                |   8%2020-07-01 21:41:39 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:41:41 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=======                                                               |  10%2020-07-01 21:41:41 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:41:44 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |========                                                              |  12%2020-07-01 21:41:44 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:41:46 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=========                                                             |  14%2020-07-01 21:41:46 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:41:48 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===========                                                           |  15%2020-07-01 21:41:48 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:41:51 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |============                                                          |  17%2020-07-01 21:41:51 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:41:53 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=============                                                         |  19%2020-07-01 21:41:53 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:41:56 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==============                                                        |  20%2020-07-01 21:41:56 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:41:58 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===============                                                       |  22%2020-07-01 21:41:58 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:00 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=================                                                     |  24%2020-07-01 21:42:00 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:03 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==================                                                    |  25%2020-07-01 21:42:03 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:05 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===================                                                   |  27%2020-07-01 21:42:05 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:08 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |====================                                                  |  29%2020-07-01 21:42:08 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:10 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=====================                                                 |  31%2020-07-01 21:42:10 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:12 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=======================                                               |  32%2020-07-01 21:42:12 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:15 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |========================                                              |  34%2020-07-01 21:42:15 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:17 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=========================                                             |  36%2020-07-01 21:42:17 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:19 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==========================                                            |  37%2020-07-01 21:42:19 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:22 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===========================                                           |  39%2020-07-01 21:42:22 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:24 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |============================                                          |  41%2020-07-01 21:42:24 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:27 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==============================                                        |  42%2020-07-01 21:42:27 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:29 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===============================                                       |  44%2020-07-01 21:42:29 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:31 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |================================                                      |  46%2020-07-01 21:42:31 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:34 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=================================                                     |  47%2020-07-01 21:42:34 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:36 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==================================                                    |  49%2020-07-01 21:42:36 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:38 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |====================================                                  |  51%2020-07-01 21:42:38 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:41 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=====================================                                 |  53%2020-07-01 21:42:41 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:43 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |======================================                                |  54%2020-07-01 21:42:43 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:46 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=======================================                               |  56%2020-07-01 21:42:46 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:48 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |========================================                              |  58%2020-07-01 21:42:48 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:50 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==========================================                            |  59%2020-07-01 21:42:50 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:53 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===========================================                           |  61%2020-07-01 21:42:53 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:55 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |============================================                          |  63%2020-07-01 21:42:55 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:42:57 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=============================================                         |  64%2020-07-01 21:42:57 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:00 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==============================================                        |  66%2020-07-01 21:43:00 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:02 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===============================================                       |  68%2020-07-01 21:43:02 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:04 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=================================================                     |  69%2020-07-01 21:43:04 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:07 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==================================================                    |  71%2020-07-01 21:43:07 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:09 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===================================================                   |  73%2020-07-01 21:43:09 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:12 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |====================================================                  |  75%2020-07-01 21:43:12 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:14 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=====================================================                 |  76%2020-07-01 21:43:14 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:16 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=======================================================               |  78%2020-07-01 21:43:16 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:19 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |========================================================              |  80%2020-07-01 21:43:19 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:21 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=========================================================             |  81%2020-07-01 21:43:21 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:23 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==========================================================            |  83%2020-07-01 21:43:23 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:25 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===========================================================           |  85%2020-07-01 21:43:25 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:28 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=============================================================         |  86%2020-07-01 21:43:28 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:30 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==============================================================        |  88%2020-07-01 21:43:30 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:33 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===============================================================       |  90%2020-07-01 21:43:33 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:35 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |================================================================      |  92%2020-07-01 21:43:35 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:38 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=================================================================     |  93%2020-07-01 21:43:38 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:40 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==================================================================    |  95%2020-07-01 21:43:40 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:42 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |====================================================================  |  97%2020-07-01 21:43:42 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:45 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===================================================================== |  98%2020-07-01 21:43:45 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:43:47 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |======================================================================| 100%
    ## 2020-07-01 21:43:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-Vcmax-0.001/2019.nc 
    ## 2020-07-01 21:43:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-Vcmax-0.023/2019.nc 
    ## 2020-07-01 21:43:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-Vcmax-0.159/2019.nc 
    ## 2020-07-01 21:43:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-median/2019.nc 
    ## 2020-07-01 21:43:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-Vcmax-0.841/2019.nc 
    ## 2020-07-01 21:43:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-Vcmax-0.977/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-Vcmax-0.999/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait Vcmax 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-c2n_leaf-0.001/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-c2n_leaf-0.023/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-c2n_leaf-0.159/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-median/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-c2n_leaf-0.841/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-c2n_leaf-0.977/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-c2n_leaf-0.999/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait c2n_leaf 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-cuticular_cond-0.001/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-cuticular_cond-0.023/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-cuticular_cond-0.159/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-median/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-cuticular_cond-0.841/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-cuticular_cond-0.977/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-cuticular_cond-0.999/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait cuticular_cond 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-SLA-0.001/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-SLA-0.023/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-SLA-0.159/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-median/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-SLA-0.841/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.285  0.282 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-SLA-0.977/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.295  0.283 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-SLA-0.999/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.303  0.282 
    ## 2020-07-01 21:43:48 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait SLA 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.001/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.023/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.159/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-median/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.841/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.977/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.999/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait leaf_respiration_rate_m2 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.001/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.023/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.159/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-median/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.841/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.977/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.999/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait stomatal_slope.BB 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.001/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.023/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.159/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-median/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.841/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.977/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.999/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait 
    ##    growth_respiration_coefficient 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.001/2019.nc 
    ## 2020-07-01 21:43:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.023/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:49 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.159/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:49 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-median/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:49 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.841/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:49 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.977/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:49 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.999/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:49 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait 
    ##    extinction_coefficient_diffuse 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00001-9000000004 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00001-9000000004/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00002-9000000004 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00002-9000000004/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00003-9000000004 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00003-9000000004/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00004-9000000004 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00004-9000000004/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00005-9000000004 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00005-9000000004/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00006-9000000004 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00006-9000000004/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00007-9000000004 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00007-9000000004/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00008-9000000004 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00008-9000000004/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00009-9000000004 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00009-9000000004/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00010-9000000004 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00010-9000000004/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.283  0.281 
    ## [1] "----- Variable: TotLivBiom"
    ## [1] "----- Running ensemble analysis for site:  Donald Danforth Plant Science Center Growth Chamber"
    ## [1] "----- Done!"
    ## [1] " "
    ## [1] "-----------------------------------------------"
    ## [1] " "
    ## [1] " "
    ## [1] "------ Generating ensemble time-series plot ------"
    ## [1] "----- Variable: TotLivBiom"
    ## [1] "----- Reading ensemble output ------"
    ## [1] "ENS-00001-9000000004"
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00001-9000000004/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## [1] "ENS-00002-9000000004"
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00002-9000000004/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "ENS-00003-9000000004"
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00003-9000000004/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## [1] "ENS-00004-9000000004"
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00004-9000000004/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "ENS-00005-9000000004"
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00005-9000000004/2019.nc 
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "ENS-00006-9000000004"
    ## 2020-07-01 21:43:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00006-9000000004/2019.nc 
    ## 2020-07-01 21:43:50 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "ENS-00007-9000000004"
    ## 2020-07-01 21:43:50 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00007-9000000004/2019.nc 
    ## 2020-07-01 21:43:50 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## [1] "ENS-00008-9000000004"
    ## 2020-07-01 21:43:50 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00008-9000000004/2019.nc 
    ## 2020-07-01 21:43:50 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "ENS-00009-9000000004"
    ## 2020-07-01 21:43:50 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00009-9000000004/2019.nc 
    ## 2020-07-01 21:43:50 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "ENS-00010-9000000004"
    ## 2020-07-01 21:43:50 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results1/out/ENS-00010-9000000004/2019.nc 
    ## 2020-07-01 21:43:50 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.283  0.281 
    ## $coef.vars
    ##                          Vcmax                       c2n_leaf 
    ##                    0.005034695                    0.538053210 
    ##                 cuticular_cond                            SLA 
    ##                    1.781853682                    0.539627093 
    ##       leaf_respiration_rate_m2              stomatal_slope.BB 
    ##                    0.063580752                    0.168593693 
    ## growth_respiration_coefficient extinction_coefficient_diffuse 
    ##                    0.156231561                    0.486429550 
    ## 
    ## $elasticities
    ##                          Vcmax                       c2n_leaf 
    ##                   5.263627e-03                   0.000000e+00 
    ##                 cuticular_cond                            SLA 
    ##                   2.841696e-04                   1.360858e-02 
    ##       leaf_respiration_rate_m2              stomatal_slope.BB 
    ##                  -1.800370e-03                   5.238947e-03 
    ## growth_respiration_coefficient extinction_coefficient_diffuse 
    ##                   0.000000e+00                  -1.788828e-06 
    ## 
    ## $sensitivities
    ##                          Vcmax                       c2n_leaf 
    ##                   7.665204e-05                   0.000000e+00 
    ##                 cuticular_cond                            SLA 
    ##                   1.827280e-08                   2.422133e-04 
    ##       leaf_respiration_rate_m2              stomatal_slope.BB 
    ##                  -3.464635e-04                   3.493540e-04 
    ## growth_respiration_coefficient extinction_coefficient_diffuse 
    ##                   0.000000e+00                  -1.101515e-06 
    ## 
    ## $variances
    ##                          Vcmax                       c2n_leaf 
    ##                   5.557232e-11                   2.562261e-34 
    ##                 cuticular_cond                            SLA 
    ##                   1.070149e-08                   1.315707e-05 
    ##       leaf_respiration_rate_m2              stomatal_slope.BB 
    ##                   1.039439e-09                   6.375253e-08 
    ## growth_respiration_coefficient extinction_coefficient_diffuse 
    ##                   2.365164e-34                   5.990941e-14 
    ## 
    ## $partial.variances
    ##                          Vcmax                       c2n_leaf 
    ##                   4.199647e-06                   1.936322e-29 
    ##                 cuticular_cond                            SLA 
    ##                   8.087207e-04                   9.942907e-01 
    ##       leaf_respiration_rate_m2              stomatal_slope.BB 
    ##                   7.855127e-05                   4.817832e-03 
    ## growth_respiration_coefficient extinction_coefficient_diffuse 
    ##                   1.787374e-29                   4.527404e-09 
    ## 
    ##            Vcmax  c2n_leaf cuticular_cond       SLA leaf_respiration_rate_m2
    ## 0.135  0.2815285 0.2815506      0.2814640 0.2805960                0.2816546
    ## 2.275  0.2815358 0.2815506      0.2814722 0.2806284                0.2816169
    ## 15.866 0.2815428 0.2815506      0.2814996 0.2807685                0.2815831
    ## 50     0.2815506 0.2815506      0.2815506 0.2815506                0.2815506
    ## 84.134 0.2815579 0.2815506      0.2816613 0.2852874                0.2815193
    ## 97.725 0.2815653 0.2815506      0.2818624 0.2949311                0.2814876
    ## 99.865 0.2815733 0.2815506      0.2821513 0.3025783                0.2814521
    ##        stomatal_slope.BB growth_respiration_coefficient
    ## 0.135          0.2806217                      0.2815506
    ## 2.275          0.2809239                      0.2815506
    ## 15.866         0.2812871                      0.2815506
    ## 50             0.2815506                      0.2815506
    ## 84.134         0.2817738                      0.2815506
    ## 97.725         0.2819448                      0.2815506
    ## 99.865         0.2820630                      0.2815506
    ##        extinction_coefficient_diffuse
    ## 0.135                       0.2815510
    ## 2.275                       0.2815509
    ## 15.866                      0.2815508
    ## 50                          0.2815506
    ## 84.134                      0.2815503
    ## 97.725                      0.2815499
    ## 99.865                      0.2815495
    ## TableGrob (4 x 2) "arrange": 8 grobs
    ##                                z     cells    name           grob
    ## Vcmax                          1 (1-1,1-1) arrange gtable[layout]
    ## c2n_leaf                       2 (1-1,2-2) arrange gtable[layout]
    ## cuticular_cond                 3 (2-2,1-1) arrange gtable[layout]
    ## SLA                            4 (2-2,2-2) arrange gtable[layout]
    ## leaf_respiration_rate_m2       5 (3-3,1-1) arrange gtable[layout]
    ## stomatal_slope.BB              6 (3-3,2-2) arrange gtable[layout]
    ## growth_respiration_coefficient 7 (4-4,1-1) arrange gtable[layout]
    ## extinction_coefficient_diffuse 8 (4-4,2-2) arrange gtable[layout]
    ## $Vcmax
    ## 
    ## $c2n_leaf
    ## 
    ## $cuticular_cond
    ## 
    ## $SLA
    ## 
    ## $leaf_respiration_rate_m2
    ## 
    ## $stomatal_slope.BB
    ## 
    ## $growth_respiration_coefficient
    ## 
    ## $extinction_coefficient_diffuse
    ## 
    ## 2020-07-01 21:43:58 INFO   [db.print.connections] : 
    ##    Created 9 connections and executed 92 queries 
    ## 2020-07-01 21:43:58 INFO   [db.print.connections] : 
    ##    Created 9 connections and executed 92 queries 
    ## 2020-07-01 21:43:58 DEBUG  [db.print.connections] : 
    ##    No open database connections. 
    ## [1] "---------- PEcAn Workflow Complete ----------"

``` r
dir.create("temp_exps_results")
file.copy("temp_exps_results1/", "temp_exps_results/", recursive = TRUE)
```

    ## [1] TRUE

``` r
unlink("temp_exps_results1/", recursive = TRUE)
file.copy("~/temp_exps_results1/dbfiles/", "temp_exps_results/temp_exps_results1/", recursive = TRUE)
```

    ## [1] TRUE

``` r
unlink("~/temp_exps_results1/", recursive = TRUE)
```

Plot results against measured biomass. Control data are downloaded from [the project's private data repo](https://github.com/az-digitalag/model-vignettes-data) and should be in `model-vignettes-data` in your home directory. The following code cleans up that biomass data, calculating number of days between treatment starting and biomass harvest, and converts biomass units from milligrams to megagrams per hectare (each plant grown in pot with 103 cm2 area).

This also pulls in and cleans up the biomass data estimated from BioCro, then plots biomass measurements against this.

``` r
# Libraries
library(readxl)
library(udunits2)
library(dplyr)
library(data.table)
library(tidyr)
library(ggplot2)

# Clean up biomass data
data_path <- "../../../model-vignettes-data/manual-measurements-Darpa_setaria_chambers_experiments.xlsx"
sheets_names <- excel_sheets(data_path)
area_cm2 <- 103
area_ha <- ud.convert(area_cm2, "cm2", "ha")

control_biomass <- read_excel(data_path, sheets_names[6]) %>% 
  rename(temperature...C..day.night = 6, 
         biomass.harvested = 11, 
         treatment.started = 9) %>% 
  filter(genotype == "ME034V-1", temperature...C..day.night == "31/22", 
         sample_for == "biomass") %>% 
  mutate(days_grown = as.integer(as.Date(as.character(biomass.harvested), format = "%Y-%m-%d") - 
                                   as.integer(as.Date(as.character(treatment.started), format = "%Y-%m-%d"))), 
         total_biomass_mg = panicle_DW_mg + stem_DW_mg + leaf_DW_mg + roots_DW_mg, 
         total_biomass_Mgha = ud.convert(total_biomass_mg, "mg", "Mg") / area_ha) %>% 
  filter(!is.na(total_biomass_Mgha))
write.csv(control_biomass, "temp_exps_inputs1/control_biomass_meas.csv")

# Clean up biomass estimates
load('temp_exps_results/temp_exps_results1/out/SA-median/biocro_output.RData')
timescale <- data.table(day = rep(biocro_result$doy, each = 24), hour = 0:23)
rm(biocro_result)

load("temp_exps_results/temp_exps_results1/ensemble.ts.NOENSEMBLEID.TotLivBiom.2019.2019.Rdata")
daily_biomass <- data.frame(timescale, t(ensemble.ts[["TotLivBiom"]])) %>% 
  gather(ensemble, biomass, X1:X10) %>% 
  group_by(day, hour) %>% 
  summarise(mean = mean(biomass, na.rm = TRUE), 
            median = median(biomass, na.rm = TRUE), 
            sd = sd(biomass, na.rm = TRUE), 
            lcl = quantile(biomass, probs = c(0.025), na.rm = TRUE), 
            ucl = quantile(biomass, probs = c(0.975), na.rm = TRUE)) %>% 
  group_by(day) %>% 
  summarise(mean = sum(mean), 
            median = sum(median), 
            sd = sqrt(sum(sd^2)), 
            lcl = sum(lcl), 
            ucl = sum(ucl))
write.csv(daily_biomass, "temp_exps_inputs1/biomass_ests1.csv")
rm(ensemble.ts)

# Plot measured biomass against biomass estimates
sd_scale <- 5
ggplot(data = daily_biomass) + 
  geom_line(aes(day, y = mean)) +
  geom_ribbon(aes(day, ymin = mean - sd_scale * sd, ymax = mean + sd_scale * sd), alpha = 0.1) +
  geom_ribbon(aes(day, ymin = lcl, ymax = ucl), alpha = 0.1) +
  #geom_point(data = control_biomass, aes(x = days_grown, y = total_biomass_Mgha)) +
  xlab("Day of Year") + 
  ylab("Total Biomass Mg/ha") +
  theme_classic()
```

Section 2: BioCro Run for Control Parameters & High Night Temperature Weather
=============================================================================

Similar to section 1, you will use the following files in the `temp_exps_inputs2` folder for this run: `temp.exps2.xml`, `workflow.R`, `setaria.constants.xml`.

Generate high night temp weather data file `danforth-highnight-chamber.2019.csv` with the R script `generate_highnight_weather.R` as shown below.

``` r
source("temp_exps_inputs2/generate_highnight_weather.R")
```

Then run the model for this experimental setup.

``` bash
temp_exps_inputs2/workflow.R --settings temp_exps_inputs2/temp.exps2.xml
```

    ## Loading required package: PEcAn.DB
    ## Loading required package: PEcAn.settings
    ## Loading required package: PEcAn.MA
    ## Loading required package: XML
    ## Loading required package: lattice
    ## Loading required package: MASS
    ## Loading required package: PEcAn.utils
    ## 
    ## Attaching package: ‘PEcAn.utils’
    ## 
    ## The following object is masked from ‘package:utils’:
    ## 
    ##     download.file
    ## 
    ## Loading required package: PEcAn.logger
    ## 
    ## Attaching package: ‘PEcAn.logger’
    ## 
    ## The following objects are masked from ‘package:PEcAn.utils’:
    ## 
    ##     logger.debug, logger.error, logger.getLevel, logger.info,
    ##     logger.setLevel, logger.setOutputFile, logger.setQuitOnSevere,
    ##     logger.setWidth, logger.severe, logger.warn
    ## 
    ## Loading required package: PEcAn.uncertainty
    ## Loading required package: PEcAn.priors
    ## Loading required package: ggplot2
    ## Loading required package: ggmap
    ## Loading required package: gridExtra
    ## 
    ## Attaching package: ‘PEcAn.uncertainty’
    ## 
    ## The following objects are masked from ‘package:PEcAn.utils’:
    ## 
    ##     get.ensemble.samples, read.ensemble.output, write.ensemble.configs
    ## 
    ## Loading required package: PEcAn.data.atmosphere
    ## Loading required package: PEcAn.data.land
    ## Loading required package: datapack
    ## Loading required package: dataone
    ## Loading required package: redland
    ## Loading required package: sirt
    ## - sirt 3.1-80 (2019-01-04 12:08:59)
    ## Loading required package: sf
    ## Linking to GEOS 3.5.1, GDAL 2.1.2, PROJ 4.9.3
    ## Loading required package: PEcAn.data.remote
    ## Loading required package: PEcAn.assim.batch
    ## Loading required package: PEcAn.emulator
    ## Loading required package: mvtnorm
    ## Loading required package: mlegp
    ## Loading required package: MCMCpack
    ## Loading required package: coda
    ## ##
    ## ## Markov Chain Monte Carlo Package (MCMCpack)
    ## ## Copyright (C) 2003-2020 Andrew D. Martin, Kevin M. Quinn, and Jong Hee Park
    ## ##
    ## ## Support provided by the U.S. National Science Foundation
    ## ## (Grants SES-0350646 and SES-0350613)
    ## ##
    ## Loading required package: PEcAn.benchmark
    ## Loading required package: PEcAn.remote
    ## Loading required package: PEcAn.workflow
    ## 
    ## Attaching package: ‘PEcAn.workflow’
    ## 
    ## The following objects are masked from ‘package:PEcAn.utils’:
    ## 
    ##     do_conversions, run.write.configs, runModule.run.write.configs
    ## 
    ## Loading required package: bitops
    ## 2020-07-01 21:44:06 INFO   [PEcAn.settings::read.settings] : 
    ##    Loading --settings= temp_exps_inputs2/temp.exps2.xml 
    ## 2020-07-01 21:44:06 INFO   [fix.deprecated.settings] : 
    ##    Fixing deprecated settings... 
    ## 2020-07-01 21:44:06 INFO   [fix.deprecated.settings] : 
    ##    settings$run$host is deprecated. uwe settings$host instead 
    ## 2020-07-01 21:44:06 INFO   [update.settings] : 
    ##    Fixing deprecated settings... 
    ## 2020-07-01 21:44:06 INFO   [check.settings] : Checking settings... 
    ## 2020-07-01 21:44:06 INFO   [check.database] : 
    ##    Successfully connected to database : PostgreSQL bety bety postgres bety 
    ##    FALSE 
    ## 2020-07-01 21:44:06 WARN   [check.database.settings] : 
    ##    Will not write runs/configurations to database. 
    ## 2020-07-01 21:44:06 WARN   [check.bety.version] : 
    ##    Last migration 20181129000515 is more recent than expected 
    ##    20141009160121. This could result in PEcAn not working as expected. 
    ## 2020-07-01 21:44:06 INFO   [check.ensemble.settings] : 
    ##    No start date passed to ensemble - using the run date ( 2019 ). 
    ## 2020-07-01 21:44:06 INFO   [check.ensemble.settings] : 
    ##    No end date passed to ensemble - using the run date ( 2019 ). 
    ## 2020-07-01 21:44:06 INFO   [check.ensemble.settings] : 
    ##    We are updating the ensemble tag inside the xml file. 
    ## 2020-07-01 21:44:06 INFO   [fn] : 
    ##    No start date passed to sensitivity.analysis - using the run date ( 2019 
    ##    ). 
    ## 2020-07-01 21:44:06 INFO   [fn] : 
    ##    No end date passed to sensitivity.analysis - using the run date ( 2019 
    ##    ). 
    ## 2020-07-01 21:44:06 INFO   [fn] : 
    ##    Setting site name to Donald Danforth Plant Science Center Growth Chamber 
    ## 2020-07-01 21:44:06 INFO   [fn] : 
    ##    Setting site lat to 38.674593 
    ## 2020-07-01 21:44:06 INFO   [fn] : 
    ##    Setting site lon to -90.397189 
    ## 2020-07-01 21:44:06 INFO   [check.model.settings] : 
    ##    Setting model id to 9000000002 
    ## 2020-07-01 21:44:06 INFO   [check.model.settings] : 
    ##    Option to delete raw model output not set or not logical. Will keep all 
    ##    model output. 
    ## 2020-07-01 21:44:06 WARN   [PEcAn.DB::dbfile.file] : 
    ##    no files found for 9000000002 in database 
    ## 2020-07-01 21:44:06 WARN   [check.settings] : 
    ##    settings$database$dbfiles pathname temp_exps_results2/dbfiles is invalid 
    ##   
    ##    placing it in the home directory /home/kristinariemer 
    ## 2020-07-01 21:44:06 INFO   [fn] : 
    ##    Missing optional input : soil 
    ## 2020-07-01 21:44:06 WARN   [PEcAn.DB::dbfile.id] : 
    ##    no id found for 
    ##    ~/model-vignettes/BioCro/DARPA/temp_exps_inputs2/danforth-highnight-chamber 
    ##    in database 
    ## 2020-07-01 21:44:06 INFO   [fn] : 
    ##    path 
    ##    ~/model-vignettes/BioCro/DARPA/temp_exps_inputs2/danforth-highnight-chamber 
    ## 2020-07-01 21:44:06 INFO   [fn] : 
    ##    path 
    ##    ~/model-vignettes/BioCro/DARPA/temp_exps_inputs2/danforth-highnight-chamber 
    ## 2020-07-01 21:44:06 INFO   [check.workflow.settings] : 
    ##    output folder = 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2 
    ## 2020-07-01 21:44:06 INFO   [check.settings] : 
    ##    Storing pft SetariaWT_ME034 in 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/pft/SetariaWT_ME034 
    ## [1] "/home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/pecan.CHECKED.xml"
    ## 2020-07-01 21:44:06 DEBUG  [PEcAn.workflow::do_conversions] : 
    ##    do.conversion outdir /home/kristinariemer/temp_exps_results2/dbfiles 
    ## 2020-07-01 21:44:06 INFO   [PEcAn.workflow::do_conversions] : PROCESSING:  met 
    ## 2020-07-01 21:44:06 INFO   [PEcAn.workflow::do_conversions] : 
    ##    calling met.process: 
    ##    ~/model-vignettes/BioCro/DARPA/temp_exps_inputs2/danforth-highnight-chamber 
    ## 2020-07-01 21:44:06 WARN   [PEcAn.data.atmosphere::met.process] : 
    ##    met.process only has a path provided, assuming path is model driver and 
    ##    skipping processing 
    ## 2020-07-01 21:44:06 DEBUG  [PEcAn.workflow::do_conversions] : 
    ##    updated met path: 
    ##    ~/model-vignettes/BioCro/DARPA/temp_exps_inputs2/danforth-highnight-chamber 
    ## 2020-07-01 21:44:07 DEBUG  [PEcAn.DB::get.trait.data] : 
    ##    `trait.names` is NULL, so retrieving all traits that have at least one 
    ##    prior for these PFTs. 
    ## 2020-07-01 21:44:09 DEBUG  [FUN] : 
    ##    All posterior files are present. Performing additional checks to 
    ##    determine if meta-analysis needs to be updated. 
    ## 2020-07-01 21:44:09 WARN   [FUN] : 
    ##    The following files are in database but not found on disk: 
    ##    'trait.data.Rdata', 'prior.distns.Rdata', 'cultivars.csv' .  Re-running 
    ##    meta-analysis. 
    ## 2020-07-01 21:44:09 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:44:09 INFO   [query.trait.data] : stomatal_slope.BB 
    ## 2020-07-01 21:44:09 INFO   [query.trait.data] : 
    ##    Median stomatal_slope.BB : 4.19 
    ## 2020-07-01 21:44:09 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:44:09 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:44:09 INFO   [query.trait.data] : 
    ##    leaf_respiration_rate_m2 
    ## 2020-07-01 21:44:09 INFO   [query.trait.data] : 
    ##    Median leaf_respiration_rate_m2 : 1.2 
    ## 2020-07-01 21:44:09 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:44:09 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:44:09 INFO   [query.trait.data] : Vcmax 
    ## 2020-07-01 21:44:09 INFO   [query.trait.data] : Median Vcmax : 18.9 
    ## 2020-07-01 21:44:09 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:44:09 INFO   [FUN] : 
    ##  Number of observations per trait for PFT  'SetariaWT_ME034' :
    ##  # A tibble: 3 x 2
    ##   trait                       nn
    ##   <chr>                    <int>
    ## 1 leaf_respiration_rate_m2    15
    ## 2 stomatal_slope.BB            5
    ## 3 Vcmax                       15 
    ## 2020-07-01 21:44:10 INFO   [FUN] : 
    ##  Summary of prior distributions for PFT  'SetariaWT_ME034' :
    ##                                   distn parama paramb   n
    ## Vcmax                            lnorm  3.750   0.30  12
    ## c2n_leaf                         gamma  4.180   0.13  95
    ## cuticular_cond                   lnorm  8.400   0.90   0
    ## SLA                            weibull  2.060  19.00 125
    ## leaf_respiration_rate_m2         lnorm  0.632   0.65  32
    ## stomatal_slope.BB                lnorm  1.240   0.28   2
    ## growth_respiration_coefficient    beta 26.000  48.00  NA
    ## extinction_coefficient_diffuse   gamma  5.000  10.00  NA 
    ## 2020-07-01 21:44:10 DEBUG  [FUN] : The following posterior files found in PFT outdir  ( '/home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/pft/SetariaWT_ME034' ) will be registered in BETY  under posterior ID  9000000390 :  'cultivars.csv', 'prior.distns.csv', 'prior.distns.Rdata', 'trait.data.csv', 'trait.data.Rdata' .  The following files (if any) will not be registered because they already existed:   
    ## 
    ## Attaching package: ‘dplyr’
    ## 
    ## The following object is masked from ‘package:gridExtra’:
    ## 
    ##     combine
    ## 
    ## The following object is masked from ‘package:MASS’:
    ## 
    ##     select
    ## 
    ## The following objects are masked from ‘package:stats’:
    ## 
    ##     filter, lag
    ## 
    ## The following objects are masked from ‘package:base’:
    ## 
    ##     intersect, setdiff, setequal, union
    ## 
    ## [1] "/home/kristinariemer/model-vignettes/BioCro/DARPA"
    ## [1] TRUE
    ## 2020-07-01 21:44:11 INFO   [FUN] : 
    ##    ------------------------------------------------------------------- 
    ## 2020-07-01 21:44:11 INFO   [FUN] : 
    ##    Running meta.analysis for PFT: SetariaWT_ME034 
    ## 2020-07-01 21:44:11 INFO   [FUN] : 
    ##    ------------------------------------------------------------------- 
    ## 2020-07-01 21:44:11 INFO   [check_consistent] : 
    ##    OK!  stomatal_slope.BB data and prior are consistent: 
    ## 2020-07-01 21:44:11 INFO   [check_consistent] : 
    ##    stomatal_slope.BB P[X<x] = 0.754341900665641 
    ## 2020-07-01 21:44:11 INFO   [check_consistent] : 
    ##    OK!  leaf_respiration_rate_m2 data and prior are consistent: 
    ## 2020-07-01 21:44:11 INFO   [check_consistent] : 
    ##    leaf_respiration_rate_m2 P[X<x] = 0.244527389092738 
    ## 2020-07-01 21:44:11 WARN   [check_consistent] : 
    ##    CHECK THIS: Vcmax data and prior are inconsistent: 
    ## 2020-07-01 21:44:11 INFO   [check_consistent] : 
    ##    Vcmax P[X<x] = 0.00158979470946304 
    ## Each meta-analysis will be run with: 
    ## 3000 total iterations,
    ## 4 chains, 
    ## a burnin of 1500 samples,
    ## , 
    ## thus the total number of samples will be 6000
    ## ################################################
    ## ------------------------------------------------
    ## starting meta-analysis for:
    ## 
    ##  stomatal_slope.BB 
    ## 
    ## ------------------------------------------------
    ## prior for stomatal_slope.BB
    ##                      (using R parameterization):
    ## lnorm(1.24, 0.28)
    ## data max: 5.75 
    ## data min: 1.67 
    ## mean: 4 
    ## n: 5
    ## stem plot of data points
    ## 
    ##   The decimal point is at the |
    ## 
    ##   1 | 7
    ##   2 | 
    ##   3 | 5
    ##   4 | 29
    ##   5 | 8
    ## 
    ## stem plot of obs.prec:
    ## 
    ##   The decimal point is at the |
    ## 
    ##   0 | 0001
    ##   0 | 
    ##   1 | 
    ##   1 | 6
    ## 
    ## Read 28 items
    ## Compiling model graph
    ##    Resolving undeclared variables
    ##    Allocating nodes
    ## Graph information:
    ##    Observed stochastic nodes: 10
    ##    Unobserved stochastic nodes: 4
    ##    Total graph size: 56
    ## 
    ## Initializing model
    ## 
    ## 
    ## Iterations = 1002:4000
    ## Thinning interval = 2 
    ## Number of chains = 4 
    ## Sample size per chain = 1500 
    ## 
    ## 1. Empirical mean and standard deviation for each variable,
    ##    plus standard error of the mean:
    ## 
    ##                Mean      SD Naive SE Time-series SE
    ## beta.o       4.2575  0.7083 0.009144       0.016130
    ## beta.trt[2] -0.7898  0.9394 0.012128       0.022025
    ## sd.trt       6.2374 69.3061 0.894738       0.899941
    ## sd.y         1.7168  0.3123 0.004032       0.005259
    ## 
    ## 2. Quantiles for each variable:
    ## 
    ##                2.5%     25%     50%      75%  97.5%
    ## beta.o       2.9549  3.7675  4.2170  4.70454  5.737
    ## beta.trt[2] -2.9744 -1.4173 -0.5671 -0.06495  0.583
    ## sd.trt       0.1049  0.3996  1.0765  2.78585 28.473
    ## sd.y         1.1406  1.4999  1.7040  1.91847  2.360
    ## 
    ## ################################################
    ## ------------------------------------------------
    ## starting meta-analysis for:
    ## 
    ##  leaf_respiration_rate_m2 
    ## 
    ## ------------------------------------------------
    ## prior for leaf_respiration_rate_m2
    ##                      (using R parameterization):
    ## lnorm(0.632, 0.65)
    ## data max: 2.17 
    ## data min: 0.746 
    ## mean: 1.28 
    ## n: 15
    ## stem plot of data points
    ## 
    ##   The decimal point is at the |
    ## 
    ##   0 | 789
    ##   1 | 00112334
    ##   1 | 579
    ##   2 | 2
    ## 
    ## stem plot of obs.prec:
    ## 
    ##   The decimal point is 2 digit(s) to the right of the |
    ## 
    ##   0 | 1444
    ##   0 | 556899
    ##   1 | 133
    ##   1 | 66
    ## 
    ## Read 28 items
    ## Compiling model graph
    ##    Resolving undeclared variables
    ##    Allocating nodes
    ## Graph information:
    ##    Observed stochastic nodes: 30
    ##    Unobserved stochastic nodes: 4
    ##    Total graph size: 116
    ## 
    ## Initializing model
    ## 
    ## 
    ## Iterations = 1002:4000
    ## Thinning interval = 2 
    ## Number of chains = 4 
    ## Sample size per chain = 1500 
    ## 
    ## 1. Empirical mean and standard deviation for each variable,
    ##    plus standard error of the mean:
    ## 
    ##                Mean       SD Naive SE Time-series SE
    ## beta.o       1.4624  0.09300 0.001201       0.001681
    ## beta.trt[2] -0.4597  0.15050 0.001943       0.002725
    ## sd.trt       3.0194 36.94027 0.476897       0.476940
    ## sd.y         0.3754  0.03571 0.000461       0.000503
    ## 
    ## 2. Quantiles for each variable:
    ## 
    ##                2.5%     25%     50%     75%   97.5%
    ## beta.o       1.2780  1.4025  1.4635  1.5233  1.6447
    ## beta.trt[2] -0.7468 -0.5609 -0.4648 -0.3625 -0.1539
    ## sd.trt       0.1421  0.3784  0.6627  1.4167 13.5363
    ## sd.y         0.3083  0.3507  0.3743  0.3989  0.4498
    ## 
    ## ################################################
    ## ------------------------------------------------
    ## starting meta-analysis for:
    ## 
    ##  Vcmax 
    ## 
    ## ------------------------------------------------
    ## prior for Vcmax
    ##                      (using R parameterization):
    ## lnorm(3.75, 0.3)
    ## data max: 22.5 
    ## data min: 14.4 
    ## mean: 18.4 
    ## n: 12
    ## stem plot of data points
    ## 
    ##   The decimal point is at the |
    ## 
    ##   14 | 489
    ##   16 | 0338
    ##   18 | 9
    ##   20 | 059
    ##   22 | 5
    ## 
    ## stem plot of obs.prec:
    ## 
    ##   The decimal point is 6 digit(s) to the right of the |
    ## 
    ##   0 | 00111122336
    ##   1 | 
    ##   2 | 
    ##   3 | 0
    ## 
    ## Read 28 items
    ## Compiling model graph
    ##    Resolving undeclared variables
    ##    Allocating nodes
    ## Graph information:
    ##    Observed stochastic nodes: 24
    ##    Unobserved stochastic nodes: 4
    ##    Total graph size: 98
    ## 
    ## Initializing model
    ## 
    ## 
    ## Iterations = 1002:4000
    ## Thinning interval = 2 
    ## Number of chains = 4 
    ## Sample size per chain = 1500 
    ## 
    ## 1. Empirical mean and standard deviation for each variable,
    ##    plus standard error of the mean:
    ## 
    ##                Mean        SD  Naive SE Time-series SE
    ## beta.o      19.3324 9.748e-02 0.0012584      1.844e-03
    ## beta.trt[2] -1.9420 1.350e-01 0.0017432      2.449e-03
    ## sd.trt      13.8876 1.940e+02 2.5045667      2.505e+00
    ## sd.y         0.3369 4.663e-03 0.0000602      6.229e-05
    ## 
    ## 2. Quantiles for each variable:
    ## 
    ##                2.5%     25%     50%    75%   97.5%
    ## beta.o      19.1454 19.2647 19.3333 19.398 19.5224
    ## beta.trt[2] -2.2073 -2.0335 -1.9420 -1.851 -1.6737
    ## sd.trt       0.8471  1.6921  2.9068  6.216 53.3386
    ## sd.y         0.3278  0.3337  0.3369  0.340  0.3462
    ## 
    ## 2020-07-01 21:44:12 INFO   [check_consistent] : 
    ##    OK!  stomatal_slope.BB data and prior are consistent: 
    ## 2020-07-01 21:44:12 INFO   [check_consistent] : 
    ##    stomatal_slope.BB P[X<x] = 0.762857356899334 
    ## 2020-07-01 21:44:12 INFO   [check_consistent] : 
    ##    OK!  leaf_respiration_rate_m2 data and prior are consistent: 
    ## 2020-07-01 21:44:12 INFO   [check_consistent] : 
    ##    leaf_respiration_rate_m2 P[X<x] = 0.349421657734449 
    ## 2020-07-01 21:44:12 WARN   [check_consistent] : 
    ##    CHECK THIS: Vcmax data and prior are inconsistent: 
    ## 2020-07-01 21:44:12 INFO   [check_consistent] : 
    ##    Vcmax P[X<x] = 0.00430521540116437 
    ## 2020-07-01 21:44:13 INFO   [pecan.ma.summary] : 
    ##    JAGS model converged for SetariaWT_ME034 stomatal_slope.BB GD MPSRF = 
    ##    1.003 
    ## 2020-07-01 21:44:13 INFO   [pecan.ma.summary] : 
    ##    JAGS model converged for SetariaWT_ME034 leaf_respiration_rate_m2 GD 
    ##    MPSRF = 1.002 
    ## 2020-07-01 21:44:14 INFO   [pecan.ma.summary] : 
    ##    JAGS model converged for SetariaWT_ME034 Vcmax GD MPSRF = 1.001 
    ## 2020-07-01 21:44:17 INFO   [PEcAn.uncertainty::get.parameter.samples] : 
    ##    Selected PFT(s): SetariaWT_ME034 
    ## Warning in rm(prior.distns, post.distns, trait.mcmc) :
    ##   object 'prior.distns' not found
    ## Warning in rm(prior.distns, post.distns, trait.mcmc) :
    ##   object 'post.distns' not found
    ## Warning in rm(prior.distns, post.distns, trait.mcmc) :
    ##   object 'trait.mcmc' not found
    ## 2020-07-01 21:44:17 INFO   [PEcAn.uncertainty::get.parameter.samples] : 
    ##    PFT SetariaWT_ME034 has MCMC samples for: stomatal_slope.BB 
    ##    leaf_respiration_rate_m2 Vcmax 
    ## 2020-07-01 21:44:17 INFO   [PEcAn.uncertainty::get.parameter.samples] : 
    ##    PFT SetariaWT_ME034 will use prior distributions for: c2n_leaf 
    ##    cuticular_cond SLA growth_respiration_coefficient 
    ##    extinction_coefficient_diffuse 
    ## 2020-07-01 21:44:17 INFO   [PEcAn.uncertainty::get.parameter.samples] : 
    ##    using 5004 samples per trait 
    ## 2020-07-01 21:44:17 INFO   [PEcAn.uncertainty::get.parameter.samples] : 
    ##    Selected Quantiles: 
    ##    '0.001','0.023','0.159','0.5','0.841','0.977','0.999' 
    ## 2020-07-01 21:44:17 INFO   [get.ensemble.samples] : 
    ##    Using uniform random sampling 
    ## Loading required package: PEcAn.BIOCRO
    ## 2020-07-01 21:44:18 INFO   [PEcAn.workflow::run.write.configs] : 
    ##    ----- Writing model run config files ---- 
    ## Read 34 items
    ## 2020-07-01 21:44:18 WARN   [write.config.BIOCRO] : 
    ##    the following traits parameters are not added to config file: 
    ##    'type','canopyControl','iPlantControl','photoParms','phenoControl','seneControl','soilControl','phenoParms' 
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## 2020-07-01 21:44:28 INFO   [PEcAn.workflow::run.write.configs] : 
    ##    ###### Finished writing model run config files ##### 
    ## 2020-07-01 21:44:28 INFO   [PEcAn.workflow::run.write.configs] : 
    ##    config files samples in 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/run 
    ## 2020-07-01 21:44:28 INFO   [PEcAn.workflow::run.write.configs] : 
    ##    parameter values for runs in 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/samples.RData 
    ## 2020-07-01 21:44:28 INFO   [start.model.runs] : 
    ##    ------------------------------------------------------------------- 
    ## 2020-07-01 21:44:28 INFO   [start.model.runs] : 
    ##    Starting model runs BIOCRO 
    ## 2020-07-01 21:44:28 INFO   [start.model.runs] : 
    ##    ------------------------------------------------------------------- 
    ## 
      |                                                                            
      |                                                                      |   0%2020-07-01 21:44:28 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:44:30 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=                                                                     |   2%2020-07-01 21:44:30 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:44:33 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==                                                                    |   3%2020-07-01 21:44:33 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:44:35 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |====                                                                  |   5%2020-07-01 21:44:35 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:44:38 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=====                                                                 |   7%2020-07-01 21:44:38 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:44:40 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |======                                                                |   8%2020-07-01 21:44:40 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:44:42 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=======                                                               |  10%2020-07-01 21:44:42 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:44:44 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |========                                                              |  12%2020-07-01 21:44:44 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:44:47 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=========                                                             |  14%2020-07-01 21:44:47 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:44:49 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===========                                                           |  15%2020-07-01 21:44:49 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:44:52 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |============                                                          |  17%2020-07-01 21:44:52 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:44:54 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=============                                                         |  19%2020-07-01 21:44:54 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:44:57 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==============                                                        |  20%2020-07-01 21:44:57 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:44:59 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===============                                                       |  22%2020-07-01 21:44:59 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:01 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=================                                                     |  24%2020-07-01 21:45:01 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:04 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==================                                                    |  25%2020-07-01 21:45:04 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:06 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===================                                                   |  27%2020-07-01 21:45:06 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:09 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |====================                                                  |  29%2020-07-01 21:45:09 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:11 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=====================                                                 |  31%2020-07-01 21:45:11 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:13 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=======================                                               |  32%2020-07-01 21:45:13 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:15 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |========================                                              |  34%2020-07-01 21:45:15 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:17 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=========================                                             |  36%2020-07-01 21:45:17 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:20 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==========================                                            |  37%2020-07-01 21:45:20 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:22 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===========================                                           |  39%2020-07-01 21:45:22 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:24 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |============================                                          |  41%2020-07-01 21:45:24 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:26 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==============================                                        |  42%2020-07-01 21:45:26 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:29 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===============================                                       |  44%2020-07-01 21:45:29 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:31 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |================================                                      |  46%2020-07-01 21:45:31 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:34 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=================================                                     |  47%2020-07-01 21:45:34 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:36 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==================================                                    |  49%2020-07-01 21:45:36 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:38 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |====================================                                  |  51%2020-07-01 21:45:38 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:40 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=====================================                                 |  53%2020-07-01 21:45:40 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:43 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |======================================                                |  54%2020-07-01 21:45:43 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:46 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=======================================                               |  56%2020-07-01 21:45:46 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:48 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |========================================                              |  58%2020-07-01 21:45:48 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:51 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==========================================                            |  59%2020-07-01 21:45:51 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:53 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===========================================                           |  61%2020-07-01 21:45:53 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:55 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |============================================                          |  63%2020-07-01 21:45:55 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:45:58 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=============================================                         |  64%2020-07-01 21:45:58 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:00 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==============================================                        |  66%2020-07-01 21:46:00 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:02 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===============================================                       |  68%2020-07-01 21:46:02 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:05 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=================================================                     |  69%2020-07-01 21:46:05 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:07 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==================================================                    |  71%2020-07-01 21:46:07 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:10 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===================================================                   |  73%2020-07-01 21:46:10 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:12 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |====================================================                  |  75%2020-07-01 21:46:12 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:14 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=====================================================                 |  76%2020-07-01 21:46:14 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:17 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=======================================================               |  78%2020-07-01 21:46:17 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:19 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |========================================================              |  80%2020-07-01 21:46:19 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:21 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=========================================================             |  81%2020-07-01 21:46:21 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:23 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==========================================================            |  83%2020-07-01 21:46:23 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:25 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===========================================================           |  85%2020-07-01 21:46:25 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:27 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=============================================================         |  86%2020-07-01 21:46:27 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:29 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==============================================================        |  88%2020-07-01 21:46:29 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:32 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===============================================================       |  90%2020-07-01 21:46:32 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:34 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |================================================================      |  92%2020-07-01 21:46:34 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:37 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=================================================================     |  93%2020-07-01 21:46:37 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:39 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==================================================================    |  95%2020-07-01 21:46:39 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:42 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |====================================================================  |  97%2020-07-01 21:46:42 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:44 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===================================================================== |  98%2020-07-01 21:46:44 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:46:47 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |======================================================================| 100%
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-Vcmax-0.001/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-Vcmax-0.023/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-Vcmax-0.159/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-median/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-Vcmax-0.841/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-Vcmax-0.977/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-Vcmax-0.999/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait Vcmax 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-c2n_leaf-0.001/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-c2n_leaf-0.023/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-c2n_leaf-0.159/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-median/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-c2n_leaf-0.841/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-c2n_leaf-0.977/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-c2n_leaf-0.999/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait c2n_leaf 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-cuticular_cond-0.001/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-cuticular_cond-0.023/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-cuticular_cond-0.159/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-median/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-cuticular_cond-0.841/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-cuticular_cond-0.977/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-cuticular_cond-0.999/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait cuticular_cond 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-SLA-0.001/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-SLA-0.023/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-SLA-0.159/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-median/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-SLA-0.841/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.284  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-SLA-0.977/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.292  0.282 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-SLA-0.999/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.299  0.282 
    ## 2020-07-01 21:46:47 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait SLA 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.001/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.023/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.159/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-median/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.841/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.977/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.999/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait leaf_respiration_rate_m2 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.001/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.023/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.159/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-median/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.841/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.977/2019.nc 
    ## 2020-07-01 21:46:47 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:46:47 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.999/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:46:48 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait stomatal_slope.BB 
    ## 2020-07-01 21:46:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.001/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.023/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.159/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-median/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.841/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.977/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.999/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait 
    ##    growth_respiration_coefficient 
    ## 2020-07-01 21:46:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.001/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.023/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.159/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-median/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.841/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.977/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.999/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait 
    ##    extinction_coefficient_diffuse 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00001-9000000004 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00001-9000000004/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00002-9000000004 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00002-9000000004/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.283  0.281 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00003-9000000004 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00003-9000000004/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00004-9000000004 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00004-9000000004/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00005-9000000004 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00005-9000000004/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00006-9000000004 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00006-9000000004/2019.nc 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00007-9000000004 
    ## 2020-07-01 21:46:48 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00007-9000000004/2019.nc 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00008-9000000004 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00008-9000000004/2019.nc 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00009-9000000004 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00009-9000000004/2019.nc 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.283  0.281 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00010-9000000004 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00010-9000000004/2019.nc 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.283  0.281 
    ## [1] "----- Variable: TotLivBiom"
    ## [1] "----- Running ensemble analysis for site:  Donald Danforth Plant Science Center Growth Chamber"
    ## [1] "----- Done!"
    ## [1] " "
    ## [1] "-----------------------------------------------"
    ## [1] " "
    ## [1] " "
    ## [1] "------ Generating ensemble time-series plot ------"
    ## [1] "----- Variable: TotLivBiom"
    ## [1] "----- Reading ensemble output ------"
    ## [1] "ENS-00001-9000000004"
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00001-9000000004/2019.nc 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "ENS-00002-9000000004"
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00002-9000000004/2019.nc 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.283  0.281 
    ## [1] "ENS-00003-9000000004"
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00003-9000000004/2019.nc 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "ENS-00004-9000000004"
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00004-9000000004/2019.nc 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "ENS-00005-9000000004"
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00005-9000000004/2019.nc 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "ENS-00006-9000000004"
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00006-9000000004/2019.nc 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "ENS-00007-9000000004"
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00007-9000000004/2019.nc 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## [1] "ENS-00008-9000000004"
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00008-9000000004/2019.nc 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "ENS-00009-9000000004"
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00009-9000000004/2019.nc 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.283  0.281 
    ## [1] "ENS-00010-9000000004"
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results2/out/ENS-00010-9000000004/2019.nc 
    ## 2020-07-01 21:46:49 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.283  0.281 
    ## $coef.vars
    ##                          Vcmax                       c2n_leaf 
    ##                    0.005034695                    0.541831005 
    ##                 cuticular_cond                            SLA 
    ##                    1.672766727                    0.530439890 
    ##       leaf_respiration_rate_m2              stomatal_slope.BB 
    ##                    0.063580752                    0.168593693 
    ## growth_respiration_coefficient extinction_coefficient_diffuse 
    ##                    0.155857291                    0.474918204 
    ## 
    ## $elasticities
    ##                          Vcmax                       c2n_leaf 
    ##                   4.142519e-03                   0.000000e+00 
    ##                 cuticular_cond                            SLA 
    ##                   2.164415e-04                   1.038216e-02 
    ##       leaf_respiration_rate_m2              stomatal_slope.BB 
    ##                  -1.474361e-03                   3.994896e-03 
    ## growth_respiration_coefficient extinction_coefficient_diffuse 
    ##                   0.000000e+00                  -1.313108e-06 
    ## 
    ## $sensitivities
    ##                          Vcmax                       c2n_leaf 
    ##                   6.028695e-05                   0.000000e+00 
    ##                 cuticular_cond                            SLA 
    ##                   1.391394e-08                   1.822058e-04 
    ##       leaf_respiration_rate_m2              stomatal_slope.BB 
    ##                  -2.835437e-04                   2.662242e-04 
    ## growth_respiration_coefficient extinction_coefficient_diffuse 
    ##                   0.000000e+00                  -7.926132e-07 
    ## 
    ## $variances
    ##                          Vcmax                       c2n_leaf 
    ##                   3.443983e-11                   2.519146e-34 
    ##                 cuticular_cond                            SLA 
    ##                   5.968929e-09                   7.943111e-06 
    ##       leaf_respiration_rate_m2              stomatal_slope.BB 
    ##                   6.958396e-10                   3.757768e-08 
    ## growth_respiration_coefficient extinction_coefficient_diffuse 
    ##                   2.383641e-34                   3.079798e-14 
    ## 
    ## $partial.variances
    ##                          Vcmax                       c2n_leaf 
    ##                   4.311776e-06                   3.153904e-29 
    ##                 cuticular_cond                            SLA 
    ##                   7.472943e-04                   9.944566e-01 
    ##       leaf_respiration_rate_m2              stomatal_slope.BB 
    ##                   8.711729e-05                   4.704627e-03 
    ## growth_respiration_coefficient extinction_coefficient_diffuse 
    ##                   2.984256e-29                   3.855827e-09 
    ## 
    ##            Vcmax  c2n_leaf cuticular_cond       SLA leaf_respiration_rate_m2
    ## 0.135  0.2813519 0.2813692      0.2813032 0.2805947                0.2814542
    ## 2.275  0.2813576 0.2813692      0.2813108 0.2806232                0.2814234
    ## 15.866 0.2813631 0.2813692      0.2813302 0.2807551                0.2813958
    ## 50     0.2813692 0.2813692      0.2813692 0.2813692                0.2813692
    ## 84.134 0.2813750 0.2813692      0.2814538 0.2841228                0.2813436
    ## 97.725 0.2813808 0.2813692      0.2816091 0.2916828                0.2813176
    ## 99.865 0.2813871 0.2813692      0.2818038 0.2989981                0.2812884
    ##        stomatal_slope.BB growth_respiration_coefficient
    ## 0.135          0.2806117                      0.2813692
    ## 2.275          0.2808869                      0.2813692
    ## 15.866         0.2811684                      0.2813692
    ## 50             0.2813692                      0.2813692
    ## 84.134         0.2815393                      0.2813692
    ## 97.725         0.2816693                      0.2813692
    ## 99.865         0.2817595                      0.2813692
    ##        extinction_coefficient_diffuse
    ## 0.135                       0.2813695
    ## 2.275                       0.2813695
    ## 15.866                      0.2813694
    ## 50                          0.2813692
    ## 84.134                      0.2813690
    ## 97.725                      0.2813688
    ## 99.865                      0.2813685
    ## TableGrob (4 x 2) "arrange": 8 grobs
    ##                                z     cells    name           grob
    ## Vcmax                          1 (1-1,1-1) arrange gtable[layout]
    ## c2n_leaf                       2 (1-1,2-2) arrange gtable[layout]
    ## cuticular_cond                 3 (2-2,1-1) arrange gtable[layout]
    ## SLA                            4 (2-2,2-2) arrange gtable[layout]
    ## leaf_respiration_rate_m2       5 (3-3,1-1) arrange gtable[layout]
    ## stomatal_slope.BB              6 (3-3,2-2) arrange gtable[layout]
    ## growth_respiration_coefficient 7 (4-4,1-1) arrange gtable[layout]
    ## extinction_coefficient_diffuse 8 (4-4,2-2) arrange gtable[layout]
    ## $Vcmax
    ## 
    ## $c2n_leaf
    ## 
    ## $cuticular_cond
    ## 
    ## $SLA
    ## 
    ## $leaf_respiration_rate_m2
    ## 
    ## $stomatal_slope.BB
    ## 
    ## $growth_respiration_coefficient
    ## 
    ## $extinction_coefficient_diffuse
    ## 
    ## 2020-07-01 21:46:57 INFO   [db.print.connections] : 
    ##    Created 9 connections and executed 92 queries 
    ## 2020-07-01 21:46:57 INFO   [db.print.connections] : 
    ##    Created 9 connections and executed 92 queries 
    ## 2020-07-01 21:46:57 DEBUG  [db.print.connections] : 
    ##    No open database connections. 
    ## [1] "---------- PEcAn Workflow Complete ----------"

``` r
file.copy("temp_exps_results2/", "temp_exps_results/", recursive = TRUE)
```

    ## [1] TRUE

``` r
unlink("temp_exps_results2/", recursive = TRUE)
file.copy("~/temp_exps_results2/dbfiles/", "temp_exps_results/temp_exps_results2/", recursive = TRUE)
```

    ## [1] TRUE

``` r
unlink("~/temp_exps_results2/", recursive = TRUE)
```

Plot biomass results. This pulls in and cleans up the biomass data estimated from BioCro, then plots the data.

``` r
# Clean up biomass estimates
load('temp_exps_results/temp_exps_results2/out/SA-median/biocro_output.RData')
timescale <- data.table(day = rep(biocro_result$doy, each = 24), hour = 0:23)
rm(biocro_result)

load("temp_exps_results/temp_exps_results2/ensemble.ts.NOENSEMBLEID.TotLivBiom.2019.2019.Rdata")
daily_biomass <- data.frame(timescale, t(ensemble.ts[["TotLivBiom"]])) %>% 
  gather(ensemble, biomass, X1:X10) %>% 
  group_by(day, hour) %>% 
  summarise(mean = mean(biomass, na.rm = TRUE), 
            median = median(biomass, na.rm = TRUE), 
            sd = sd(biomass, na.rm = TRUE), 
            lcl = quantile(biomass, probs = c(0.025), na.rm = TRUE), 
            ucl = quantile(biomass, probs = c(0.975), na.rm = TRUE)) %>% 
  group_by(day) %>% 
  summarise(mean = sum(mean), 
            median = sum(median), 
            sd = sqrt(sum(sd^2)), 
            lcl = sum(lcl), 
            ucl = sum(ucl))
write.csv(daily_biomass, "temp_exps_inputs2/biomass_ests2.csv")
rm(ensemble.ts)

# Plot measured biomass against biomass estimates
sd_scale <- 5
ggplot(data = daily_biomass) + 
  geom_line(aes(day, y = mean)) +
  geom_ribbon(aes(day, ymin = mean - sd_scale * sd, ymax = mean + sd_scale * sd), alpha = 0.1) +
  geom_ribbon(aes(day, ymin = lcl, ymax = ucl), alpha = 0.1) +
  xlab("Day of Year") + 
  ylab("Total Biomass Mg/ha") +
  theme_classic()
```

Section 3: BioCro Run for High Night Temperature Parameters & Weather
=====================================================================

Similar to section 1, you will use the following files in the `temp_exps_inputs3` folder for this run: `temp.exps3.xml`, `workflow.R`, `setaria.constants.xml`.

Generate high night temp weather data file `danforth-highnight-chamber.2019.csv` with the R script `generate_highnight_weather.R` as shown below.

``` r
source("temp_exps_inputs3/generate_highnight_weather.R")
```

Then run the model for the high night temperature treatment.

``` bash
temp_exps_inputs3/workflow.R --settings temp_exps_inputs3/temp.exps3.xml
```

    ## Loading required package: PEcAn.DB
    ## Loading required package: PEcAn.settings
    ## Loading required package: PEcAn.MA
    ## Loading required package: XML
    ## Loading required package: lattice
    ## Loading required package: MASS
    ## Loading required package: PEcAn.utils
    ## 
    ## Attaching package: ‘PEcAn.utils’
    ## 
    ## The following object is masked from ‘package:utils’:
    ## 
    ##     download.file
    ## 
    ## Loading required package: PEcAn.logger
    ## 
    ## Attaching package: ‘PEcAn.logger’
    ## 
    ## The following objects are masked from ‘package:PEcAn.utils’:
    ## 
    ##     logger.debug, logger.error, logger.getLevel, logger.info,
    ##     logger.setLevel, logger.setOutputFile, logger.setQuitOnSevere,
    ##     logger.setWidth, logger.severe, logger.warn
    ## 
    ## Loading required package: PEcAn.uncertainty
    ## Loading required package: PEcAn.priors
    ## Loading required package: ggplot2
    ## Loading required package: ggmap
    ## Loading required package: gridExtra
    ## 
    ## Attaching package: ‘PEcAn.uncertainty’
    ## 
    ## The following objects are masked from ‘package:PEcAn.utils’:
    ## 
    ##     get.ensemble.samples, read.ensemble.output, write.ensemble.configs
    ## 
    ## Loading required package: PEcAn.data.atmosphere
    ## Loading required package: PEcAn.data.land
    ## Loading required package: datapack
    ## Loading required package: dataone
    ## Loading required package: redland
    ## Loading required package: sirt
    ## - sirt 3.1-80 (2019-01-04 12:08:59)
    ## Loading required package: sf
    ## Linking to GEOS 3.5.1, GDAL 2.1.2, PROJ 4.9.3
    ## Loading required package: PEcAn.data.remote
    ## Loading required package: PEcAn.assim.batch
    ## Loading required package: PEcAn.emulator
    ## Loading required package: mvtnorm
    ## Loading required package: mlegp
    ## Loading required package: MCMCpack
    ## Loading required package: coda
    ## ##
    ## ## Markov Chain Monte Carlo Package (MCMCpack)
    ## ## Copyright (C) 2003-2020 Andrew D. Martin, Kevin M. Quinn, and Jong Hee Park
    ## ##
    ## ## Support provided by the U.S. National Science Foundation
    ## ## (Grants SES-0350646 and SES-0350613)
    ## ##
    ## Loading required package: PEcAn.benchmark
    ## Loading required package: PEcAn.remote
    ## Loading required package: PEcAn.workflow
    ## 
    ## Attaching package: ‘PEcAn.workflow’
    ## 
    ## The following objects are masked from ‘package:PEcAn.utils’:
    ## 
    ##     do_conversions, run.write.configs, runModule.run.write.configs
    ## 
    ## Loading required package: bitops
    ## 2020-07-01 21:47:02 INFO   [PEcAn.settings::read.settings] : 
    ##    Loading --settings= temp_exps_inputs3/temp.exps3.xml 
    ## 2020-07-01 21:47:02 INFO   [fix.deprecated.settings] : 
    ##    Fixing deprecated settings... 
    ## 2020-07-01 21:47:02 INFO   [fix.deprecated.settings] : 
    ##    settings$run$host is deprecated. uwe settings$host instead 
    ## 2020-07-01 21:47:02 INFO   [update.settings] : 
    ##    Fixing deprecated settings... 
    ## 2020-07-01 21:47:02 INFO   [check.settings] : Checking settings... 
    ## 2020-07-01 21:47:02 INFO   [check.database] : 
    ##    Successfully connected to database : PostgreSQL bety bety postgres bety 
    ##    FALSE 
    ## 2020-07-01 21:47:02 WARN   [check.database.settings] : 
    ##    Will not write runs/configurations to database. 
    ## 2020-07-01 21:47:02 WARN   [check.bety.version] : 
    ##    Last migration 20181129000515 is more recent than expected 
    ##    20141009160121. This could result in PEcAn not working as expected. 
    ## 2020-07-01 21:47:03 INFO   [check.ensemble.settings] : 
    ##    No start date passed to ensemble - using the run date ( 2019 ). 
    ## 2020-07-01 21:47:03 INFO   [check.ensemble.settings] : 
    ##    No end date passed to ensemble - using the run date ( 2019 ). 
    ## 2020-07-01 21:47:03 INFO   [check.ensemble.settings] : 
    ##    We are updating the ensemble tag inside the xml file. 
    ## 2020-07-01 21:47:03 INFO   [fn] : 
    ##    No start date passed to sensitivity.analysis - using the run date ( 2019 
    ##    ). 
    ## 2020-07-01 21:47:03 INFO   [fn] : 
    ##    No end date passed to sensitivity.analysis - using the run date ( 2019 
    ##    ). 
    ## 2020-07-01 21:47:03 INFO   [fn] : 
    ##    Setting site name to Donald Danforth Plant Science Center Growth Chamber 
    ## 2020-07-01 21:47:03 INFO   [fn] : 
    ##    Setting site lat to 38.674593 
    ## 2020-07-01 21:47:03 INFO   [fn] : 
    ##    Setting site lon to -90.397189 
    ## 2020-07-01 21:47:03 INFO   [check.model.settings] : 
    ##    Setting model id to 9000000002 
    ## 2020-07-01 21:47:03 INFO   [check.model.settings] : 
    ##    Option to delete raw model output not set or not logical. Will keep all 
    ##    model output. 
    ## 2020-07-01 21:47:03 WARN   [PEcAn.DB::dbfile.file] : 
    ##    no files found for 9000000002 in database 
    ## 2020-07-01 21:47:03 WARN   [check.settings] : 
    ##    settings$database$dbfiles pathname temp_exps_results3/dbfiles is invalid 
    ##   
    ##    placing it in the home directory /home/kristinariemer 
    ## 2020-07-01 21:47:03 INFO   [fn] : 
    ##    Missing optional input : soil 
    ## 2020-07-01 21:47:03 WARN   [PEcAn.DB::dbfile.id] : 
    ##    no id found for 
    ##    ~/model-vignettes/BioCro/DARPA/temp_exps_inputs3/danforth-highnight-chamber 
    ##    in database 
    ## 2020-07-01 21:47:03 INFO   [fn] : 
    ##    path 
    ##    ~/model-vignettes/BioCro/DARPA/temp_exps_inputs3/danforth-highnight-chamber 
    ## 2020-07-01 21:47:03 INFO   [fn] : 
    ##    path 
    ##    ~/model-vignettes/BioCro/DARPA/temp_exps_inputs3/danforth-highnight-chamber 
    ## 2020-07-01 21:47:03 INFO   [check.workflow.settings] : 
    ##    output folder = 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3 
    ## 2020-07-01 21:47:03 INFO   [check.settings] : 
    ##    Storing pft SetariaWT_ME034 in 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/pft/SetariaWT_ME034 
    ## [1] "/home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/pecan.CHECKED.xml"
    ## 2020-07-01 21:47:03 DEBUG  [PEcAn.workflow::do_conversions] : 
    ##    do.conversion outdir /home/kristinariemer/temp_exps_results3/dbfiles 
    ## 2020-07-01 21:47:03 INFO   [PEcAn.workflow::do_conversions] : PROCESSING:  met 
    ## 2020-07-01 21:47:03 INFO   [PEcAn.workflow::do_conversions] : 
    ##    calling met.process: 
    ##    ~/model-vignettes/BioCro/DARPA/temp_exps_inputs3/danforth-highnight-chamber 
    ## 2020-07-01 21:47:03 WARN   [PEcAn.data.atmosphere::met.process] : 
    ##    met.process only has a path provided, assuming path is model driver and 
    ##    skipping processing 
    ## 2020-07-01 21:47:03 DEBUG  [PEcAn.workflow::do_conversions] : 
    ##    updated met path: 
    ##    ~/model-vignettes/BioCro/DARPA/temp_exps_inputs3/danforth-highnight-chamber 
    ## 2020-07-01 21:47:03 DEBUG  [PEcAn.DB::get.trait.data] : 
    ##    `trait.names` is NULL, so retrieving all traits that have at least one 
    ##    prior for these PFTs. 
    ## 2020-07-01 21:47:05 DEBUG  [FUN] : 
    ##    All posterior files are present. Performing additional checks to 
    ##    determine if meta-analysis needs to be updated. 
    ## 2020-07-01 21:47:05 WARN   [FUN] : 
    ##    The following files are in database but not found on disk: 
    ##    'trait.data.Rdata', 'prior.distns.Rdata', 'cultivars.csv' .  Re-running 
    ##    meta-analysis. 
    ## 2020-07-01 21:47:06 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:47:06 INFO   [query.trait.data] : stomatal_slope.BB 
    ## 2020-07-01 21:47:06 INFO   [query.trait.data] : 
    ##    Median stomatal_slope.BB : 4.19 
    ## 2020-07-01 21:47:06 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:47:06 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:47:06 INFO   [query.trait.data] : 
    ##    leaf_respiration_rate_m2 
    ## 2020-07-01 21:47:06 INFO   [query.trait.data] : 
    ##    Median leaf_respiration_rate_m2 : 1.2 
    ## 2020-07-01 21:47:06 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:47:06 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:47:06 INFO   [query.trait.data] : Vcmax 
    ## 2020-07-01 21:47:06 INFO   [query.trait.data] : Median Vcmax : 18.9 
    ## 2020-07-01 21:47:06 INFO   [query.trait.data] : 
    ##    --------------------------------------------------------- 
    ## 2020-07-01 21:47:06 INFO   [FUN] : 
    ##  Number of observations per trait for PFT  'SetariaWT_ME034' :
    ##  # A tibble: 3 x 2
    ##   trait                       nn
    ##   <chr>                    <int>
    ## 1 leaf_respiration_rate_m2    15
    ## 2 stomatal_slope.BB            5
    ## 3 Vcmax                       15 
    ## 2020-07-01 21:47:06 INFO   [FUN] : 
    ##  Summary of prior distributions for PFT  'SetariaWT_ME034' :
    ##                                   distn parama paramb   n
    ## Vcmax                            lnorm  3.750   0.30  12
    ## c2n_leaf                         gamma  4.180   0.13  95
    ## cuticular_cond                   lnorm  8.400   0.90   0
    ## SLA                            weibull  2.060  19.00 125
    ## leaf_respiration_rate_m2         lnorm  0.632   0.65  32
    ## stomatal_slope.BB                lnorm  1.240   0.28   2
    ## growth_respiration_coefficient    beta 26.000  48.00  NA
    ## extinction_coefficient_diffuse   gamma  5.000  10.00  NA 
    ## 2020-07-01 21:47:06 DEBUG  [FUN] : The following posterior files found in PFT outdir  ( '/home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/pft/SetariaWT_ME034' ) will be registered in BETY  under posterior ID  9000000391 :  'cultivars.csv', 'prior.distns.csv', 'prior.distns.Rdata', 'trait.data.csv', 'trait.data.Rdata' .  The following files (if any) will not be registered because they already existed:   
    ## 
    ## Attaching package: ‘dplyr’
    ## 
    ## The following object is masked from ‘package:gridExtra’:
    ## 
    ##     combine
    ## 
    ## The following object is masked from ‘package:MASS’:
    ## 
    ##     select
    ## 
    ## The following objects are masked from ‘package:stats’:
    ## 
    ##     filter, lag
    ## 
    ## The following objects are masked from ‘package:base’:
    ## 
    ##     intersect, setdiff, setequal, union
    ## 
    ## [1] "/home/kristinariemer/model-vignettes/BioCro/DARPA"
    ## [1] TRUE
    ## 2020-07-01 21:47:07 INFO   [FUN] : 
    ##    ------------------------------------------------------------------- 
    ## 2020-07-01 21:47:07 INFO   [FUN] : 
    ##    Running meta.analysis for PFT: SetariaWT_ME034 
    ## 2020-07-01 21:47:07 INFO   [FUN] : 
    ##    ------------------------------------------------------------------- 
    ## 2020-07-01 21:47:07 INFO   [check_consistent] : 
    ##    OK!  stomatal_slope.BB data and prior are consistent: 
    ## 2020-07-01 21:47:07 INFO   [check_consistent] : 
    ##    stomatal_slope.BB P[X<x] = 0.754341900665641 
    ## 2020-07-01 21:47:07 INFO   [check_consistent] : 
    ##    OK!  leaf_respiration_rate_m2 data and prior are consistent: 
    ## 2020-07-01 21:47:07 INFO   [check_consistent] : 
    ##    leaf_respiration_rate_m2 P[X<x] = 0.244527389092738 
    ## 2020-07-01 21:47:07 WARN   [check_consistent] : 
    ##    CHECK THIS: Vcmax data and prior are inconsistent: 
    ## 2020-07-01 21:47:07 INFO   [check_consistent] : 
    ##    Vcmax P[X<x] = 0.00158979470946304 
    ## Each meta-analysis will be run with: 
    ## 3000 total iterations,
    ## 4 chains, 
    ## a burnin of 1500 samples,
    ## , 
    ## thus the total number of samples will be 6000
    ## ################################################
    ## ------------------------------------------------
    ## starting meta-analysis for:
    ## 
    ##  stomatal_slope.BB 
    ## 
    ## ------------------------------------------------
    ## prior for stomatal_slope.BB
    ##                      (using R parameterization):
    ## lnorm(1.24, 0.28)
    ## data max: 5.75 
    ## data min: 1.67 
    ## mean: 4 
    ## n: 5
    ## stem plot of data points
    ## 
    ##   The decimal point is at the |
    ## 
    ##   1 | 7
    ##   2 | 
    ##   3 | 5
    ##   4 | 29
    ##   5 | 8
    ## 
    ## stem plot of obs.prec:
    ## 
    ##   The decimal point is at the |
    ## 
    ##   0 | 0001
    ##   0 | 
    ##   1 | 
    ##   1 | 6
    ## 
    ## Read 28 items
    ## Compiling model graph
    ##    Resolving undeclared variables
    ##    Allocating nodes
    ## Graph information:
    ##    Observed stochastic nodes: 10
    ##    Unobserved stochastic nodes: 4
    ##    Total graph size: 56
    ## 
    ## Initializing model
    ## 
    ## 
    ## Iterations = 1002:4000
    ## Thinning interval = 2 
    ## Number of chains = 4 
    ## Sample size per chain = 1500 
    ## 
    ## 1. Empirical mean and standard deviation for each variable,
    ##    plus standard error of the mean:
    ## 
    ##                Mean      SD Naive SE Time-series SE
    ## beta.o       4.2575  0.7083 0.009144       0.016130
    ## beta.trt[2] -0.7898  0.9394 0.012128       0.022025
    ## sd.trt       6.2374 69.3061 0.894738       0.899941
    ## sd.y         1.7168  0.3123 0.004032       0.005259
    ## 
    ## 2. Quantiles for each variable:
    ## 
    ##                2.5%     25%     50%      75%  97.5%
    ## beta.o       2.9549  3.7675  4.2170  4.70454  5.737
    ## beta.trt[2] -2.9744 -1.4173 -0.5671 -0.06495  0.583
    ## sd.trt       0.1049  0.3996  1.0765  2.78585 28.473
    ## sd.y         1.1406  1.4999  1.7040  1.91847  2.360
    ## 
    ## ################################################
    ## ------------------------------------------------
    ## starting meta-analysis for:
    ## 
    ##  leaf_respiration_rate_m2 
    ## 
    ## ------------------------------------------------
    ## prior for leaf_respiration_rate_m2
    ##                      (using R parameterization):
    ## lnorm(0.632, 0.65)
    ## data max: 2.17 
    ## data min: 0.746 
    ## mean: 1.28 
    ## n: 15
    ## stem plot of data points
    ## 
    ##   The decimal point is at the |
    ## 
    ##   0 | 789
    ##   1 | 00112334
    ##   1 | 579
    ##   2 | 2
    ## 
    ## stem plot of obs.prec:
    ## 
    ##   The decimal point is 2 digit(s) to the right of the |
    ## 
    ##   0 | 1444
    ##   0 | 556899
    ##   1 | 133
    ##   1 | 66
    ## 
    ## Read 28 items
    ## Compiling model graph
    ##    Resolving undeclared variables
    ##    Allocating nodes
    ## Graph information:
    ##    Observed stochastic nodes: 30
    ##    Unobserved stochastic nodes: 4
    ##    Total graph size: 116
    ## 
    ## Initializing model
    ## 
    ## 
    ## Iterations = 1002:4000
    ## Thinning interval = 2 
    ## Number of chains = 4 
    ## Sample size per chain = 1500 
    ## 
    ## 1. Empirical mean and standard deviation for each variable,
    ##    plus standard error of the mean:
    ## 
    ##                Mean       SD Naive SE Time-series SE
    ## beta.o       1.4624  0.09300 0.001201       0.001681
    ## beta.trt[2] -0.4597  0.15050 0.001943       0.002725
    ## sd.trt       3.0194 36.94027 0.476897       0.476940
    ## sd.y         0.3754  0.03571 0.000461       0.000503
    ## 
    ## 2. Quantiles for each variable:
    ## 
    ##                2.5%     25%     50%     75%   97.5%
    ## beta.o       1.2780  1.4025  1.4635  1.5233  1.6447
    ## beta.trt[2] -0.7468 -0.5609 -0.4648 -0.3625 -0.1539
    ## sd.trt       0.1421  0.3784  0.6627  1.4167 13.5363
    ## sd.y         0.3083  0.3507  0.3743  0.3989  0.4498
    ## 
    ## ################################################
    ## ------------------------------------------------
    ## starting meta-analysis for:
    ## 
    ##  Vcmax 
    ## 
    ## ------------------------------------------------
    ## prior for Vcmax
    ##                      (using R parameterization):
    ## lnorm(3.75, 0.3)
    ## data max: 22.5 
    ## data min: 14.4 
    ## mean: 18.4 
    ## n: 12
    ## stem plot of data points
    ## 
    ##   The decimal point is at the |
    ## 
    ##   14 | 489
    ##   16 | 0338
    ##   18 | 9
    ##   20 | 059
    ##   22 | 5
    ## 
    ## stem plot of obs.prec:
    ## 
    ##   The decimal point is 6 digit(s) to the right of the |
    ## 
    ##   0 | 00111122336
    ##   1 | 
    ##   2 | 
    ##   3 | 0
    ## 
    ## Read 28 items
    ## Compiling model graph
    ##    Resolving undeclared variables
    ##    Allocating nodes
    ## Graph information:
    ##    Observed stochastic nodes: 24
    ##    Unobserved stochastic nodes: 4
    ##    Total graph size: 98
    ## 
    ## Initializing model
    ## 
    ## 
    ## Iterations = 1002:4000
    ## Thinning interval = 2 
    ## Number of chains = 4 
    ## Sample size per chain = 1500 
    ## 
    ## 1. Empirical mean and standard deviation for each variable,
    ##    plus standard error of the mean:
    ## 
    ##                Mean        SD  Naive SE Time-series SE
    ## beta.o      19.3324 9.748e-02 0.0012584      1.844e-03
    ## beta.trt[2] -1.9420 1.350e-01 0.0017432      2.449e-03
    ## sd.trt      13.8876 1.940e+02 2.5045667      2.505e+00
    ## sd.y         0.3369 4.663e-03 0.0000602      6.229e-05
    ## 
    ## 2. Quantiles for each variable:
    ## 
    ##                2.5%     25%     50%    75%   97.5%
    ## beta.o      19.1454 19.2647 19.3333 19.398 19.5224
    ## beta.trt[2] -2.2073 -2.0335 -1.9420 -1.851 -1.6737
    ## sd.trt       0.8471  1.6921  2.9068  6.216 53.3386
    ## sd.y         0.3278  0.3337  0.3369  0.340  0.3462
    ## 
    ## 2020-07-01 21:47:09 INFO   [check_consistent] : 
    ##    OK!  stomatal_slope.BB data and prior are consistent: 
    ## 2020-07-01 21:47:09 INFO   [check_consistent] : 
    ##    stomatal_slope.BB P[X<x] = 0.762857356899334 
    ## 2020-07-01 21:47:09 INFO   [check_consistent] : 
    ##    OK!  leaf_respiration_rate_m2 data and prior are consistent: 
    ## 2020-07-01 21:47:09 INFO   [check_consistent] : 
    ##    leaf_respiration_rate_m2 P[X<x] = 0.349421657734449 
    ## 2020-07-01 21:47:09 WARN   [check_consistent] : 
    ##    CHECK THIS: Vcmax data and prior are inconsistent: 
    ## 2020-07-01 21:47:09 INFO   [check_consistent] : 
    ##    Vcmax P[X<x] = 0.00430521540116437 
    ## 2020-07-01 21:47:09 INFO   [pecan.ma.summary] : 
    ##    JAGS model converged for SetariaWT_ME034 stomatal_slope.BB GD MPSRF = 
    ##    1.003 
    ## 2020-07-01 21:47:10 INFO   [pecan.ma.summary] : 
    ##    JAGS model converged for SetariaWT_ME034 leaf_respiration_rate_m2 GD 
    ##    MPSRF = 1.002 
    ## 2020-07-01 21:47:10 INFO   [pecan.ma.summary] : 
    ##    JAGS model converged for SetariaWT_ME034 Vcmax GD MPSRF = 1.001 
    ## 2020-07-01 21:47:13 INFO   [PEcAn.uncertainty::get.parameter.samples] : 
    ##    Selected PFT(s): SetariaWT_ME034 
    ## Warning in rm(prior.distns, post.distns, trait.mcmc) :
    ##   object 'prior.distns' not found
    ## Warning in rm(prior.distns, post.distns, trait.mcmc) :
    ##   object 'post.distns' not found
    ## Warning in rm(prior.distns, post.distns, trait.mcmc) :
    ##   object 'trait.mcmc' not found
    ## 2020-07-01 21:47:13 INFO   [PEcAn.uncertainty::get.parameter.samples] : 
    ##    PFT SetariaWT_ME034 has MCMC samples for: stomatal_slope.BB 
    ##    leaf_respiration_rate_m2 Vcmax 
    ## 2020-07-01 21:47:13 INFO   [PEcAn.uncertainty::get.parameter.samples] : 
    ##    PFT SetariaWT_ME034 will use prior distributions for: c2n_leaf 
    ##    cuticular_cond SLA growth_respiration_coefficient 
    ##    extinction_coefficient_diffuse 
    ## 2020-07-01 21:47:13 INFO   [PEcAn.uncertainty::get.parameter.samples] : 
    ##    using 5004 samples per trait 
    ## 2020-07-01 21:47:13 INFO   [PEcAn.uncertainty::get.parameter.samples] : 
    ##    Selected Quantiles: 
    ##    '0.001','0.023','0.159','0.5','0.841','0.977','0.999' 
    ## 2020-07-01 21:47:14 INFO   [get.ensemble.samples] : 
    ##    Using uniform random sampling 
    ## Loading required package: PEcAn.BIOCRO
    ## 2020-07-01 21:47:14 INFO   [PEcAn.workflow::run.write.configs] : 
    ##    ----- Writing model run config files ---- 
    ## Read 34 items
    ## 2020-07-01 21:47:14 WARN   [write.config.BIOCRO] : 
    ##    the following traits parameters are not added to config file: 
    ##    'type','canopyControl','iPlantControl','photoParms','phenoControl','seneControl','soilControl','phenoParms' 
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 34 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## Read 32 items
    ## 2020-07-01 21:47:24 INFO   [PEcAn.workflow::run.write.configs] : 
    ##    ###### Finished writing model run config files ##### 
    ## 2020-07-01 21:47:24 INFO   [PEcAn.workflow::run.write.configs] : 
    ##    config files samples in 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/run 
    ## 2020-07-01 21:47:24 INFO   [PEcAn.workflow::run.write.configs] : 
    ##    parameter values for runs in 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/samples.RData 
    ## 2020-07-01 21:47:24 INFO   [start.model.runs] : 
    ##    ------------------------------------------------------------------- 
    ## 2020-07-01 21:47:24 INFO   [start.model.runs] : 
    ##    Starting model runs BIOCRO 
    ## 2020-07-01 21:47:24 INFO   [start.model.runs] : 
    ##    ------------------------------------------------------------------- 
    ## 
      |                                                                            
      |                                                                      |   0%2020-07-01 21:47:24 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:47:27 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=                                                                     |   2%2020-07-01 21:47:27 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:47:29 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==                                                                    |   3%2020-07-01 21:47:29 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:47:32 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |====                                                                  |   5%2020-07-01 21:47:32 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:47:34 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=====                                                                 |   7%2020-07-01 21:47:34 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:47:36 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |======                                                                |   8%2020-07-01 21:47:36 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:47:38 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=======                                                               |  10%2020-07-01 21:47:38 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:47:40 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |========                                                              |  12%2020-07-01 21:47:40 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:47:43 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=========                                                             |  14%2020-07-01 21:47:43 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:47:45 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===========                                                           |  15%2020-07-01 21:47:45 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:47:47 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |============                                                          |  17%2020-07-01 21:47:47 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:47:49 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=============                                                         |  19%2020-07-01 21:47:49 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:47:51 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==============                                                        |  20%2020-07-01 21:47:51 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:47:54 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===============                                                       |  22%2020-07-01 21:47:54 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:47:56 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=================                                                     |  24%2020-07-01 21:47:56 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:47:59 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==================                                                    |  25%2020-07-01 21:47:59 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:01 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===================                                                   |  27%2020-07-01 21:48:01 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:03 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |====================                                                  |  29%2020-07-01 21:48:03 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:05 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=====================                                                 |  31%2020-07-01 21:48:05 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:08 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=======================                                               |  32%2020-07-01 21:48:08 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:10 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |========================                                              |  34%2020-07-01 21:48:10 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:12 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=========================                                             |  36%2020-07-01 21:48:12 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:14 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==========================                                            |  37%2020-07-01 21:48:14 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:16 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===========================                                           |  39%2020-07-01 21:48:16 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:19 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |============================                                          |  41%2020-07-01 21:48:19 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:21 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==============================                                        |  42%2020-07-01 21:48:21 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:24 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===============================                                       |  44%2020-07-01 21:48:24 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:26 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |================================                                      |  46%2020-07-01 21:48:26 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:29 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=================================                                     |  47%2020-07-01 21:48:29 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:31 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==================================                                    |  49%2020-07-01 21:48:31 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:34 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |====================================                                  |  51%2020-07-01 21:48:34 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:36 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=====================================                                 |  53%2020-07-01 21:48:36 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:38 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |======================================                                |  54%2020-07-01 21:48:38 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:41 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=======================================                               |  56%2020-07-01 21:48:41 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:43 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |========================================                              |  58%2020-07-01 21:48:43 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:46 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==========================================                            |  59%2020-07-01 21:48:46 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:48 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===========================================                           |  61%2020-07-01 21:48:48 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:50 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |============================================                          |  63%2020-07-01 21:48:50 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:53 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=============================================                         |  64%2020-07-01 21:48:53 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:55 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==============================================                        |  66%2020-07-01 21:48:55 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:48:58 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===============================================                       |  68%2020-07-01 21:48:58 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:00 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=================================================                     |  69%2020-07-01 21:49:00 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:03 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==================================================                    |  71%2020-07-01 21:49:03 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:05 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===================================================                   |  73%2020-07-01 21:49:05 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:08 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |====================================================                  |  75%2020-07-01 21:49:08 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:10 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=====================================================                 |  76%2020-07-01 21:49:10 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:13 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=======================================================               |  78%2020-07-01 21:49:13 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:15 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |========================================================              |  80%2020-07-01 21:49:15 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:17 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=========================================================             |  81%2020-07-01 21:49:17 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:19 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==========================================================            |  83%2020-07-01 21:49:19 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:21 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===========================================================           |  85%2020-07-01 21:49:21 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:23 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=============================================================         |  86%2020-07-01 21:49:23 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:25 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==============================================================        |  88%2020-07-01 21:49:25 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:27 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===============================================================       |  90%2020-07-01 21:49:27 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:29 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |================================================================      |  92%2020-07-01 21:49:29 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:31 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |=================================================================     |  93%2020-07-01 21:49:31 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:33 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |==================================================================    |  95%2020-07-01 21:49:33 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:36 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |====================================================================  |  97%2020-07-01 21:49:36 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:38 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |===================================================================== |  98%2020-07-01 21:49:38 DEBUG  [stamp_started] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 2020-07-01 21:49:41 DEBUG  [stamp_finished] : 
    ##    Connection is null. Not actually writing timestamps to database 
    ## 
      |                                                                            
      |======================================================================| 100%
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-Vcmax-0.001/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-Vcmax-0.023/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-Vcmax-0.159/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-median/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-Vcmax-0.841/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-Vcmax-0.977/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-Vcmax-0.999/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait Vcmax 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-c2n_leaf-0.001/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-c2n_leaf-0.023/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-c2n_leaf-0.159/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-median/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-c2n_leaf-0.841/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-c2n_leaf-0.977/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-c2n_leaf-0.999/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait c2n_leaf 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-cuticular_cond-0.001/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-cuticular_cond-0.023/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-cuticular_cond-0.159/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-median/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-cuticular_cond-0.841/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-cuticular_cond-0.977/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-cuticular_cond-0.999/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait cuticular_cond 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-SLA-0.001/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-SLA-0.023/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-SLA-0.159/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-median/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-SLA-0.841/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.284  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-SLA-0.977/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.292  0.282 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-SLA-0.999/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.299  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait SLA 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.001/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.023/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.159/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-median/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.841/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.977/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-leaf_respiration_rate_m2-0.999/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait leaf_respiration_rate_m2 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.001/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.023/2019.nc 
    ## 2020-07-01 21:49:41 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:41 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.159/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-median/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.841/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.977/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-stomatal_slope.BB-0.999/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait stomatal_slope.BB 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.001/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.023/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.159/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-median/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.841/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.977/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-growth_respiration_coefficient-0.999/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait 
    ##    growth_respiration_coefficient 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.001/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.023/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.159/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-median/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.841/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.977/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/SA-SetariaWT_ME034-extinction_coefficient_diffuse-0.999/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [read.sa.output] : 
    ##    reading sensitivity analysis output for model run at 0.135 2.275 15.866 
    ##    50 84.134 97.725 99.865 quantiles of trait 
    ##    extinction_coefficient_diffuse 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00001-9000000004 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00001-9000000004/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00002-9000000004 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00002-9000000004/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.292  0.282 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00003-9000000004 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00003-9000000004/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00004-9000000004 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00004-9000000004/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00005-9000000004 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00005-9000000004/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00006-9000000004 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00006-9000000004/2019.nc 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.283  0.281 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00007-9000000004 
    ## 2020-07-01 21:49:42 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00007-9000000004/2019.nc 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00008-9000000004 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00008-9000000004/2019.nc 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.283  0.281 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00009-9000000004 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00009-9000000004/2019.nc 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.uncertainty::read.ensemble.output] : 
    ##    reading ensemble output from run id: ENS-00010-9000000004 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00010-9000000004/2019.nc 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "----- Variable: TotLivBiom"
    ## [1] "----- Running ensemble analysis for site:  Donald Danforth Plant Science Center Growth Chamber"
    ## [1] "----- Done!"
    ## [1] " "
    ## [1] "-----------------------------------------------"
    ## [1] " "
    ## [1] " "
    ## [1] "------ Generating ensemble time-series plot ------"
    ## [1] "----- Variable: TotLivBiom"
    ## [1] "----- Reading ensemble output ------"
    ## [1] "ENS-00001-9000000004"
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00001-9000000004/2019.nc 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "ENS-00002-9000000004"
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00002-9000000004/2019.nc 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.292  0.282 
    ## [1] "ENS-00003-9000000004"
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00003-9000000004/2019.nc 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "ENS-00004-9000000004"
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00004-9000000004/2019.nc 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "ENS-00005-9000000004"
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00005-9000000004/2019.nc 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## [1] "ENS-00006-9000000004"
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00006-9000000004/2019.nc 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.283  0.281 
    ## [1] "ENS-00007-9000000004"
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00007-9000000004/2019.nc 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.282  0.281 
    ## [1] "ENS-00008-9000000004"
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00008-9000000004/2019.nc 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.283  0.281 
    ## [1] "ENS-00009-9000000004"
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00009-9000000004/2019.nc 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## [1] "ENS-00010-9000000004"
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : 
    ##    Reading the following files: 
    ##    /home/kristinariemer/model-vignettes/BioCro/DARPA/temp_exps_results3/out/ENS-00010-9000000004/2019.nc 
    ## 2020-07-01 21:49:43 INFO   [PEcAn.utils::read.output] : Result summary:
    ##              Mean Median
    ## TotLivBiom 0.281  0.281 
    ## $coef.vars
    ##                          Vcmax                       c2n_leaf 
    ##                    0.005034695                    0.525921472 
    ##                 cuticular_cond                            SLA 
    ##                    1.709413611                    0.544834487 
    ##       leaf_respiration_rate_m2              stomatal_slope.BB 
    ##                    0.063580752                    0.168593693 
    ## growth_respiration_coefficient extinction_coefficient_diffuse 
    ##                    0.160078484                    0.486687914 
    ## 
    ## $elasticities
    ##                          Vcmax                       c2n_leaf 
    ##                   3.888135e-03                   0.000000e+00 
    ##                 cuticular_cond                            SLA 
    ##                   2.115654e-04                   9.829903e-03 
    ##       leaf_respiration_rate_m2              stomatal_slope.BB 
    ##                  -1.384029e-03                   3.744129e-03 
    ## growth_respiration_coefficient extinction_coefficient_diffuse 
    ##                   0.000000e+00                  -1.153145e-06 
    ## 
    ## $sensitivities
    ##                          Vcmax                       c2n_leaf 
    ##                   5.657653e-05                   0.000000e+00 
    ##                 cuticular_cond                            SLA 
    ##                   1.312905e-08                   1.760533e-04 
    ##       leaf_respiration_rate_m2              stomatal_slope.BB 
    ##                  -2.661322e-04                   2.494761e-04 
    ## growth_respiration_coefficient extinction_coefficient_diffuse 
    ##                   0.000000e+00                  -7.034235e-07 
    ## 
    ## $variances
    ##                          Vcmax                       c2n_leaf 
    ##                   3.028446e-11                   2.679287e-34 
    ##                 cuticular_cond                            SLA 
    ##                   5.399594e-09                   8.184348e-06 
    ##       leaf_respiration_rate_m2              stomatal_slope.BB 
    ##                   6.127874e-10                   3.303832e-08 
    ## growth_respiration_coefficient extinction_coefficient_diffuse 
    ##                   2.408279e-34                   2.469152e-14 
    ## 
    ## $partial.variances
    ##                          Vcmax                       c2n_leaf 
    ##                   3.682704e-06                   3.258114e-29 
    ##                 cuticular_cond                            SLA 
    ##                   6.566110e-04                   9.952476e-01 
    ##       leaf_respiration_rate_m2              stomatal_slope.BB 
    ##                   7.451726e-05                   4.017585e-03 
    ## growth_respiration_coefficient extinction_coefficient_diffuse 
    ##                   2.928558e-29                   3.002582e-09 
    ## 
    ##            Vcmax  c2n_leaf cuticular_cond       SLA leaf_respiration_rate_m2
    ## 0.135  0.2813116 0.2813279      0.2812643 0.2805951                0.2814075
    ## 2.275  0.2813169 0.2813279      0.2812712 0.2806210                0.2813787
    ## 15.866 0.2813221 0.2813279      0.2812891 0.2807486                0.2813528
    ## 50     0.2813279 0.2813279      0.2813279 0.2813279                0.2813279
    ## 84.134 0.2813333 0.2813279      0.2814032 0.2840108                0.2813038
    ## 97.725 0.2813387 0.2813279      0.2815674 0.2918411                0.2812795
    ## 99.865 0.2813446 0.2813279      0.2817941 0.2992987                0.2812522
    ##        stomatal_slope.BB growth_respiration_coefficient
    ## 0.135          0.2806125                      0.2813279
    ## 2.275          0.2808761                      0.2813279
    ## 15.866         0.2811397                      0.2813279
    ## 50             0.2813279                      0.2813279
    ## 84.134         0.2814873                      0.2813279
    ## 97.725         0.2816096                      0.2813279
    ## 99.865         0.2816942                      0.2813279
    ##        extinction_coefficient_diffuse
    ## 0.135                       0.2813282
    ## 2.275                       0.2813281
    ## 15.866                      0.2813280
    ## 50                          0.2813279
    ## 84.134                      0.2813277
    ## 97.725                      0.2813275
    ## 99.865                      0.2813272
    ## TableGrob (4 x 2) "arrange": 8 grobs
    ##                                z     cells    name           grob
    ## Vcmax                          1 (1-1,1-1) arrange gtable[layout]
    ## c2n_leaf                       2 (1-1,2-2) arrange gtable[layout]
    ## cuticular_cond                 3 (2-2,1-1) arrange gtable[layout]
    ## SLA                            4 (2-2,2-2) arrange gtable[layout]
    ## leaf_respiration_rate_m2       5 (3-3,1-1) arrange gtable[layout]
    ## stomatal_slope.BB              6 (3-3,2-2) arrange gtable[layout]
    ## growth_respiration_coefficient 7 (4-4,1-1) arrange gtable[layout]
    ## extinction_coefficient_diffuse 8 (4-4,2-2) arrange gtable[layout]
    ## $Vcmax
    ## 
    ## $c2n_leaf
    ## 
    ## $cuticular_cond
    ## 
    ## $SLA
    ## 
    ## $leaf_respiration_rate_m2
    ## 
    ## $stomatal_slope.BB
    ## 
    ## $growth_respiration_coefficient
    ## 
    ## $extinction_coefficient_diffuse
    ## 
    ## 2020-07-01 21:49:51 INFO   [db.print.connections] : 
    ##    Created 9 connections and executed 92 queries 
    ## 2020-07-01 21:49:51 INFO   [db.print.connections] : 
    ##    Created 9 connections and executed 92 queries 
    ## 2020-07-01 21:49:51 DEBUG  [db.print.connections] : 
    ##    No open database connections. 
    ## [1] "---------- PEcAn Workflow Complete ----------"

``` r
file.copy("temp_exps_results3/", "temp_exps_results/", recursive = TRUE)
```

    ## [1] TRUE

``` r
unlink("temp_exps_results3/", recursive = TRUE)
file.copy("~/temp_exps_results3/dbfiles/", "temp_exps_results/temp_exps_results3/", recursive = TRUE)
```

    ## [1] TRUE

``` r
unlink("~/temp_exps_results3/", recursive = TRUE)
```

Plot biomass results. Create a script called `plot_results3.R`, which will contain following code. This pulls in and cleans up the biomass data estimated from BioCro, then plots the data.

``` r
# Clean up biomass data
data_path <- "../../../model-vignettes-data/manual-measurements-Darpa_setaria_chambers_experiments.xlsx"
sheets_names <- excel_sheets(data_path)
area_cm2 <- 103
area_ha <- ud.convert(area_cm2, "cm2", "ha")

highnight_biomass <- read_excel(data_path, sheets_names[10]) %>% 
      rename(temperature...C..day.night = 6, 
         biomass.harvested = 12, 
         panicles.DW..mg. = 21, 
         stemDW.mg. = 18,
         leaf.DW.mg. = 19, 
         roots.DW..mg. = 20) %>% 
  filter(genotype == "ME034V-1", temperature...C..day.night == 31, 
         treatment == "control", sample_for == "biomass") %>% 
  mutate(days_grown = as.integer(as.Date(as.character(biomass.harvested), format = "%Y-%m-%d") - 
                                   as.integer(as.Date(as.character(temperature_treatment_started), 
                                                      format = "%Y-%m-%d"))), 
         total_biomass_mg = panicles.DW..mg. + stemDW.mg. + leaf.DW.mg. + roots.DW..mg., 
         total_biomass_Mgha = ud.convert(total_biomass_mg, "mg", "Mg") / area_ha) %>% 
  filter(!is.na(total_biomass_Mgha))
write.csv(highnight_biomass, "temp_exps_inputs3/highnight_biomass_meas.csv")

# Clean up biomass estimates
load('temp_exps_results/temp_exps_results3/out/SA-median/biocro_output.RData')
timescale <- data.table(day = rep(biocro_result$doy, each = 24), hour = 0:23)
rm(biocro_result)

load("temp_exps_results/temp_exps_results3/ensemble.ts.NOENSEMBLEID.TotLivBiom.2019.2019.Rdata")
daily_biomass <- data.frame(timescale, t(ensemble.ts[["TotLivBiom"]])) %>% 
  gather(ensemble, biomass, X1:X10) %>% 
  group_by(day, hour) %>% 
  summarise(mean = mean(biomass, na.rm = TRUE), 
            median = median(biomass, na.rm = TRUE), 
            sd = sd(biomass, na.rm = TRUE), 
            lcl = quantile(biomass, probs = c(0.025), na.rm = TRUE), 
            ucl = quantile(biomass, probs = c(0.975), na.rm = TRUE)) %>% 
  group_by(day) %>% 
  summarise(mean = sum(mean), 
            median = sum(median), 
            sd = sqrt(sum(sd^2)), 
            lcl = sum(lcl), 
            ucl = sum(ucl))
write.csv(daily_biomass, "temp_exps_inputs3/biomass_ests3.csv")
rm(ensemble.ts)

# Plot measured biomass against biomass estimates
sd_scale <- 5
ggplot(data = daily_biomass) + 
  geom_line(aes(day, y = mean)) +
  geom_ribbon(aes(day, ymin = mean - sd_scale * sd, ymax = mean + sd_scale * sd), alpha = 0.1) +
  geom_ribbon(aes(day, ymin = lcl, ymax = ucl), alpha = 0.1) +
  #geom_point(data = highnight_biomass, aes(x = days_grown, y = total_biomass_Mgha)) +
  xlab("Day of Year") + 
  ylab("Total Biomass Mg/ha") +
  theme_classic()
```

Section 4: Plot Three Runs
==========================

Code to plot the biomass estimates from the first two runs together, along with the control data.

``` r
# Read in and combine biomass measurements data
biomass_meas_control <- read.csv("temp_exps_inputs1/control_biomass_meas.csv") %>% 
  mutate(txt = "control") %>% 
  select(days_grown, total_biomass_Mgha, txt)
biomass_meas_highnight <- read.csv("temp_exps_inputs3/highnight_biomass_meas.csv") %>% 
  mutate(txt = "highnight") %>% 
  select(days_grown, total_biomass_Mgha, txt)

biomass_meas <- bind_rows(biomass_meas_control, biomass_meas_highnight)

# Read in and combine biomass estimates data
biomass_ests1 <- read.csv("temp_exps_inputs1/biomass_ests1.csv") %>% 
  mutate(run = 1)
biomass_ests2 <- read.csv("temp_exps_inputs2/biomass_ests2.csv") %>% 
  mutate(run = 2)
biomass_ests3 <- read.csv("temp_exps_inputs3/biomass_ests3.csv") %>% 
  mutate(run = 3)

biomass_ests <- bind_rows(biomass_ests1, biomass_ests2, biomass_ests3) %>% 
  mutate(run = as.factor(run)) #%>%
  #udunits convert from Mg/ha to g/cm2 for all data columns

# Plot measured biomass against biomass estimates
sd_scale <- 5

ggplot(data = biomass_ests) +
  geom_line(aes(day, mean, color = run)) +
  scale_color_manual(values=c("red", "black", "blue")) +
  xlim(x = c(0, 60)) +
  xlab("Day of Year") + 
  ylab("Total Biomass Mg/ha") +
  theme_classic()

ggplot(data = biomass_ests) +
  geom_line(aes(day, mean, color = run)) +
  geom_ribbon(aes(day, ymin = mean - sd_scale * sd, ymax = mean + sd_scale * sd, fill = run), alpha = 0.1) +
  scale_color_manual(values=c("red", "black", "blue", "red", "black", "blue")) +
  xlim(x = c(0, 60)) +
  xlab("Day of Year") + 
  ylab("Total Biomass Mg/ha") +
  theme_classic()

ggplot(data = biomass_ests) +
  geom_line(aes(day, mean, color = run)) +
  geom_point(data = biomass_meas, aes(x = days_grown, y = total_biomass_Mgha, color = txt)) +
  #scale_color_manual(values=c("red", "black", "blue", "red", "blue")) +
  #xlim(x = c(0, 60)) +
  xlab("Day of Year") + 
  ylab("Total Biomass Mg/ha") +
  theme_classic()
```
