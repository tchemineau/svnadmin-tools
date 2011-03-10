#!/bin/bash

if [ "${__CHECKS__:-}" != 'Loaded' ]; then

  __CHECKS__='Loaded'

  CHECK() {
    local cmd=

    cmd="$1";

    if [ -z "$(/bin/which ${cmd})" ]; then
      echo "ERROR: Unable to find command ${cmd}"
      exit 2
    fi
    return 0;
  }

  CHECK svn

fi # Loaded

