#!/bin/bash

###### CLEAN
# Used to clean folders and files (generated through scripts)
#
# Author: nivratig

# Formatted log with datetime
log() {
  DATE="[`date +"%T"]` $1"
  echo "$DATE"
}

# Resolve workspace path
resolveWorkspacePath() {
  # The absolute path to the script
  PATH_SETUP_SCRIPT=`realpath $0`

  LOOP_THRESHOLD=5
  TEMP_PATH=$PATH_SETUP_SCRIPT
  while (( --LOOP_THRESHOLD >= 0 )); do
    if [[ `basename "$TEMP_PATH"` == "spot_ws" ]]; then
        eval "$1='$TEMP_PATH'"
        log "Found workspace path: $PATH_WORKSPACE"
        break
      else
        TEMP_PATH=`dirname $TEMP_PATH`
    fi
  done
}

# Main entrypoint
main() {
  # The absolute path to the workspace
  PATH_WORKSPACE=""

  # Find the path of the workspace
  # NOTE: must be run first
  log "Finding workspace path"
  resolveWorkspacePath PATH_WORKSPACE

  log "Deleting files"
  if [ -d "$PATH_WORKSPACE/build" ]; then rm -rf "$PATH_WORKSPACE/build"; fi
  if [ -d "$PATH_WORKSPACE/devel" ]; then rm -rf "$PATH_WORKSPACE/devel"; fi
  if [ -f "$PATH_WORKSPACE/.catkin_workspace" ];then rm "$PATH_WORKSPACE/.catkin_workspace"; fi

  PATH_SRC="$PATH_WORKSPACE/src"
  if [ -d "$PATH_SRC/hector_slam" ];then rm -rf "$PATH_SRC/hector_slam"; fi
  if [ -d "$PATH_SRC/spotsim_hector" ];then rm -rf "$PATH_SRC/spotsim_hector"; fi
  if [ -d "$PATH_SRC/spot_controller" ];then rm -rf "$PATH_SRC/spot_controller"; fi
  if [ -f "$PATH_SRC/CMakeLists.txt" ];then rm  "$PATH_SRC/CMakeLists.txt"; fi
  log "Files deleted"
}

main
