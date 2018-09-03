/**
 * File: caviar_sav_q.c
 * Purpose:
 * Evaluates the conditional quantiles of the symmetric absolute value (SAV)
 * CAViaR model.
 *
 * Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
 * Date:   September 14, 2015
 */

#include <math.h>
#include "matrix.h"

void eval_q(
    double* q,
    const double b1,
    const double b2,
    const double b3,
    const double q0,
    const int nObs,
    const double* y);

void mexFunction(int nlhs, mxArray** plhs, int nrhs, const mxArray** prhs)
{
    double* q;
    
    /* Input arguments */
    double  b1   = mxGetScalar(prhs[0]);
    double  b2   = mxGetScalar(prhs[1]);
    double  b3   = mxGetScalar(prhs[2]);
    double  q0   = mxGetScalar(prhs[3]);
    int     nObs = mxGetNumberOfElements(prhs[4]);
    double* y    = mxGetPr(prhs[4]);
    
    /* Allocate output memory */
    plhs[0] = mxCreateDoubleMatrix((nObs + 1), 1, mxREAL);
    q = mxGetPr(plhs[0]);
    
    /* Evaluate conditional quantiles */
    eval_q(q, b1, b2, b3, q0, nObs, y);
    
    return;
}

void eval_q(
    double* q,
    const double b1,
    const double b2,
    const double b3,
    const double q0,
    const int nObs,
    const double* y)
{
    int i;
    
    q[0] = q0;
    for (i = 1; i <= nObs; i++)
    {
        q[i] = b1 + b2 * q[i - 1] + b3 * fabs(y[i - 1]);
    }
}
