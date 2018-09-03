/**
 * File: aqua_sigmasq.c
 * Purpose:
 * Evaluates the conditional variances of a mapped parameter in the
 * AQUA model.
 *
 * Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
 * Date:   January 14, 2015
 */

#include <math.h>
#include "matrix.h"

#define SQUARE(x) ((x) * (x))

void eval_sigmasq(
    double* sigmaSq,
    const double omega,
    const double alpha,
    const double beta,
    const double sigmaSq0,
    const int nObs,
    const double* m);

void mexFunction(int nlhs, mxArray** plhs, int nrhs, const mxArray** prhs)
{
    double* sigmaSq;
    
    /* Input arguments */
    double  omega    = mxGetScalar(prhs[0]);
    double  alpha    = mxGetScalar(prhs[1]);
    double  beta     = mxGetScalar(prhs[2]);
    double  sigmaSq0 = mxGetScalar(prhs[3]);
    int     nObs     = mxGetNumberOfElements(prhs[4]);
    double* m        = mxGetPr(prhs[4]);
    
    /* Allocate output memory */
    plhs[0] = mxCreateDoubleMatrix((nObs + 1), 1, mxREAL);
    sigmaSq = mxGetPr(plhs[0]);
    
    /* Evaluate conditional variances */
    eval_sigmasq(sigmaSq, omega, alpha, beta, sigmaSq0, nObs, m);
    
    return;
}

void eval_sigmasq(
    double* sigmaSq,
    const double omega,
    const double alpha,
    const double beta,
    const double sigmaSq0,
    const int nObs,
    const double* m)
{
    int i;
    
    sigmaSq[0] = sigmaSq0;
    for (i = 1; i <= nObs; i++)
    {
        sigmaSq[i] =
            omega +
            alpha * SQUARE(m[i - 1]) +
            beta * sigmaSq[i - 1];
    }
}
