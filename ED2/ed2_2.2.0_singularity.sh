#!/bin/bash

module load singularity
pwd
singularity run -B ~/pecan/sites:/data/sites \
-B ~/pecan/inputs/ed_inputs:/data/ed_inputs \
-B ~/pecan/inputs/faoOLD:/data/faoOLD \
-B ~/pecan/inputs/oge2OLD:/data/oge2OLD \
-B ~/pecan/tests/ed2:/data/tests/ed2 \
~/pecan/pecan-model-ed2.sif /usr/local/bin/ed.2.2.0 -s
