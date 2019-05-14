#include "mex.h"
#include "matrix.h"
#include <iostream>

/*
 * xtimesy.c - example found in API guide
 *
 * multiplies an input scalar times an input matrix and outputs a
 * matrix 
 *
 * This is a MEX-file for MATLAB.
 * Copyright 1984-2011 The MathWorks, Inc.
 */


mxArray *xtimesy(double x, double *y, double *z, size_t m, size_t n)
{
    biocode::Matrix mY = biocode::Matrix( y, m, n );
    //biocode::Matrix mZ = biocode::Matrix( z, m, n );
    biocode::Matrix mZ = mY * x;
    //return mZ.toMxArray();
    //z = mZ.getPtr();
    return mZ.toMxArray();
}
        
/*void xtimesy(double x, double *y, double *z, size_t m, size_t n)
{
  mwSize i,j,count=0;
  
  biocode::Matrix mZ = biocode::Matrix( z, m, n );
  biocode::Matrix mY = biocode::Matrix( y, m, n );
  
  for (i=0; i<m; i++) {
    for (j=0; j<n; j++) {
        mZ(i,j) = x * mY(i,j);
    }
  }
}*/

/* the gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
  double *y,*z;
  double  x;
  size_t mrows,ncols;
  
  /*  check for proper number of arguments */
  /* NOTE: You do not need an else statement when using mexErrMsgIdAndTxt
     within an if statement, because it will never get to the else
     statement if mexErrMsgIdAndTxt is executed. (mexErrMsgIdAndTxt breaks you out of
     the MEX-file) */
  if(nrhs!=2) 
    mexErrMsgIdAndTxt( "MATLAB:xtimesy:invalidNumInputs",
            "Two inputs required.");
  if(nlhs!=1) 
    mexErrMsgIdAndTxt( "MATLAB:xtimesy:invalidNumOutputs",
            "One output required.");
  
  /* check to make sure the first input argument is a scalar */
  if( !mxIsDouble(prhs[0]) || mxIsComplex(prhs[0]) ||
      mxGetN(prhs[0])*mxGetM(prhs[0])!=1 ) {
    mexErrMsgIdAndTxt( "MATLAB:xtimesy:xNotScalar",
            "Input x must be a scalar.");
  }
  
  /*  get the scalar input x */
  x = mxGetScalar(prhs[0]);
  
  /*  create a pointer to the input matrix y */
  y = mxGetPr(prhs[1]);
  
  /*  get the dimensions of the matrix input y */
  mrows = mxGetM(prhs[1]);
  ncols = mxGetN(prhs[1]);
  
  /*  set the output pointer to the output matrix */
  //plhs[0] = mxCreateDoubleMatrix( (mwSize)mrows, (mwSize)ncols, mxREAL);
  
  /*  create a C pointer to a copy of the output matrix */
  //z = mxGetPr(plhs[0]);
  
  /*  call the C subroutine */
  //xtimesy(x,y,z,mrows,ncols);
  
  plhs[0] = xtimesy(x, y, z, mrows, ncols);
  
  //plhs[0] = xtimesy(x, prhs[1]);
}
