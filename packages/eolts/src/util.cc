// -*- mode: C++; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4; -*-
// vim: set shiftwidth=4 softtabstop=4 expandtab:
/*
 *               Copyright (C) by UCAR
 * 
 *  $Revision: 1.8 $
 *  $Date: 2004/02/12 01:46:45 $
 * 
 *  Description:
 *    Useful functions.
 * 
 */

#include <sstream>

#include "util.h"

#include <Rinternals.h>

using std::vector;
using std::string;

/**
 * Convert a dimension vector to a string - for debugging or error reporting.
 */
string eolts::dimToString(const size_t* d, size_t nd)
{
    std::ostringstream ost;
    for (size_t i = 0; i < nd; i++) {
        if (i > 0) ost << ',';
        ost << d[i];
    }
    return ost.str();
}

string eolts::dimToString(const ssize_t* d, size_t nd)
{
    std::ostringstream ost;
    for (size_t i = 0; i < nd; i++) {
        if (i > 0) ost << ',';
        ost << d[i];
    }
    return ost.str();
}


string eolts::dimToString(const vector<size_t>& d)
{
    return dimToString(&d.front(),d.size());
}

string eolts::dimToString(const vector<ssize_t>& d)
{
    return dimToString(&d.front(),d.size());
}

string eolts::rModeToString(int rmode) {
    switch (rmode) {
    case INTSXP:
        return "integer";
    case REALSXP:
        return "double";
    case STRSXP:
        return "character";
    default:
        return "unknown";
    }
}

int eolts::sizeOfRMode(int mode)
{
    switch(mode) {
    case INTSXP:
        return sizeof(int);
    case REALSXP:
        return sizeof(double);
    case STRSXP:
        return sizeof(char *);
    default:
        {
            std::ostringstream ost;
            ost << "sizeOfRMode, programmer's error, unknown R type " << mode;
            error(ost.str().c_str());
        }
        return 0;
    }
}

