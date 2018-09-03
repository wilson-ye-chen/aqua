#!/bin/bash
#
# Usage: sub_gjrt_fore.sh key start end
# Purpose:
# Submit a batch of jobs for the empirical study of the GJR-t model
# using an empirical index data. This version of the script is written
# for the Artemis cluster of the University of Sydney.
#
# Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
# Date:   September 3, 2018

key=$1
start=$2
end=$3

DAT=/project/symbolic/src/ppr/data/data_$key.mat
OUT=/project/symbolic/out/symbolic/fore_gjrt/$key/gjrt.$key.
PROJECT=symbolic
JOBNAME=$key.
WALLTIME=72:00:00
NCPUS=1
MEM=2GB

N_EST=3050
INT_EST=10

cmd="matlab -r \" \
    addpath('/project/symbolic/src/apat'); \
    addpath('/project/symbolic/src/base'); \
    try, gjr_forejob_t('$DAT', '$OUT$start-$end.mat', \
    '$N_EST', '$INT_EST', '$start', '$end'), \
    catch Ex, disp(Ex.message); exit(1), end, exit(0);\" \
    -nosplash -nodisplay -nodesktop -nojvm -singleCompThread"
./makesub.sh \
    $PROJECT \
    $JOBNAME$start-$end \
    $WALLTIME \
    $NCPUS \
    $MEM \
    "$cmd" \
    | qsub
echo "Submission complete."
