#!/bin/bash
#
# Usage: sub_aqua_est.sh key
# Purpose:
# Submit an estimation job for the empirical study of the AQUA-gh-tc model.
# This version of the script is written for the Artemis cluster of the
# University of Sydney.
#
# Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
# Date:   September 3, 2018

key=$1

DATAFILE=/project/symbolic/src/ppr/data/data_$key.mat
OUTFILE=/project/symbolic/out/symbolic/est_aqua/estresult_aqua_$key.mat
PROJECT=symbolic
JOBNAME=est_aqua_$key
WALLTIME=48:00:00
NCPUS=1
MEM=10GB

cmd="matlab -r \" \
    addpath('/project/symbolic/src/apat'); \
    addpath('/project/symbolic/src/base'); \
    try, aqua_estjob_tc('$DATAFILE', '$OUTFILE'), \
    catch Ex, disp(Ex.message); exit(1), end, exit(0);\" \
    -nosplash -nodisplay -nodesktop -nojvm -singleCompThread"
./makesub.sh \
    $PROJECT \
    $JOBNAME \
    $WALLTIME \
    $NCPUS \
    $MEM \
    "$cmd" \
    | qsub
echo "Submission complete."
