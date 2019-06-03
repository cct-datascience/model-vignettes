Community Dynamics Simulation
================
Kristina Riemer
3/25/2019

## Run model

The Ecosystem Demography ([ED2](https://github.com/EDmodel/ED2)) model
was run using the [PEcAn VM in
Virtualbox](https://pecanproject.github.io/pecan-documentation/develop/GettingStarted.html#installing-and-running-pecan).
Follow steps 1-5 in section 4.2.1 to get the PEcAn virtual machine
installed and running, and open the web interface for PEcAn by going to
`localhost:6480/pecan/` in the browser.

Click “Next” button, then specify the following settings on the next
page (“Select host, model, site”):

  - Host = pecan.vm
  - Model = ED2.2 (git)
  - Site Group = All Sites
  - Site = EBI Energy farm

Select “Next” button and select the following:

  - PFTs (use control+click to select multiple)
    1.  ebifarm.c3grass
    2.  ebifarm.c4crop
    3.  ebifarm.forb
  - Start Date = 2004/01/01
  - End Date = 2009/12/31
  - ED2.cohort = ebifarm.lat40.0long-88.0.css
  - ED2.patch = ebifarm.lat40lon-88.0.pss
  - ED2.site = ebifarm. lat40.0lon88.0.site
  - Ed.met\_driver\_header = ED\_MET\_DRIVER\_HEADER 2004-2009
  - Land use = Earth Land Surface
  - Soil = FAO\_
  - Thermal sums = Earth Land Surface
  - Vegetation = OGE2

Check “Edit model config” box to be able to edit the configuration file
for the model on the next page. The file was changed to match what is
below:

``` sh
   !---------------------------------------------------------------------------------------!
   ! ED2 File output.  For all the variables 0 means no output and 3 means HDF5 output.    !
   !                                                                                       !
   ! IFOUTPUT -- Fast analysis.  These are mostly polygon-level averages, and the time     !
   !             interval between files is determined by FRQANL                            !
   ! IDOUTPUT -- Daily means (one file per day)                                            !
   ! IMOUTPUT -- Monthly means (one file per month)                                        !
   ! IQOUTPUT -- Monthly means of the diurnal cycle (one file per month).  The number      !
   !             of points for the diurnal cycle is 86400 / FRQANL                         !
   ! IYOUTPUT -- Annual output.                                                            !
   ! ITOUTPUT -- Instantaneous fluxes, mostly polygon-level variables, one file per year.  !
   ! IOOUTPUT -- Observation time output. Equivalent to IFOUTPUT, except only at the       !
   !             times specified in OBSTIME_DB.                                            !
   ! ISOUTPUT -- restart file, for HISTORY runs.  The time interval between files is       !
   !             determined by FRQHIS                                                      !
   !---------------------------------------------------------------------------------------!
   NL%IFOUTPUT = 0
   NL%IDOUTPUT = 0
   NL%IMOUTPUT = 3
   NL%IQOUTPUT = 0
   NL%IYOUTPUT = 0
   NL%ITOUTPUT = 0
   NL%IOOUTPUT = 0
   NL%ISOUTPUT = 0
   !---------------------------------------------------------------------------------------!
```

``` sh
   !---------------------------------------------------------------------------------------!
   ! ATTACH_METADATA -- Flag for attaching metadata to HDF datasets.  Attaching metadata   !
   !                    will aid new users in quickly identifying dataset descriptions but !
   !                    will compromise I/O performance significantly.                     !
   !                    0 = no metadata, 1 = attach metadata                               !
   !---------------------------------------------------------------------------------------!
   NL%ATTACH_METADATA = 1
   !---------------------------------------------------------------------------------------!
```

``` sh
   !---------------------------------------------------------------------------------------!
   ! UNITFAST  --  The following variables control the units for FRQFAST/OUTFAST, and      !
   ! UNITSTATE     FRQSTATE/OUTSTATE, respectively.  Possible values are:                  !
   !               0.  Seconds;                                                            !
   !               1.  Days;                                                               !
   !               2.  Calendar months (variable)                                          !
   !               3.  Calendar years  (variable)                                          !
   !                                                                                       !
   ! N.B.: 1. In case OUTFAST/OUTSTATE are set to special flags (-1 or -2)                 !
   !          UNITFAST/UNITSTATE will be ignored for them.                                 !
   !       2. In case IQOUTPUT is set to 3, then UNITFAST has to be 0.                     !
   !                                                                                       !
   !---------------------------------------------------------------------------------------!
   NL%UNITFAST = 1
   NL%UNITSTATE = 1
   !---------------------------------------------------------------------------------------!

   !---------------------------------------------------------------------------------------!
   ! OUTFAST/OUTSTATE -- these control the number of times per file.                       !
   !                      0. Each time gets its own file                                   !
   !                     -1. One file per day                                              !
   !                     -2. One file per month                                            !
   !                    > 0. Multiple timepoints can be recorded to a single file reducing !
   !                         the number of files and i/o time in post-processing.          !
   !                         Multiple timepoints should not be used in the history files   !
   !                         if you intend to use these for HISTORY runs.                  !
   !---------------------------------------------------------------------------------------!
   NL%OUTFAST = 0
   NL%OUTSTATE = 0
   !---------------------------------------------------------------------------------------!
```

## Visualize results

All the Output files of the format `analysis-E-*-*-00-000000-g01.h5`
were downloaded by selecting them from the dropdown menu and selecting
the “Show Output File” button.

There is one file per month. The data format for a single month for the
variable `MMEAN_LAI_PY` is shown below. Each row is a PFT and each
column is a cohort.

``` r
library(ncdf4)
single_nc <- nc_open("ed2_results/analysis-E-2004-01-00-000000-g01.h5")
single_nc_lai <- ncvar_get(single_nc, "MMEAN_LAI_PY")
single_nc_lai
```

    ##             [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]       [,11]
    ##  [1,] 0.06157984    0    0    0    0    0    0    0    0     0 0.002042686
    ##  [2,] 0.03313895    0    0    0    0    0    0    0    0     0 0.000000000
    ##  [3,] 0.05085608    0    0    0    0    0    0    0    0     0 0.001686965
    ##  [4,] 0.00000000    0    0    0    0    0    0    0    0     0 0.000000000
    ##  [5,] 0.00000000    0    0    0    0    0    0    0    0     0 0.000000000
    ##  [6,] 0.00000000    0    0    0    0    0    0    0    0     0 0.000000000
    ##  [7,] 0.00000000    0    0    0    0    0    0    0    0     0 0.000000000
    ##  [8,] 0.00000000    0    0    0    0    0    0    0    0     0 0.000000000
    ##  [9,] 0.00000000    0    0    0    0    0    0    0    0     0 0.000000000
    ## [10,] 0.00000000    0    0    0    0    0    0    0    0     0 0.000000000
    ## [11,] 0.00000000    0    0    0    0    0    0    0    0     0 0.000000000
    ## [12,] 0.00000000    0    0    0    0    0    0    0    0     0 0.000000000
    ## [13,] 0.00000000    0    0    0    0    0    0    0    0     0 0.000000000
    ## [14,] 0.00000000    0    0    0    0    0    0    0    0     0 0.000000000
    ## [15,] 0.00000000    0    0    0    0    0    0    0    0     0 0.000000000
    ## [16,] 0.00000000    0    0    0    0    0    0    0    0     0 0.000000000
    ## [17,] 0.00000000    0    0    0    0    0    0    0    0     0 0.000000000

Each monthly LAI dataset is summed across cohort and only the rows for
the three PFTs of interest are retained. All the monthly datasets are
combined into one.

``` r
library(dplyr)
library(tibble)

extract_lai <- function(file_path){
  nc <- nc_open(file_path)
  lai <- ncvar_get(nc, "MMEAN_LAI_PY")
  lai_df <- data.frame(lai)
  clean_lai_df <- lai_df %>% 
    transmute(LAI = rowMeans(.)) %>% 
    slice(1:3) %>% 
    add_column(PFT = c("c3grass", "c4crop", "forb"), 
             date = substr(file_path, 24, 30)) %>% 
    mutate(date = as.Date(paste0(date, "-01")))
}

nc_files <- list.files("ed2_results/", pattern = "*.h5")
nc_file_paths <- paste0("ed2_results/", nc_files)

all_lai <- lapply(nc_file_paths, extract_lai)
all_lai <- do.call(rbind, all_lai)
head(all_lai)
```

    ##           LAI     PFT       date
    ## 1 0.005783866 c3grass 2004-01-01
    ## 2 0.003012631  c4crop 2004-01-01
    ## 3 0.004776640    forb 2004-01-01
    ## 4 0.008135376 c3grass 2004-02-01
    ## 5 0.003429235  c4crop 2004-02-01
    ## 6 0.007496156    forb 2004-02-01

The LAI time series per PFT is plotted.

``` r
library(ggplot2)

ggplot(all_lai, aes(x = date, y = LAI, color = PFT)) +
  geom_line()
```

![](ed2_in_pecan_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->
