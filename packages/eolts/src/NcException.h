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
 *    General exception for errors encountered while accessing a NetCDF file.
 * 
 */

#ifndef NCEXCEPTION_H
#define NCEXCEPTION_H

#include <string>

namespace eolts {

class NcFile;
class NcVar;

class NcException : public std::exception {

public:
    NcException();
    NcException(const std::string& filename, const std::string& msg);
    NcException(const std::string& op,const std::string& fname, int status);
    NcException(const std::string& op,const std::string& fname,
            const std::string& vname, int status);

    virtual ~NcException() noexcept {}

    const std::string& toString() const { return _what; }

    const char* what() const noexcept { return _what.c_str(); }

    int getStatus() const { return _status; }

protected:
    std::string _what;
    int _status;

};

}   // namespace eolts

#endif

