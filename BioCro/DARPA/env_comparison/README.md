# Environment comparisons

This folder contains code used to compare *Setaria* growth at three different environments using BioCro. Chamber conditions at 31/22/430 are considered "ch", greenhouse pots of Jolly G soil are "gh", and outdoor pots of Jolly G soil are "out".


## Contents:

* `inputs/` folder:
  1. `pecan.ch.xml`, `pecan.gh.xml`, and `pecan.out.xml` constants specifying the PEcAn run parameters
  2. `setaria.constants.xml` *Setaria* constants specific to BioCro; growth allocation parameters were determined via optimization in the `biomass_opti/` folder
  3. `weather.ch.2020.csv`, `weather.gh.2020.csv` and `weather.out.2020.csv` treatment-specific weather inputs to BioCro

* `scripts/` folder:
  1. `weather.R` generate weather for 2020 experiments
  2. `workflow_simple.R` main script running PEcAn workflow
  3. `organize_output.R` combines output from PEcAn run to compare treatments
  4. `plots*` visualizes results