#!/bin/bash -l

# create output folder
mkdir -p "/groups/dlebauer/ed2_results/pecan_remote/2022-10-11-20-36-49/out/ENS-00041-1000018168"
# no need to mkdir for scratch

# redirect output
exec 3>&1
exec &>> "/groups/dlebauer/ed2_results/pecan_remote/2022-10-11-20-36-49/out/ENS-00041-1000018168/logfile.txt"

TIMESTAMP=`date +%Y/%m/%d_%H:%M:%S`
echo "Logging on "$TIMESTAMP

# host specific setup

module load openmpi3 R

# @REMOVE_HISTXML@ : tag to remove "history.xml" on remote for restarts, commented out on purpose


# flag needed for ubuntu
export GFORTRAN_UNBUFFERED_PRECONNECTED=yes

# see if application needs running
if [ ! -e "/groups/dlebauer/ed2_results/pecan_remote/2022-10-11-20-36-49/out/ENS-00041-1000018168/history.xml" ]; then
  cd "/groups/dlebauer/ed2_results/pecan_remote/2022-10-11-20-36-49/run/ENS-00041-1000018168"
  
  "/groups/dlebauer/ed2_results/global_inputs/pecan-dev_ed2-dev.sh" ""
  STATUS=$?
  if [ $STATUS == 0 ]; then
    if grep -Fq '=== Time integration ends; Total elapsed time=' "/groups/dlebauer/ed2_results/pecan_remote/2022-10-11-20-36-49/out/ENS-00041-1000018168/logfile.txt"; then
      STATUS=0
    else
      STATUS=1
    fi
  fi
  
  # copy scratch if needed
  # no need to copy from scratch
  # no need to clear scratch

  # check the status
  if [ $STATUS -ne 0 ]; then
  	echo -e "ERROR IN MODEL RUN\nLogfile is located at '/groups/dlebauer/ed2_results/pecan_remote/2022-10-11-20-36-49/out/ENS-00041-1000018168/logfile.txt'"
  	echo "************************************************* End Log $TIMESTAMP"
    echo ""
  	exit $STATUS
  fi

  # convert to MsTMIP
  singularity run /groups/dlebauer/ed2_results/global_inputs/pecan-dev_ed2-dev.sif /usr/local/bin/Rscript \
    -e "library(PEcAn.ED2)" \
    -e "model2netcdf.ED2('/groups/dlebauer/ed2_results/pecan_remote/2022-10-11-20-36-49/out/ENS-00041-1000018168', 35.4978817, -81.072417, '2001-01-01', '2003-12-31', c(SetariaWT = 1L))"
  STATUS=$?
  if [ $STATUS -ne 0 ]; then
  	echo -e "ERROR IN model2netcdf.ED2\nLogfile is located at '/groups/dlebauer/ed2_results/pecan_remote/2022-10-11-20-36-49/out/ENS-00041-1000018168'/logfile.txt"
  	echo "************************************************* End Log $TIMESTAMP"
    echo ""
    exit $STATUS
  fi
fi

# copy readme with specs to output
cp  "/groups/dlebauer/ed2_results/pecan_remote/2022-10-11-20-36-49/run/ENS-00041-1000018168/README.txt" "/groups/dlebauer/ed2_results/pecan_remote/2022-10-11-20-36-49/out/ENS-00041-1000018168/README.txt"

# run getdata to extract right variables

# host specific teardown


# all done
echo -e "MODEL FINISHED\nLogfile is located at '/groups/dlebauer/ed2_results/pecan_remote/2022-10-11-20-36-49/out/ENS-00041-1000018168/logfile.txt'"
echo "************************************************* End Log $TIMESTAMP"
echo ""
