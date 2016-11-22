#!/bin/bash

#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    ${SCRIPT_NAME} [ files ... ]
#%
#% DESCRIPTION
#%    This script opens a new frame in Emacs using emacsclient. If
#%    there is no Emacs instance running in server mode this script
#%    launches an Emacs instace in server mode.
#%
#%    When the Emacs server has to be launched a system notification
#%    is shown.
#%
#%    This script does not wait for the editor signalling that editing has
#%    finished. It directly returns afer opening the frame. If you require
#%    waiting please use emacsclient directly.
#%
#% OPTIONS
#%    -h, --help                    Print this help
#%    -v, --version                 Print script information
#%
#% EXAMPLES
#%    ${SCRIPT_NAME}
#%
#%        opens a frame displaying the *scratch* buffer
#%
#%    ${SCRIPT_NAME} test.txt
#%
#%        opens a frame displaying the file test.txt
#%
#================================================================
#- IMPLEMENTATION
#-    Version         0.0.1
#-    Author          Christoph D. Hermann
#-    Copyright       Copyright (c) http://www.itbh.at/
#-    License         GNU General Public License
#-
#================================================================
#  HISTORY
#     2016-11-18 : cdhermann : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================


# Running in Automator no PATH variable is available. This makes all
# required commands usable without providing the full paths to the
# executables.
source /etc/profile

# Socket file of Emacs running in server mode
# Detection based on http://stackoverflow.com/a/28553846/6114176
socket_file=$(lsof -c Emacs | grep server | tr -s " " | cut -d' ' -f8)

# Counter used while waiting for the Emacs server socket
COUNTER=0

# Checks 5 times every 5 seconds if a socket file is available.  If so
# the socket_file variable is set to the socket file and the return
# code is 0. Otherwise, the socket_file variable is set to the empty
# string and the return code is 1.
function is_server_up {
    socket_file=$(lsof -c Emacs | grep server | tr -s " " | cut -d' ' -f8)
    while [[ $socket_file == "" ]];
    do
        if [[ $COUNTER -gt 4 ]]; then
            socket_file=""
            return 1
        fi
        sleep 5s
        socket_file=$(lsof -c Emacs | grep server | tr -s " " | cut -d' ' -f8)
        (( COUNTER++ ))
    done
    return 0
}

if [[ $socket_file == "" ]]; then
    echo "Launching Emacs server ..."
    osascript -e 'display notification "This may take some time." with title "Launching Emacs server ..."'
    nohup emacs --eval '(server-start)' "$@" </dev/null >/dev/null 2>&1 &
    if is_server_up; then
        # return and indicate success
        exit 0
    else
        # inidcate error if server doesn't start up
        echo "Launching Emacs server failed."
        osascript -e 'display notification "Starting up Emacs server took to long." with title "Launching Emacs server failed."'
        exit 2
    fi
fi

echo "Opening Emacs frame ..."
emacsclient -n -c -s "$socket_file" "$@"
