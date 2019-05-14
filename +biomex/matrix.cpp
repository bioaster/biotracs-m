
#include "matrix.h"

//using namespace std;


/*biocode::Matrix::Matrix( const size_t iNRows, const size_t iNCols ){
    this->m = iNRows;
    this->n = iNCols;
    this->data = (double*) calloc(iNRows*iNCols, sizeof(double));
    this->isOwnerOfData = true;
}*/

biocode::Matrix::Matrix( const size_t iNRows, const size_t iNCols ){
    this->m = iNRows;
    this->n = iNCols;
    size_t nbElements = iNRows*iNCols;
    this->data = mxMalloc(nbElements * sizeof(double)); //dynamic data allocation
    //mxGetPr(mxCreateDoubleMatrix( (mwSize)this->m, (mwSize)this->n, mxREAL));
}

biocode::Matrix::Matrix( double *iData, const size_t iNRows, const size_t iNCols ){
    this->m = iNRows;
    this->n = iNCols;
    this->data = iData;
}

biocode::Matrix::Matrix( const mxArray *iMxArray ){
    this->m = mxGetM(iMxArray);
    this->n = mxGetN(iMxArray);
    this->data = mxGetPr(iMxArray);
}

biocode::Matrix::Matrix( biocode::Matrix &iMatrix ){
    this->m = iMatrix.m;
    this->n = iMatrix.n;
    this->data = iMatrix.data;
}

// L

// T 

mxArray *biocode::Matrix::toMxArray(){
    mxArray *plhs = mxCreateDoubleMatrix(this->m, this->n, mxREAL);
    mxSetPr(plhs, this->data);
    return plhs;
}

// O

double &biocode::Matrix::operator()( const size_t i, const size_t j ){
    size_t index = ((this->m)*j) + i;
    return this->data[ index ];
}

biocode::Matrix &biocode::Matrix::operator*( const double val ){
    biocode::Matrix B = biocode::Matrix( this->data, this->m, this->n );
    for (size_t i=0; i<this->m; i++) {
        for (size_t j=0; j<this->n; j++) {
            B(i,j) = (*this)(i,j) * val;
        }
    }
    return B;
}

Matrix &operator=( biocode::Matrix &iMatrix ){
    return biocode::Matrix(iMatrix); 
}