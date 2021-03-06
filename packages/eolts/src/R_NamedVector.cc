// -*- mode: C++; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4; -*-
// vim: set shiftwidth=4 softtabstop=4 expandtab:
/*
 * 2013,2014, Copyright University Corporation for Atmospheric Research
 * 
 * This file is part of the "eolts" package for the R software environment.
 * The license and distribution terms for this file may be found in the
 * file LICENSE in this package.
 */
/*
 *  Description:
 *    Constructors for R_NamedVector of the various types
 * 
 */

#include "R_NamedVector.h"

using namespace eolts;

namespace eolts {

template class R_NamedVector<double>;
template class R_NamedVector<int>;
// template class R_NamedVector<char*>;

/**
 * Specialization of getDataPtr() for R_NamedVector<double>.
 */
template<>
double *R_NamedVector<double>::getDataPtr()
{
    return REAL(getRObject());
}

/**
 * Specialization of constuctor for R_NamedVector<double>.
 */
template<>
R_NamedVector<double>::R_NamedVector(int type,size_t length) :
	R_NamedVectorBase(REALSXP,length)
{
    double *fp = getDataPtr();
    double *fpend = fp + _length;
    for ( ; fp < fpend; ) *fp++ = NA_REAL;
}

/**
 * Specialization of constuctor for R_NamedVector<double>.
 */
template<>
R_NamedVector<double>::R_NamedVector(int type,SEXP obj) :
	R_NamedVectorBase(REALSXP,obj)
{
}

/**
 * Specialization of getDataPtr() for R_NamedVector<int>.
 */
template<>
int *R_NamedVector<int>::getDataPtr()
{
    return INTEGER(getRObject());
}

/**
 * Specialization of constuctor for R_NamedVector<int>.
 */
template<>
R_NamedVector<int>::R_NamedVector(int type, size_t length) :
	R_NamedVectorBase(type,length)
{
    int *fp = getDataPtr();
    int *fpend = fp + _length;
    if (type == INTSXP)
        for ( ; fp < fpend; ) *fp++ = NA_INTEGER;
    else if (type == LGLSXP)
        for ( ; fp < fpend; ) *fp++ = NA_LOGICAL;
}

/**
 * Specialization of constuctor for R_NamedVector<int>.
 */
template<>
R_NamedVector<int>::R_NamedVector(int type, SEXP obj) :
	R_NamedVectorBase(type,obj)
{
}

}   // namespace eolts
