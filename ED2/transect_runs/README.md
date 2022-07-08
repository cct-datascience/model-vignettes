ED2 North America Transect Runs
================

### Overview

This folder contains inputs and scripts to simulate Setaria growth using
ED2 for various sites.

Each subfolder in the `transect_runs` folder is for a single site. Each
site and associated files/folders are identifiable by a unique
two-letter acronym. PFTs, initial conditions, and time ranges can vary
by site and are documented here.

### Sites information

1.  Santa Rita site in southern Arizona
      - Acronym: SR
      - PEcAn site ID: 1000000111
      - Simulation PFTS: Setaria, C3 grass
      - Simulation initial conditions: no patch or cohort
      - Simulation time range: March - September 2019
      - Number of ensembles: 50
2.  Walker Branch site in eastern Tennessee
      - Acronym: WB
      - PEcAn site ID: 1000000075
      - Simulation PFTS: Setaria, C3 grass
      - Simulation initial conditions: no patch or cohort
      - Simulation time range: March - September 2019
      - Number of ensembles: 50
3.  Little Washita Watershed site in Oklahoma
      - Acronym: LW
      - PEcAn site ID: 1000000042
      - Simulation PFTS: Setaria, C3 grass
      - Simulation initial conditions: no patch or cohort
      - Simulation time range: March - September 2019
      - Number of ensembles: 50

### Setting up a new site

  - Set up files and folders
      - Choose two-letter acronym, create folder in `transect_runs` with
        this as name
      - Create `weather` and `run` subfolders
      - Copy `pecan.xml`, `workflow.R`, and `plot.R` into these
        subfolders from previous sites
  - Get MERRA weather for site and dates
      - Modify `pecan.xml`
          - Update `outdir` to form `/data/sites/xx_weather_only`
          - `dbfiles` MUST be set to `/data/sites`
          - Update site ID
          - If needed, change run and met start and end dates; files
            take a long time to download and have to be consecutive with
            already downloaded files, so be mindful of the date ranges
            chosen; might need to delete files on BetyDB if weather data
            has already been downloaded for a site
      - Modify `workflow.R`
          - This is a truncated workflow script that goes through
            `do_conversions`
              - Update path to read in corresponding `pecan.xml`
      - Copy over .h5 files from `MERRA_ED2_site_1-xx` to HPC using
        command line command similar to this: `rsync '-a' '-q'
        '--delete' '/data/sites/MERRA_ED2_site_1-111'
        'kristinariemer@login.ocelote.hpc.arizona.edu:/groups/dlebauer/ed2_results/inputs/julianp/sites/MERRA_ED2_site_1-111'`
      - Run `workflow.R`
  - Run ED2 Pecan workflow
      - Modify `pecan.xml`
          - Set `outdir` path to form of `/data/tests/ed2_transect_XX`
          - Update site ID
          - If needed, change run and met start and end dates
          - Set ED2 tag `IED_INIT_MODE` to 6 if patch/cohort, to 0 if no
            patch/cohort
      - Modify `workflow.R`
          - Update path to read in corresponding `pecan.xml`
          - Update rsync lines to and from HPC
      - Run `workflow.R`
  - Plot results
      - Update `outdir_name` in `plots.R`
      - Run `plots.R`

### TODO

  - Once patch and cohort files are working, add new site instructions
    here
