#!/bin/bash

if [ "${__REPOSITORIES__:-}" != 'Loaded' ]; then

  __REPOSITORIES__='Loaded'

  REPOSITORIES_LIST() {

    CONF_GET "SVN_PARENT_PATH"
    /bin/ls -1 "${SVN_PARENT_PATH}"
  }

fi # Loaded

