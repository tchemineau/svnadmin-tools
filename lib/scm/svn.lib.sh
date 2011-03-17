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

  #
  # Function to check environnement
  #
  SCM_CHECK() {
    CHECK svn
    CHECK svnadmin
    CHECK svnsync
  }

  #
  # Function to copy an existing repository
  #
  SCM_COPY() {
    svn checkout file://"${SVN_PARENT_PATH}/${name}" "${TEMPDIR}/${name}"
    mkdir -p "${TEMPDIR}/${name}/tags/"{application,configuration}
    mkdir -p "${TEMPDIR}/${name}/tags/configuration/"{integration,production}
    svn add "${TEMPDIR}/${name}"/tags
    svn commit -m 'Initialize structure' "${TEMPDIR}/${name}/tags/"
    rm -rf "${TEMPDIR}/${name}"
    return
  }

  #
  # Function to create a new repository
  #
  SCM_CREATE() {
    local name=

    name="$1"
    if [ -n "$(/bin/ls -1 "${SVN_PARENT_PATH}" | grep ${name})" ]; then
      MESSAGE "Repository already exists"
      return
    fi

    svnadmin create "${SVN_PARENT_PATH}/${name}"
    if [ !$? ]; then
      MESSAGE "Unable to create repository"
      return
    fi

    chown -R ${SVN_PERMISSION} "${SVN_PARENT_PATH}/${name}"
    MESSAGE "Successfull repository created"
  }

  #
  # Function to delete an existing repository
  #
  SCM_DELETE() {
    local name=

    name="$1"
    if [ -z "$(/bin/ls -1 "${SVN_PARENT_PATH}" | grep ${name})" ]; then
      MESSAGE "Repository does not exist"
      return
    fi

    rm -rf "${SVN_PARENT_PATH}/${name}"
    if [ !$? ]; then
      MESSAGE "Unable to delete repository"
      return
    fi

    MESSAGE "Successfull repository deleted"
  }

  #
  # Function to print information about an existing repository
  #
  SCM_INFO() {
    local name=

    name="$1"
    if [ -z "$(/bin/ls -1 "${SVN_PARENT_PATH}" | grep ${name})" ]; then
      MESSAGE "Repository does not exist"
      return
    fi

    svn info file://"${SVN_PARENT_PATH}/${name}"
  }

  #
  # Function to initialize an existing repository
  #
  SCM_INIT () {
    local name=

    name="$1"
    if [ -z "$(/bin/ls -1 "${SVN_PARENT_PATH}" | grep ${name})" ]; then
      MESSAGE "Repository does not exist"
      return
    fi

    svn checkout file://"${SVN_PARENT_PATH}/${name}" "${TEMPDIR}/${name}"
    mkdir -p "${TEMPDIR}/${name}/tags/"{application,configuration}
    mkdir -p "${TEMPDIR}/${name}/tags/configuration/"{integration,production}
    svn add "${TEMPDIR}/${name}"/tags
    svn commit -m 'Initialize structure' "${TEMPDIR}/${name}/tags/"
    rm -rf "${TEMPDIR}/${name}"
  }

  #
  # Function to list available repositories
  #
  SCM_LIST() {
    /bin/ls -1 "${SVN_PARENT_PATH}"
  }

fi # Loaded

