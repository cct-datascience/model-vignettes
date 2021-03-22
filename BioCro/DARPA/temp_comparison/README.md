# Temperature comparisons

This folder contains code used to compare *Setaria* growth at two different chamber temperatures using BioCro. Day/ night temps of 31/22 are considered "rn" for "regular night" and temps of 31/31 are considered "hn" for "high night".


## Contents:

* `inputs/` folder:
  1. `pecan.rn.xml` and `pecan.hn.xml` constants specifying the PEcAn run parameters
  2. `setaria.constants.xml` *Setaria* constants specific to BioCro; growth allocation parameters were determined via optimization in the `biomass_opti/` folder
  3. `weather.rn.2019.csv` and `weather.hn.2019.csv` treatment-specific weather inputs to BioCro

* `scripts/` folder:
  1. `weather.R` generate weather for 2019 experiments
  2. `workflow_simple.R` main script running PEcAn workflow
  3. `organize_output.R` combines output from PEcAn run to compare treatments
  4. `plots*` visualizes results