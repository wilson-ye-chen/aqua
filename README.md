# AQUA?
'AQUA' is the code name for the paper titled 'Dynamic Quantile Function Models'.

# Data
## Abstract
The dataset used in the empirical studies of this paper contains observations of one-minute prices and end-of-day (EOD) returns for ten major international stock indices.

## Availability
The raw data (prior to cleaning) can be accessed via the Thomson Reuters Tick History (TRTH) database. APIs for connecting to TRTH are available for many programming languages (https://developers.thomsonreuters.com/thomson-reuters-tick-history-trth). The cleaned data used for the empirical studies can be found in the paper's GitHub repository (https://github.com/wilson-ye-chen/aqua). The steps taken to clean the raw data are documented in Section 5.1.

## Description
One-minute price series of ten major stock indices: S&P 500 (SPX), Dow Jones Industrial Average (DJIA), NASDAQ Composite (Nasdaq), FTSE 100 (FTSE), DAX, CAC 40 (CAC), Nikkei Stock Average 225 (Nikkei), Hang Seng (HSI), Shanghai Composite (SSEC), and All Ordinaries (AORD). The sample period starts on January 3, 1996 and ends on May 24, 2016.

Links to data:

Compressed CSV files for the raw data (both one-minute and EOD prices):
https://github.com/wilson-ye-chen/aqua/tree/master/src/ppr/data/csv.gz

MATLAB binary files (MAT) for the cleaned one-minute price series:
https://github.com/wilson-ye-chen/aqua/tree/master/src/ppr/data

The cleaned one-minute price series for a single index is stored in 'pricedata_<index>.mat', where <index> is the abbreviated name of the index. Each file contains the following variables:
'D' – dates.
'T' – time-stamp of each price.
'iD' – date index of each price.
'iDKeep' – binary indicator for whether a day is kept during cleaning.
'p' – prices.

Note: all the MAT files can be directly loaded into MATLAB by calling the 'load' function, e.g., load('pricedata_spx.mat').
From the cleaned one-minute price series, one can generate the symbolic data files. The symbolic data file for a single index is stored in 'data_<index>.mat', where <index> is the abbreviated name of the index. Each file contains the following variables:
'D' – dates.
'Xi' – g-and-h symbolic observations.
'logX' – log realised variances (computed using cleaned one-minute prices).
'r' – end-of-day returns.

# Code
## Abstract
MATLAB code for reproducing the simulation and empirical studies in the paper.

## Description
Link to repository:
https://github.com/wilson-ye-chen/aqua

All the code files are under the 'src' directory. The sub-directories under 'src' are organised as follows:
* 'apat' – functions associated with the Apatosaurus distribution.
* 'base' – library-type functions that implement the core functionalities (e.g., data cleaning, generating QF-valued data, estimating the DQF model using MCMC, generating Bayesian forecasts, etc.).
* 'l1spline' – functions written by 'Mariano Tepper' for fitting L1-splines of Tepper and Saprio (2012, 2013). The 'l1spline' function is called during data clearning. (See Appendix F for details.)
* 'ppr' – high-level functions and datasets for producing 'paper specific' results. Some functions require intermediate results returned by the lower-level functions in 'base'.
* 'sh' – BASH shell scripts for automatically submitting estimation/forecasting jobs to be executed in parallel on an Unix/Linux cluster (via PBS job scripts).
* 'subaxis' – code written by Aslak Grinsted for generating more flexible sub-plots.

## Access to computing cluster
Access to an Unix/Linux cluster supporting PBS scripts and MATLAB is desirable as it enables the forecasts and estimation results to be generated in parallel (by taking advantage of the provided shell scripts in 'sh').

# Instructions for Use
## Reproducibility
Assume that 1) you have cloned the repository, 2) have MATLAB running, and 3) your current working directory is 'src'.

### I. Generate cleaned price data from raw .csv data:
1. addpath('base'); addpath('l1spline');
2. Uncompress all the files in 'ppr/data/csv.gz' into a new directory, e.g., 'ppr/data/csv'.
3. Stat = run_genprice('ppr/data/csv');
4. 'Stat' is a matrix of cleaning summaries containing raw vectors (number of days, number of days deleted, number of prices, number of prices deleted, fraction of price deleted).
5. The generated data files are stored in the current working directory with names 'pricedata_<index>.mat'.

### II. Generate symbolic data from raw .csv data:
1. addpath('base'); addpath('l1spline');
2. Uncompress all the files in 'ppr/data/csv.gz' into a new directory, e.g., 'ppr/data/csv'.
3. Stat = run_gendata('ppr/data/csv'); 'Stat' is a matrix of cleaning summaries containing raw vectors (number of days, number of days deleted, number of prices, number of prices deleted, fraction of price deleted).
4. The generated data files are stored in the current working directory with names 'data_<index>.mat'.

### III. Reproduce the simulated dataset
1. rng(373901508);
2. Xi = aqua_simdata_tc();

### IV. Reproduce simulation results in Table 1:
1. addpath('base'); addpath('apat');
2. mkdir('sim_result'); cd('sim_result');
3. aqua_simjob_tc('simdata_tc_lean.mat', 'aqua_sim_tc_<idx>.mat', <idx>);
4. Repeat step 3 for all values of <idx>, i.e., 1 to 1000. It is preferable to run step 3 as parallel jobs on a computing cluster using 'sh/sub_aqua_sim.sh'.
5. [iSamp, M, S, L, U, AccRate, MapcVal] = aqua_joinsimjob('.');
6. [A, B, G, H, C] = aqua_simsumm(M);

### V. Reproduce posterior summary for S&P 500 in Table 4:
1. addpath('base'); addpath('apat'); addpath('ppr/data');
2. aqua_estjob_tc('data_spx.mat', 'estresult_aqua_spx.mat');
3. load('estresult_aqua_spx.mat');
4. [A, B, G, H, C] = aqua_postsumm(Theta);

### VI. Estimate Apatosaurus and truncated-skewed-t marginal models:
1. addpath('base'); addpath('apat'); addpath('ppr/data');
2. margin_estjob_h('data_spx.mat', 'estresult_h_spx.mat');

### VII. Reproduce the plots in Figures 4-10:
1. addpath('base'); addpath('ppr'); addpath('subaxis');
2. plot_xi;
3. plot_q1min;
4. plot_w;
5. plot_qq_h;
6. plot_rsig;
7. plot_var;
8. plot_s;

### VIIII. Reproduce the estimation results required for Figure 8:
1. addpath('base'); addpath('apat'); addpath('ppr/data');
2. aqua_estjob_tc('data_<index>.mat', 'estresult_aqua_<index>.mat');
3. Repeat step 2 for all index identifiers <index>. It is preferable to run step 2 as parallel jobs on a computing cluster using 'sh/sub_aqua_est.sh'.
4. run_genapatrsig('.');

### X. Reproduce DQF model forecasting results:
1. addpath('base); addpath('apat'); addpath('ppr/data');
2. mkdir('fore_aqua_<index>'); cd('fore_aqua_<index>');
3. aqua_forejob_tc('data_<index>.mat', 'aqua.<index>.<a>-<b>.mat', '3050', '10', '<a>', '<b>'); The arguments <a> and <b> mark the starting and ending indices of the forecast sample. One can use <a> and <b> to partition the forecast sample, so that step 3 can be parallelised. It is preferable to run step 3 as parallel jobs on a computing cluster using 'sh/sub_aqua_fore.sh'.
4. run_joinforejob('.');
5. Repeat steps 2-5 for all index identifiers <index>.

### XI. Reproducing benchmark model forecasting results:
1. addpath('base); addpath('ppr/data');
2. caviar_sav_forejob('data_<index>.mat', 'caviar.<index>.3051-<b>.mat', '3050', '10', '3051', '<b>'); The argument <b> marks the ending index of the forecast sample, which varies across index identifiers <index>.
3. gjr_forejob_t('data_<index>.mat', 'gjrt.<index>.3051-<b>.mat', '3050', '10', '3051', '<b>');
4. gjr_forejob_skt('data_<index>.mat', 'gjrskt.<index>.3051-<b>.mat', '3050', '10', '3051', '<b>');
5. realgarch_forejob_t('data_<index>.mat', 'realt.<index>.3051-<b>.mat', '3050', '10', '3051', '<b>');
6. realgarch_forejob_skt('data_<index>.mat', 'realskt.<index>.3051-<b>.mat', '3050', '10', '3051', '<b>');
7. Repeat steps 2-6 for all index identifiers <index>.

### XII. Reproduce the scoring function values in Tables 5 and 6:
1. addpath('base');
2. [T1, T5] = table_scoringfunc('ppr/result');

### XIII. Reproduce the DIC results in Table 7 in Appendix C:
1. addpath('base');
2. run_estjob_ar1('ppr/data');
3. Follow steps 1-3 of part VIIII to obtain estimation results for the full model.
4. run_dic('.');
