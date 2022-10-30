#!/bin/bash

###### WORKSPACE SETUP
# Used to setup workspace for Husarion
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
    if [[ `basename "$TEMP_PATH"` == "husarion_ws" ]]; then
        eval "$1='$TEMP_PATH'"
        log "Found workspace path: $PATH_WORKSPACE"
        break
      else
        TEMP_PATH=`dirname $TEMP_PATH`
    fi
  done
}

# Call catkin_make
build() {
	catkin_make -C $1
}

# Install ROS dependencies
getDeps() {
  PATH_SRC="$1/src"
	rosdep install --from-paths $PATH_SRC --ignore-src -r -y
}

# Clone repositories:
# - spotsim_hector: custom hector launches and params
# - spot_controller: control throught waypoints
cloneRepo() {
  PATH_SRC="$1/src"

  if [ ! -d "$PATH_SRC/spotsim_hector" ]; then
    git clone git@github.com:SpotSim-MR/spotsim_hector.git "$PATH_SRC/spotsim_hector"
  fi

  if [ ! -d "$PATH_SRC/spot_controller" ]; then
    git clone git@github.com:SpotSim-MR/spot_controller.git "$PATH_SRC/spot_controller"
  fi
}

# Main entrypoint
main ()
{
  # Get current shell
  DEFAULT_SHELL=`basename $SHELL`

  # ROS installation path (Noetic)
  PATH_ROS="/opt/ros/noetic"

  # The absolute path to the workspace
  PATH_WORKSPACE=""

  # Find the path of the workspace
  # NOTE: must be run first
  log "Finding workspace path"
  resolveWorkspacePath PATH_WORKSPACE

  # Check if ROS Noetic is installed
  if [ ! -d $PATH_ROS ]; then
    log "ROS Noetic is not installed"
    exit 1
  fi

  # Check if ROS Noetic setup.<shell> is sourced
  if [ `! command -v catkin_make &> /dev/null` ]; then
    log "ROS Noetic is not sourced"

    if [ "$DEFAULT_SHELL" = "bash" ]; then
	    log "Please run: source $PATH_ROS/setup.bash"
    elif [ "$DEFAULT_SHELL" = "zsh" ]; then
	    log "Please run: source $PATH_ROS/setup.zsh"
    else
	    log "Please run: source $PATH_ROS/setup.sh"
    fi
    exit 1
  fi

  # Create src directory if it does not exist
  if [ ! -d "$PATH_WORKSPACE/src" ]; then
    mkdir "$PATH_WORKSPACE/src" -p
  fi

  log "Init workshop"
  build $PATH_WORKSPACE

  log "Cloning repositories"
  cloneRepo $PATH_WORKSPACE

  log "Installing dependencies"
  resolveDeps $PATH_WORKSPACE

  log "Building"
  build $PATH_WORKSPACE

  log "Task finished! "
  PATH_DEVEL="$PATH_WORKSPACE/devel"
  if [ "$DEFAULT_SHELL" = "bash" ]; then
    log "Please run: source $PATH_DEVEL/setup.bash"
  elif [ "$DEFAULT_SHELL" = "zsh" ]; then
    log "Please run: source $PATH_DEVEL/setup.zsh"
  else
    log "Please run: source $PATH_DEVEL/setup.sh"
  fi
}

main
