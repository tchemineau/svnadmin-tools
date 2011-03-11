#!/bin/bash

if [ "${__SCM__:-}" != 'Loaded' ]; then

  __SCM__='Loaded'

  SCM_LIST() {

    CONF_GET "SVN_PARENT_PATH"
    /bin/ls -1 "${SVN_PARENT_PATH}"
  }

fi # Loaded

