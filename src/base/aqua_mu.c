/**
 * File: aqua_mu.c
 * Purpose:
 * Evaluates the conditional means of a mapped parameter in the
 * AQUA model.
 *
 * Author: Wilson Ye Chen <yche5077@uni.sydney.edu.au>
 * Date:   February 4, 2015
 */

#include <math.h>
#include "matrix.h"

void eval_mu(
    double* mu,
    const double delta,
    const double psi,
    const double phi,
    const double mu0,
    const int nObs,
    const double* xi);

void mexFunction(int nlhs, mxArray** plhs, int nrhs, const mxArray** prhs)
{
    double* mu;
    
    /* Input arguments */
    double  delta = mxGetScalar(prhs[0]);
    double  psi   = mxGetScalar(prhs[1]);
    double  phi   = mxGetScalar(prhs[2]);
    double  mu0   = mxGetScalar(prhs[3]);
    int     nObs  = mxGetNumberOfElements(prhs[4]);
    double* xi    = mxGetPr(prhs[4]);
    
    /* Allocate output memory */
    plhs[0] = mxCreateDoubleMatrix((nObs + 1), 1, mxREAL);
    mu = mxGetPr(plhs[0]);
    
    /* Evaluate conditional means */
    eval_mu(mu, delta, psi, phi, mu0, nObs, xi);
    
    return;
}

void eval_mu(
    double* mu,
    const double delta,
    const double psi,
    const double phi,
    const double mu0,
    const int nObs,
    const double* xi)
{
    int i;
    
    mu[0] = mu0;
    for (i = 1; i <= nObs; i++)
    {
        mu[i] =
            delta +
            psi * xi[i - 1] +
            phi * mu[i - 1];
    }
}
