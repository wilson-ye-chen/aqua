/**
 * File: gjr_sigmasq.c
 * Purpose:
 * Evaluates the conditional variances of the GJR-GARCH model.
 *
 * Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
 * Date:   October 3, 2015
 */

#include <math.h>
#include "matrix.h"

#define SQUARE(x) ((x) * (x))

void eval_sigmasq(
    double* sigmaSq,
    const double omega,
    const double alpha1,
    const double alpha2,
    const double beta,
    const double sigmaSq0,
    const int nObs,
    const double* a);

void mexFunction(int nlhs, mxArray** plhs, int nrhs, const mxArray** prhs)
{
    double* sigmaSq;
    
    /* Input arguments */
    double  omega    = mxGetScalar(prhs[0]);
    double  alpha1   = mxGetScalar(prhs[1]);
    double  alpha2   = mxGetScalar(prhs[2]);
    double  beta     = mxGetScalar(prhs[3]);
    double  sigmaSq0 = mxGetScalar(prhs[4]);
    int     nObs     = mxGetNumberOfElements(prhs[5]);
    double* a        = mxGetPr(prhs[5]);
    
    /* Allocate output memory */
    plhs[0] = mxCreateDoubleMatrix((nObs + 1), 1, mxREAL);
    sigmaSq = mxGetPr(plhs[0]);
    
    /* Evaluate conditional variances */
    eval_sigmasq(sigmaSq, omega, alpha1, alpha2, beta, sigmaSq0, nObs, a);
    
    return;
}

void eval_sigmasq(
    double* sigmaSq,
    const double omega,
    const double alpha1,
    const double alpha2,
    const double beta,
    const double sigmaSq0,
    const int nObs,
    const double* a)
{
    int i;
    
    /* Evaluate conditional variances */
    sigmaSq[0] = sigmaSq0;
    for (i = 1; i <= nObs; i++)
    {
        /* Evaluate conditional variance */
        sigmaSq[i] =
            omega +
            alpha1 * SQUARE(a[i - 1]) +
            alpha2 * SQUARE(a[i - 1]) * (double)(a[i - 1] < 0) +
            beta * sigmaSq[i - 1];
    }
}
