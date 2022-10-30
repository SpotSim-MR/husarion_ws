#!/bin/bash

###### Dependencies Installation
# Used to get dependencies for Husarion
#
# Author: nivratig

# Get current shell
DEFAULT_SHELL= basename $SHELL

# Formatted log
log() {
  DATE="[`date +"%T"]` $1"
  echo "$DATE"
}

# Install the required dependencies for pre-setup
getDeps() {
  sudo apt install ros-kinetic-hector-slam
}

# Main entrypoint
main() {
  log "Get required dependencies..."
  getDeps

  log "Finished"
}

main
