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
  PROMPT=0

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

  CHECK svn

  #
  # Load libraries
  #

  SCRIPT_HELPER_DIRECTORY="${DIRNAME}/lib/ScriptHelper"
  LOAD __LIB_ASK__  "${SCRIPT_HELPER_DIRECTORY}/ask.lib.sh"
  LOAD __LIB_CLI__  "${SCRIPT_HELPER_DIRECTORY}/cli.lib.sh"
  LOAD __LIB_CONF__ "${SCRIPT_HELPER_DIRECTORY}/conf.lib.sh"

  #
  # Auto set some final parameters
  #

  CONF_SET_FILE "${DIRNAME}/etc/svntool.conf"

fi # Loaded

