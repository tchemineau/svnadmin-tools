#!/bin/bash

if [ "${__SCM_WRAPPER__:-}" != 'Loaded' ]; then

  __SCM_WRAPPER__='Loaded'

  # ---------------------------------------------------------------------------

  #
  # Load repository library
  #
  CONF_GET "REPOSITORY_TYPE"
  if [ -z "$(/bin/ls -1 ${DIRNAME}/lib/scm/${REPOSITORY_TYPE}.lib.sh)" ]; then
    echo "ERROR: Unable to find repository ${REPOSITORY_TYPE}"
    exit 2
  fi
  . "${DIRNAME}/lib/scm/${REPOSITORY_TYPE}.lib.sh"

  # ---------------------------------------------------------------------------

  #
  # Wrapper function to create a new repository
  #
  REPOSITORY_CREATE() {
    SCM_CREATE $*
  }

  #
  # Wrapper function to list available repositories
  #
  REPOSITORIES_LIST() {
    SCM_LIST $*
  }

fi # Loaded

