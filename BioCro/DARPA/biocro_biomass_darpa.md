How to Do Biomass Partitioning on DARPA Data Using BioCro Model
================
Kristina Riemer, University of Arizona

For biomass partitioning using
[`OpBioGro`](https://github.com/ebimodeling/biocro/blob/master/R/OpBioGro.R).

### Weather data

From CLM file `clm_version.nc` to a dataframe with hourly rows and five
weather variables.

| BioCro var name | BioCro var unit | CLM var name | CLM var unit |
| --------------- | --------------- | ------------ | ------------ |
| solarR          | umol/m2/s       | FSDS         | W/m2         |
| DailyTemp.C     | C               | TBOT         | K            |
| RH              | 0-1             | RH           | %            |
| WindSpeed       | m/s             | WIND         | m/s          |
| precip          | mm (mm/h)       | PRECTmms     | mm/s         |

### TODO

  - Downscale from every three hours to every hour (`weach` from
    `BioCro` does daily to sub-daily); `OpBioGro` does not accomodate
    anything but hourly weather data currently
      - for each row, copy twice and add value to hour

<!-- end list -->

``` r
library(ncdf4)

clm_met <- nc_open("clm_version.nc")
print(clm_met)
```

    ## File clm_version.nc (NC_FORMAT_CLASSIC):
    ## 
    ##      13 variables (excluding dimension variables):
    ##         double LONGXY[lat,lon]   
    ##             long_name: longitude
    ##             units: degrees E
    ##         double LATIXY[lat,lon]   
    ##             long_name: latitude
    ##             units: degrees N
    ##         double ZBOT[lon,lat,time]   
    ##             long_name: observational height
    ##             units: m
    ##             Mode: time-dependent
    ##         double EDGEW[scalar]   
    ##             long_name: western edge in atmospheric data
    ##             units: degrees E
    ##         double EDGEE[scalar]   
    ##             long_name: eastern edge in atmospheric data
    ##             units: degrees E
    ##         double EDGES[scalar]   
    ##             long_name: southern edge in atmospheric data
    ##             units: degrees N
    ##         double EDGEN[scalar]   
    ##             long_name: northern edge in atmospheric data
    ##             units: degrees N
    ##         double TBOT[lon,lat,time]   
    ##             long_name: temperature at the lowest atm level (TBOT)
    ##             units: K
    ##             Mode: time-dependent
    ##         double RH[lon,lat,time]   
    ##             long_name: Relative humidity at the lowest atm level (RH)
    ##             units: %
    ##             Mode: time-dependent
    ##         double WIND[lon,lat,time]   
    ##             long_name: wind at the lowest atm level (WIND)
    ##             units: m/s
    ##             Mode: time-dependent
    ##         double FSDS[lon,lat,time]   
    ##             long_name: incident solar (FSDS)
    ##             units: W/m2
    ##             Mode: time-dependent
    ##         double PSRF[lon,lat,time]   
    ##             long_name: pressure at the lowest atm level (PSRF)
    ##             units: Pa
    ##             Mode: time-dependent
    ##         double PRECTmms[lon,lat,time]   
    ##             long_name: precipitation (PRECTmms)
    ##             units: mm/s
    ##             Mode: time-dependent
    ## 
    ##      4 dimensions:
    ##         scalar  Size:1
    ##         lon  Size:1
    ##         lat  Size:1
    ##         time  Size:2920
    ##             long_name: observation time
    ##             units: days since 2000-01-01 00:00:00
    ##             calendar: noleap

  - Convert units (all weather variables except wind speed)
      - From [Plant Growth Chamber
        Handbook](https://www.controlledenvironments.org/wp-content/uploads/sites/6/2017/06/Ch01.pdf):
        1 W/m2 = 4.6 umol/m2/s
      - Divide RH by 100
      - Precip from rate to amount? Assuming BioCro precipitation is
        amount per hour.

<!-- end list -->

``` r
clm_df <- data.frame(time = ncvar_get(clm_met, "time") , 
                     solarR = ncvar_get(clm_met, "FSDS"), 
                     DailyTemp.C = ncvar_get(clm_met, "TBOT"), 
                     RH = ncvar_get(clm_met, "RH"), 
                     WindSpeed = ncvar_get(clm_met, "WIND"), 
                     precip = ncvar_get(clm_met, "PRECTmms"))
```

### Biomass data

Plants all started to grow at same time (Jan 3, 2019). Plants harvested
on six different dates, from Jan 15 - Feb 19.

Columns needed:

  - Thermal temperature = temp col \* (harvest date - germination date)
  - Biomass = steam, leaf, root DW columns & zeroes for rhizome and
    grain
  - LAI = made up value? set as 1 for all (optional according to `idbp`
    documentation)

The plants were grown at three different temperatures, and there were
three genotypes.

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
biomass_data_all <- read.csv("biomass_setaria_me034_gehan.csv") %>% 
  filter(genotype == "ME034V-1", 
         temperature_celsius == 31)

biomass_data_by_tt <- biomass_data_all %>% 
  mutate(days_grown = as.Date(as.character(biomas_harvested),format="%m/%d/%Y") - as.Date(as.character(seeds_in_germination),format="%m/%d/%Y"), 
         ThermalT = as.numeric(days_grown * temperature_celsius)) %>% 
  select(ThermalT, stemDW.mg., leaf.DW.mg., roots.DW..mg.) %>% 
  group_by(ThermalT) %>% 
  summarise(Stem = mean(stemDW.mg.), 
            Leaf = mean(leaf.DW.mg.), 
            Root = mean(roots.DW..mg.))

biomass_data_by_tt$Rhizome <- rep(0, 6)
biomass_data_by_tt$Grain <- rep(0, 6)
#biomass_data_by_tt$LAI <- rep(1, 6)
biomass_data_by_tt <- data.frame(biomass_data_by_tt)
```

### Estimate coefficients

``` r
library(BioCro)

#coef_estimates <- valid_dbp(idbp(biomass_data_by_tt))
```
