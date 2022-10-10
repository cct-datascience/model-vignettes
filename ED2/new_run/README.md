Setting up an ED2 run
================

### Setting up a new site

0.  In ~/.ssh/config use the nickname "puma" and include username.  Basically, be able to log on to HPC with `ssh puma` without a password.
1.  Set up files and folders
  - Copy this `new_run` folder and its contents and re-name it
2.  Get MERRA weather for site and dates
  - Modify `weather/pecan.xml` as indicated in the comments
      - Update `outdir` to form `/data/sites/xx_weather_only`
      - `dbfiles` MUST be set to `/data/sites`
      - Update site ID
      - If needed, change run and met start and end dates; files take a
        long time to download and have to be consecutive with already
        downloaded files, so be mindful of the date ranges chosen; might
        need to delete files on BetyDB if weather data has already been
        downloaded for a site
  - Modify `weather/workflow.R`
      - This is a truncated workflow script that goes through
        `do_conversions`
          - Update path to read in corresponding `pecan.xml`
  - Run `weather/workflow.R`

3.  Run ED2 Pecan workflow
  - Modify `run/pecan.xml` as indicated in comments
      - Set `outdir` path to form of `/data/tests/ed2_transect_XX`
      - Update site ID
      - If needed, change run and met start and end dates
      - Set ED2 tag `IED_INIT_MODE` to 6 if patch/cohort, to 0 if no
        patch/cohort
  - **Delete all comments (`<!-- -->`) in pecan.xml!!** Comments will
    break several PEcAn functions currently!
      - Modify `run/workflow.R`
          - Update path to read in corresponding `pecan.xml`
      - Run `workflow.R` (this will take a while and you might want to
        run in a background R session with “Source as local job…”)
4. Plot results
    - Update `outdir_name` in `plots.R`
    - Run `plots.R`
