#!/bin/bash
#
# Usage: sub_aqua_fore.sh key start end
# Purpose:
# Submit a batch of jobs for the empirical study of the AQUA-gh-tc model
# using an empirical equity index data. This script breaks the forecasting
# period into 10-day jobs. The model is only estimated once for each 10-
# day period. This version of the script is written for the Artemis cluster
# of the University of Sydney.
#
# Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
# Date:   September 3, 2018

key=$1
start=$2
end=$3

DAT=/project/symbolic/src/ppr/data/data_$key.mat
OUT=/project/symbolic/out/symbolic/fore_aqua/$key/aqua.$key.
PROJECT=symbolic
JOBNAME=$key.
WALLTIME=48:00:00
NCPUS=1
MEM=2GB

N_EST=3050
INT_EST=10

# Submit all the 10-day jobs
n_job=$((($end - $start + 1) / $INT_EST))
for ((i = 0; i < $n_job; i++))
do
    a=$(($i * $INT_EST + $start))
    b=$((($i + 1) * $INT_EST + $start - 1))
    cmd="matlab -r \" \
        addpath('/project/symbolic/src/apat'); \
        addpath('/project/symbolic/src/base'); \
        try, aqua_forejob_tc('$DAT', '$OUT$a-$b.mat', \
        '$N_EST', '$INT_EST', '$a', '$b'), \
        catch Ex, disp(Ex.message); exit(1), end, exit(0);\" \
        -nosplash -nodisplay -nodesktop -nojvm -singleCompThread"
    ./makesub.sh \
        $PROJECT \
        $JOBNAME$a-$b \
        $WALLTIME \
        $NCPUS \
        $MEM \
        "$cmd" \
        | qsub
    sleep 3s
done

# Submit one more job for the leftover days (less than 10)
if [ $b -lt $end ]
then
    a=$(($b + 1))
    b=$end
    cmd="matlab -r \" \
        addpath('/project/symbolic/src/apat'); \
        addpath('/project/symbolic/src/base'); \
        try, aqua_forejob_tc('$DAT', '$OUT$a-$b.mat', \
        '$N_EST', '$INT_EST', '$a', '$b'), \
        catch Ex, disp(Ex.message); exit(1), end, exit(0);\" \
        -nosplash -nodisplay -nodesktop -nojvm -singleCompThread"
    ./makesub.sh \
        $PROJECT \
        $JOBNAME$a-$b \
        $WALLTIME \
        $NCPUS \
        $MEM \
        "$cmd" \
        | qsub
fi
echo "Submission complete."
