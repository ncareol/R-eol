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
 *    A class that allows creating an Splus named vector from c++.
 * 
 */
#ifndef R_NAMEDVECTORBASE_H
#define R_NAMEDVECTORBASE_H

#include <R.h>
#include <Rinternals.h>

#include <vector>
#include <string>

namespace eolts {

class R_NamedVectorBase {
protected:
    SEXP _obj;
    int _type;
    size_t _length;
    PROTECT_INDEX _pindx;
    SEXP _names;

public:

    R_NamedVectorBase(int type,size_t length);
    R_NamedVectorBase(int type,SEXP);
    virtual ~R_NamedVectorBase();

    SEXP getRObject() { return _obj; }

    int getType() const
    {
        return _type;
    }

    virtual int getSizeOfT() = 0;

    void setNames(const std::vector<std::string>&);
    std::vector<std::string> getNames();

    size_t getLength() const
    {
        return _length;
    }

    void setLength(size_t);

private:
    // declared private to prevent copying and assignment
    R_NamedVectorBase(const R_NamedVectorBase &);
    R_NamedVectorBase &operator=(const R_NamedVectorBase &);


};

}   // namespace eolts

#endif
