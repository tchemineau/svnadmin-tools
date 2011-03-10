#!/bin/bash

if [ "${__LOADER__:-}" != 'Loaded' ]; then

  __LOADER__='Loaded'

  #
  # Constants
  #

  DIRNAME="$(dirname "$0")"
  SCRIPTNAME="$(basename "$0")"
  FILENAME="$(cd ${DIRNAME} 2>/dev/null && /bin/pwd)/${SCRIPTNAME}"
  DIRNAME="$(dirname "$(dirname "${FILENAME}")")"
  HOSTNAME="$(hostname)"

  #
  # Main interpreter
  #

  CLI_RUN_SVNTOOL() {

    if [ "$#" != "0" ]; then
      CLI_RUN_COMMAND $*
    else
     CLI_RUN
    fi
    return 0
  }

  #
  # Function to load libraries
  #

  LOAD() {
    local var= value= file=

    var="$1"; file="$2"
    value=$( eval "echo \"\${${var}:-}\"" )

    [ -n "${value}" ] && return 1;
    if [ -f "${file}" ]; then
      . "${file}"
    else
      echo "ERROR: Unable to load ${file}"
      exit 2
    fi
    return 0;
  }

  #
  # Perform some require checks
  #

  . "${DIRNAME}/lib/checks.lib.sh"

  #
  # Load libraries
  #

  SCRIPT_HELPER_DIRECTORY="${DIRNAME}/lib/ScriptHelper"
  LOAD __LIB_ASK__  "${SCRIPT_HELPER_DIRECTORY}/ask.lib.sh"
  LOAD __LIB_CLI__  "${SCRIPT_HELPER_DIRECTORY}/cli.lib.sh"

fi # Loaded

