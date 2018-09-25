# AQUA?
'AQUA' is the code name for the paper titled 'Dynamic Quantile Function Models'
<!---
[arXiv](https://arxiv.org/abs/1707.02587).
-->
# Data
## Availability
The raw data (prior to cleaning) can be accessed via the Thomson Reuters Tick History (TRTH) database. APIs for connecting to TRTH are available for many programming languages: [Here](https://developers.thomsonreuters.com/thomson-reuters-tick-history-trth). The cleaned data used for the empirical studies can be found in this repository. The steps taken to clean the raw data are documented in Section 5.1.

## Description
The dataset used in the empirical studies of the paper contains observations of one-minute prices and end-of-day (EOD) returns for ten major international stock indices: S&P 500 (SPX), Dow Jones Industrial Average (DJIA), NASDAQ Composite (Nasdaq), FTSE 100 (FTSE), DAX, CAC 40 (CAC), Nikkei Stock Average 225 (Nikkei), Hang Seng (HSI), Shanghai Composite (SSEC), and All Ordinaries (AORD). The sample period starts on January 3, 1996 and ends on May 24, 2016.

Links to data:
* Compressed CSV files for the raw data (both one-minute and EOD prices): [Here](https://github.com/wilson-ye-chen/aqua/tree/master/src/ppr/data/csv.gz).
* MATLAB binary files (MAT) for the cleaned one-minute price series: [Here](https://github.com/wilson-ye-chen/aqua/tree/master/src/ppr/data).

The cleaned one-minute price series for a single index is stored in `pricedata_<index>.mat`, where `<index>` is the abbreviated name of the index. Each file contains the following variables:
* `D` - dates.
* `T` - time-stamp of each price.
* `iD` - date index of each price.
* `iDKeep` - binary indicator for whether a day is kept during cleaning.
* `p` - prices.

Note: all the MAT files can be directly loaded into MATLAB by calling the `load` function, e.g., `load('pricedata_spx.mat')`.
From the cleaned one-minute price series, one can generate the symbolic data files. The symbolic data file for a single index is stored in `data_<index>.mat`, where `<index>` is the abbreviated name of the index. Each file contains the following variables:
* `D` - dates.
* `Xi` - g-and-h symbolic observations.
* `logX` - log realised variances (computed using cleaned one-minute prices).
* `r` - end-of-day returns.

# Code
## Description
All the code files are under the `src` directory. The sub-directories under `src` are organised as follows:
* `apat` - functions associated with the Apatosaurus distribution.
* `base` - library-type functions that implement the core functionalities (e.g., data cleaning, generating QF-valued data, estimating the DQF model using MCMC, generating Bayesian forecasts, etc.).
* `l1spline` - functions written by Mariano Tepper for fitting L1-splines of Tepper and Saprio (2012, 2013). The `l1spline` function is called during data cleaning. (See Appendix F for details.)
* `ppr` - high-level functions and datasets for producing 'paper specific' results. Some functions require intermediate results returned by the lower-level functions in `base`.
* `sh` - BASH shell scripts for automatically submitting estimation/forecasting jobs to be executed in parallel on an Unix/Linux cluster (via PBS job scripts).
* `subaxis` - code written by Aslak Grinsted for generating more flexible sub-plots.

## Access to HPC
Access to an Unix/Linux cluster supporting PBS scripts and MATLAB is desirable as it enables the forecasts and estimation results to be generated in parallel (by taking advantage of the provided shell scripts in `sh`).

# Manual
## Examples
Assume that
1. you have cloned the repository,
2. have MATLAB running, and
3. your current working directory is `src`.

### I. Generate cleaned price data from raw .csv data:
Uncompress all the files in `ppr/data/csv.gz` into a new directory, e.g., `ppr/data/csv`.
```
addpath('base');
addpath('l1spline');
Stat = run_genprice('ppr/data/csv');
```
`Stat` is a matrix of cleaning summaries containing raw vectors (number of days, number of days deleted, number of prices, number of prices deleted, fraction of price deleted). The generated data files are stored in the current working directory with names `pricedata_<index>.mat`.

### II. Generate symbolic data from raw .csv data:
Uncompress all the files in `ppr/data/csv.gz` into a new directory, e.g., `ppr/data/csv`.
```
addpath('base');
addpath('l1spline');
Stat = run_gendata('ppr/data/csv');
```
`Stat` is a matrix of cleaning summaries containing raw vectors (number of days, number of days deleted, number of prices, number of prices deleted, fraction of price deleted). The generated data files are stored in the current working directory with names `data_<index>.mat`.

### III. Reproduce the simulated dataset
```
rng(373901508);
Xi = aqua_simdata_tc();
```

### IV. Reproduce simulation results in Table 1:
```
addpath('base');
addpath('apat');
mkdir('sim_result'); cd('sim_result');
aqua_simjob_tc('simdata_tc_lean.mat', 'aqua_sim_tc_<col>.mat', <col>);
```
Repeat the last line for all values of `<col>`, i.e., 1 to 1000. It is preferable to run `aqua_simjob_tc` as parallel jobs on a computing cluster using `sh/sub_aqua_sim.sh`.
```
[iSamp, M, S, L, U, AccRate, MapcVal] = aqua_joinsimjob('.');
[A, B, G, H, C] = aqua_simsumm(M);
```

### V. Reproduce posterior summary for S&P 500 in Table 4:
```
addpath('base');
addpath('apat');
addpath('ppr/data');
aqua_estjob_tc('data_spx.mat', 'estresult_aqua_spx.mat');
load('estresult_aqua_spx.mat');
[A, B, G, H, C] = aqua_postsumm(Theta);
```

### VI. Estimate Apatosaurus and truncated-skewed-t marginal models:
```
addpath('base');
addpath('apat');
addpath('ppr/data');
margin_estjob_h('data_spx.mat', 'estresult_h_spx.mat');
```

### VII. Reproduce the plots in Figures 4-10:
```
addpath('base');
addpath('ppr');
addpath('subaxis');
plot_xi;
plot_q1min;
plot_w;
plot_qq_h;
plot_rsig;
plot_var;
plot_s;
```

### VIIII. Reproduce the estimation results required for Figure 8:
```
addpath('base');
addpath('apat');
addpath('ppr/data');
aqua_estjob_tc('data_<index>.mat', 'estresult_aqua_<index>.mat');
```
Repeat the last line for all index identifiers `<index>`. It is preferable to run `aqua_estjob_tc` as parallel jobs on a computing cluster using `sh/sub_aqua_est.sh`.
```
run_genapatrsig('.');
```

### X. Reproduce DQF model forecasting results:
```
addpath('base);
addpath('apat');
addpath('ppr/data');
mkdir('fore_aqua_<index>'); cd('fore_aqua_<index>');
aqua_forejob_tc('data_<index>.mat', 'aqua.<index>.<a>-<b>.mat', '3050', '10', '<a>', '<b>');
```
The arguments `<a>` and `<b>` mark the starting and ending indices of the forecast sample. One can use `<a>` and `<b>` to partition the forecast sample, so that the last line can be parallelised. It is preferable to run `aqua_forejob_tc` as parallel jobs on a computing cluster using `sh/sub_aqua_fore.sh`.
```
run_joinforejob('.');
```
Repeat the block for all index identifiers `<index>`.

### XI. Reproducing benchmark model forecasting results:
```
addpath('base);
addpath('ppr/data');
caviar_sav_forejob('data_<index>.mat', 'caviar.<index>.3051-<b>.mat', '3050', '10', '3051', '<b>');
```
The argument `<b>` marks the ending index of the forecast sample, which varies across index identifiers `<index>`.
```
gjr_forejob_t('data_<index>.mat', 'gjrt.<index>.3051-<b>.mat', '3050', '10', '3051', '<b>');
gjr_forejob_skt('data_<index>.mat', 'gjrskt.<index>.3051-<b>.mat', '3050', '10', '3051', '<b>');
realgarch_forejob_t('data_<index>.mat', 'realt.<index>.3051-<b>.mat', '3050', '10', '3051', '<b>');
realgarch_forejob_skt('data_<index>.mat', 'realskt.<index>.3051-<b>.mat', '3050', '10', '3051', '<b>');
```
Repeat the block for all index identifiers `<index>`.

### XII. Reproduce the scoring function values in Tables 5 and 6:
```
addpath('base');
[T1, T5] = table_scoringfunc('ppr/result');
```

### XIII. Reproduce the DIC results in Table 7 in Appendix C:
```
addpath('base');
run_estjob_ar1('ppr/data');
```
Follow part VIIII to obtain estimation results for the full model.
```
run_dic('.');
```
