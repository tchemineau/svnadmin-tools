#!/bin/bash

if [ "${__SCM__:-}" != 'Loaded' ]; then

  __SCM__='Loaded'

  # ---------------------------------------------------------------------------

  #
  # Load configuration parameters
  #
  CONF_GET "SVN_PARENT_PATH"

  #
  # Test parameters
  #
  if [ -z "${SVN_PARENT_PATH}" ]; then
    echo "ERROR: configuration parameter not defined: SVN_PARENT_PATH"
    exit 2
  fi

  #
  # Auto calculate some parameters
  #
  SVN_PERMISSION="$(stat -c %U:%G ${SVN_PARENT_PATH})"

  # ---------------------------------------------------------------------------

  # Function to create a new repository
  SCM_CREATE() {
    local name=

    name="$1"

    if [ -n "$(/bin/ls -1 "${SVN_PARENT_PATH}" | grep ${name})" ]; then
      MESSAGE "Repository already exists"
    else
      svnadmin create "${SVN_PARENT_PATH}/${name}"
      chown -R ${SVN_PERMISSION} "${SVN_PARENT_PATH}/${name}"
    fi
  }

  # Function to list available repositories
  SCM_LIST() {
    /bin/ls -1 "${SVN_PARENT_PATH}"
  }

fi # Loaded

