#!/bin/bash
#
# A bash directory stack "cd history" function.
#
# Copyright (C) 2010 Mark Blakeney, markb@berlios.de. This program is
# distributed under the terms of the GNU General Public License.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or any
# later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License at <http://www.gnu.org/licenses/> for more
# details.
#
# Install the following files:
# /usr/local/etc/bashrc_cdhist (this file),
# /usr/local/bin/cdhist.py.
# Ensure that CDHISTPROG_ in the bashrc_cdhist file points to cdhist.py.
#
# Then each user who wants to use the cdhist facility should source the
# bashrc_cdhist file into their bashrc, i.e from within ~/.bashrc just
# do a "source /usr/local/etc/bashrc_cdhist". There are 2 environment
# variables a user can choose to customise, see next 2 exports. Override
# these in ~/.bashrc before sourcing the bashrc_cdhist script.

# User option: Size of the directory stack
export CDHISTSIZE=${CDHISTSIZE:=31}

# User option: Set the following "TRUE" if you want your home directory
# displayed as a tilde ("~"). Else set FALSE, null, etc.
export CDHISTTILDE=${CDHISTTILDE:=TRUE}

# See help text in accompanying cdhist.py script for usage and more
# information (i.e. type "cd -h" after installation).

# Location of the cdhist.py program. E.g. CDHISTPROG_=/usr/local/bin/cdhist.py
CDHISTPROG_="/usr/bin/cdhist.py"

# Redefine user cd command for this session
alias cd=cd_
function cd_
{
    # Call the worker script to process the argument. The script will
    # return a (possibly different) string argument and a status to
    # indicate whether to proceed with the 'cd' or not.
    _d=`$CDHISTPROG_ -- "$@"`
    _r=$?

    if [ $_r -eq 1 ]; then
	return 0
    elif [ $_r -eq 0 ]; then
	'cd' "$_d"
    else
	'cd' $_d
    fi

    # If the 'cd' was successful then call the script again merely so it
    # can record the new working directory in the history stack.
    if [ $? -eq 0 ]; then
	$CDHISTPROG_ -u
    fi

    return $?
}