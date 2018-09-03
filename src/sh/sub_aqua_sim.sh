#!/bin/bash
#
# Usage: sub_aqua_sim.sh start end
# Purpose:
# Submit a batch of jobs for the simulation study of the AQUA-gh-tc model.
# This version of the script is written for the Artemis cluster of the
# University of Sydney.
#
# Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
# Date:   September 3, 2018

start=$1
end=$2

DATAFILE=/project/symbolic/src/base/simdata_tc_lean.mat
OUTNAME=/project/symbolic/out/symbolic/sim_aqua/aqua_sim_tc_
PROJECT=symbolic
JOBNAME=sim_tc_
WALLTIME=48:00:00
NCPUS=1
MEM=1024mb

for ((i = $start; i <= $end; i++))
do
    cmd="matlab -r \" \
        addpath('/project/symbolic/src/apat'); \
        addpath('/project/symbolic/src/base'); \
        try, aqua_simjob_tc('$DATAFILE', '$OUTNAME$i.mat', '$i'), \
        catch Ex, disp(Ex.message); exit(1), end, exit(0);\" \
        -nosplash -nodisplay -nodesktop -nojvm -singleCompThread"
    ./makesub.sh \
        $PROJECT \
        $JOBNAME$i \
        $WALLTIME \
        $NCPUS \
        $MEM \
        "$cmd" \
        | qsub
done
echo "Submission complete."
