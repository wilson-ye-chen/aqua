/**
 * File: realgarch_logsigmasq.c
 * Purpose:
 * Evaluates the log conditional variances of the Realised GARCH model.
 *
 * Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
 * Date:   September 24, 2015
 */

#include <math.h>
#include "matrix.h"

void eval_logsigmasq(
    double* logSigmaSq,
    const double omega,
    const double beta,
    const double gamma,
    const double logSigmaSq0,
    const int nObs,
    const double* logX);

void mexFunction(int nlhs, mxArray** plhs, int nrhs, const mxArray** prhs)
{
    double* logSigmaSq;
    
    /* Input arguments */
    double  omega       = mxGetScalar(prhs[0]);
    double  beta        = mxGetScalar(prhs[1]);
    double  gamma       = mxGetScalar(prhs[2]);
    double  logSigmaSq0 = mxGetScalar(prhs[3]);
    int     nObs        = mxGetNumberOfElements(prhs[4]);
    double* logX        = mxGetPr(prhs[4]);
    
    /* Allocate output memory */
    plhs[0] = mxCreateDoubleMatrix((nObs + 1), 1, mxREAL);
    logSigmaSq = mxGetPr(plhs[0]);
    
    /* Evaluate log conditional variances */
    eval_logsigmasq(logSigmaSq, omega, beta, gamma, logSigmaSq0, nObs, logX);
    
    return;
}

void eval_logsigmasq(
    double* logSigmaSq,
    const double omega,
    const double beta,
    const double gamma,
    const double logSigmaSq0,
    const int nObs,
    const double* logX)
{
    int i;
    
    logSigmaSq[0] = logSigmaSq0;
    for (i = 1; i <= nObs; i++)
    {
        logSigmaSq[i] =
            omega +
            beta * logSigmaSq[i - 1] +
            gamma * logX[i - 1];
    }
}
