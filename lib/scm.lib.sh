#!/bin/bash

if [ "${__SCM_WRAPPER__:-}" != 'Loaded' ]; then

  __SCM_WRAPPER__='Loaded'

  # ---------------------------------------------------------------------------

  #
  # Load repository library
  #
  CONF_GET "REPOSITORY_TYPE"
  if [ -z "$(/bin/ls -1 ${ROOTDIR}/lib/scm/${REPOSITORY_TYPE}.lib.sh)" ]; then
    echo "ERROR: Unable to find repository ${REPOSITORY_TYPE}"
    exit 2
  fi
  . "${ROOTDIR}/lib/scm/${REPOSITORY_TYPE}.lib.sh"

  #
  # Launch auto checks
  #
  SCM_CHECK

  # ---------------------------------------------------------------------------

  #
  # Wrapper function to copy a remote repository
  #
  REPOSITORY_COPY() {
    SCM_COPY $*
  }

  #
  # Wrapper function to create a new repository
  #
  REPOSITORY_CREATE() {
    SCM_CREATE $*
  }

  #
  # Wrapper function to delete an existing directory
  #
  REPOSITORY_DELETE() {
    SCM_DELETE $*
  }

  #
  # Wrapper function to print information of an existing repository
  #
  REPOSITORY_INFO() {
    SCM_INFO $*
  }

  #
  # Wrapper function to initialize an existing repository
  #
  REPOSITORY_INIT() {
    SCM_INIT $*
  }

  #
  # Wrapper function to list available repositories
  #
  REPOSITORIES_LIST() {
    SCM_LIST $*
  }

fi # Loaded

