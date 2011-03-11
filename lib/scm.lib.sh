#!/bin/bash

if [ "${__SCM_WRAPPER__:-}" != 'Loaded' ]; then

  __SCM_WRAPPER__='Loaded'

  # Load repository library
  CONF_GET "REPOSITORY_TYPE"
  if [ -z "$(/bin/ls -1 ${DIRNAME}/lib/repository/${REPOSITORY_TYPE}.lib.sh)" ]; then
    echo "ERROR: Unable to find repository ${REPOSITORY_TYPE}"
    exit 2
  fi
  . "${DIRNAME}/lib/repository/${REPOSITORY_TYPE}.lib.sh"

  # Wrapper function to list available repositories
  REPOSITORIES_LIST() {
    SCM_LIST $*
  }

fi # Loaded

