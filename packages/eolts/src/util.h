// -*- mode: C++; indent-tabs-mode: nil; c-basic-offset: 4; tab-width: 4; -*-
// vim: set shiftwidth=4 softtabstop=4 expandtab:
/*
 *               Copyright (C) by UCAR
 * 
 *  $Revision: 1.2 $
 *  $Date: 2004/02/11 17:15:24 $
 * 
 *  Description:
 *    Useful functions.
 * 
 */
#include <vector>
#include <string>

#include <stdlib.h>

namespace eolts {

std::string dimToString(const size_t* d, size_t nd);
std::string dimToString(const ssize_t* d, size_t nd);

std::string dimToString(const std::vector<size_t>&d);
std::string dimToString(const std::vector<ssize_t>&d);

std::string rModeToString(int rmode);

int sizeOfRMode(int mode);

}   // namespace eolts

