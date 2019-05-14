
#ifndef __BIOCODE_MATRIX__
#define __BIOCODE_MATRIX__

#include <vector>
#include "mex.h"

namespace biocode{
    
struct Matrix{
public:
    
    //Constructor
    Matrix( const size_t iNrows, const size_t iNcols );
    Matrix( double *iData, const size_t iNrows, const size_t iNcols );
    Matrix( const mxArray *iData );
    Matrix( Matrix& );
    
    //toMatlab();
    //fromMatlab();
    
    //Destructor
    ~Matrix(){};
    
    // G
    
    double *getPtr(){ return this->data; }
    
    // L
    
    size_t length(){ return this->m * this->n; }
    
    // N
    
    size_t nrows(){ return this->m; }
    size_t ncols(){ return this->n; }
    
    // T 
    
    mxArray *toMxArray();
    
    // O
    
    double &operator()( size_t i, size_t j);
    Matrix &operator*( const double );
    Matrix &operator=( mxArray& );
    
private:
    double *data;
    size_t m;
    size_t n;
    bool isOwnerOfData;
};

};
#endif