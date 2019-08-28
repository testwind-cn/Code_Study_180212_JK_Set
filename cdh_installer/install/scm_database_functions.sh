#!/bin/bash
# Copyright (c) 2011-2012 Cloudera, Inc. All rights reserved.
#
# Function to help configure MySQL or PostgreSQL for SCM.

# Environment variables that the calling script must set.
# DB_TYPE
# DB_HOST
# DB_PORT
# DB_USER
# DB_PASSWORD
# SCM_DATABASE
# SCM_USER
# SCM_PASSWORD
# VERBOSE
# FORCE

verbose()
{
  if [[ $VERBOSE ]]; then
    $*
  fi
}

# Display an error and either fail or continue executing.
fail_or_continue()
{
  local RET=$1
  local STR=$2

  if [[ $RET -ne 0 ]]; then
    if [[ -z $STR ]]; then
      STR="--> Error $RET"
    fi
    if [[ -n $FORCE ]]; then
      echo "$STR, ignoring (because force flag is set)"
    else
      echo "$STR, giving up (use --force if you wish to ignore the error)"
      exit $RET
    fi
  fi
}

# Will "mkdir -p" on this path succeed? The following algorithm should tell us:
#
# Iterate over the path:
#   If the path exists:
#      If it is a directory and writable, return success.
#      Otherwise, return failure.
#   Remove the trailing component from the end.
#   Stop iterating when the path hasn't changed between loops.
check_can_mkdir_path()
{
  local DIRNAME=$1
  local OLD_DIRNAME

  while true; do
	  if [[ -e $DIRNAME ]]; then
      if [[ -d $DIRNAME && -w $DIRNAME ]]; then
      	return 0
      else
      	return 1
      fi
	  fi
	  OLD_DIRNAME=$DIRNAME
	  DIRNAME=`dirname $DIRNAME`
	  if [[ $DIRNAME = $OLD_DIRNAME ]]; then
      return 0
	  fi
  done
}
