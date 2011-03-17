#!/bin/bash

if [ "${__LOADER__:-}" != 'Loaded' ]; then

  __LOADER__='Loaded'

  # ---------------------------------------------------------------------------

  #
  # Constants
  #
  DIRNAME="$(dirname "$0")"
  SCRIPTNAME="$(basename "$0")"
  FILENAME="$(cd ${DIRNAME} 2>/dev/null && /bin/pwd)/${SCRIPTNAME}"
  HOSTNAME="$(hostname)"
  CURRDIR="$(/bin/pwd)"
  ROOTDIR="$(dirname "$(dirname "${FILENAME}")")"
  TEMPDIR="/tmp/svntool"
  PROMPT=0

  # ---------------------------------------------------------------------------

  #
  # Function to check commands
  #
  CHECK() {
    local cmd=

    cmd="$1";

    if [ -z "$(/bin/which ${cmd})" ]; then
      echo "ERROR: Unable to find command ${cmd}"
      exit 2
    fi
    return 0;
  }

  #
  # Print headers
  #
  CLI_HEADER() {
    local force=

    force=$1

    if [ "${PROMPT}" == "0" -a "${force}" != "0" ]; then
      BR
      return
    fi

    BR
    MSG "Subversion administration tools"
    MSG "By Thomas Chemineau <thomas.chemineau@gmail.com>"
    BR
    MSG "Use 'help' command to list all avariable commands"
    BR
  }

  #
  # Main interpreter
  #
  CLI_RUN_SVNTOOL() {

    if [ "$#" != "0" ]; then
      PROMPT=1
      CLI_RUN_COMMAND $*
    else
      CLI_HEADER 0
      CLI_RUN
    fi
    return 0
  }

  # ---------------------------------------------------------------------------

  #
  # Load libraries by invoking the helper
  #
  . "${ROOTDIR}/lib/helper.lib.sh"

  #
  # Create temporary directory
  #
  if [ ! -d "${TEMPDIR}" ]; then
    mkdir "${TEMPDIR}"
  fi
  if [ ! -w "${TEMPDIR}" ]; then
    echo "ERROR: Unable to write to ${TEMPDIR}"
    exit 2
  fi

  #
  # Auto set some final parameters
  #
  CONF_SET_FILE "${ROOTDIR}/etc/svntool.conf"

fi # Loaded

