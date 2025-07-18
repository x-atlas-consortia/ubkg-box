#!/bin/bash
# -------------------------
# Unified Biomedical Knowledge Graph (UBKG)
# Build a Zip archive for a UBKGBox distribution.
#


###########
# Help function
##########
Help()
{
   # Display Help
   echo ""
   echo "****************************************"
   echo "HELP: UBKGBox Zip distribution build script"
   echo "Builds a Zip distribution of the UBKGBox instance from content in the current directory."
   echo
   echo "Syntax: ./build_ubkgbox_distribution_zip.sh [-c config file]"
   echo "options (in any order)"
   echo "-c   path to config file containing properties for the UBKG turnkey distribution (REQUIRED: default='container.cfg'."
   echo "-h   print this help"
   echo "Review container.cfg.example for descriptions of parameters."
}
##############################
# Set defaults.
config_file="container.cfg"
container_name="ubkg-neo4j"

# Default relative paths
# Get relative path to current directory.
base_dir="$(dirname -- "${BASH_SOURCE[0]}")"
# Convert to absolute path.
base_dir="$(cd -- "$base_dir" && pwd -P;)"

##############################
# PROCESS OPTIONS
while getopts ":hc:" option; do
  case $option in
    h) # display Help
      Help
      exit;;
    c) # config file
      config_file=$OPTARG;;
    \?) # Invalid option
      echo "Error: Invalid option"
      exit;;
  esac
done

##############################
# READ PARAMETERS FROM CONFIG FILE.

if [ "$config_file" == "" ]
then
  echo "Error: No configuration file specified. This script obtains parameters from a configuration file."
  echo "Either accept the default (container.cfg) or specify a file name using the -c flag."
  exit;
fi
if [ ! -e "$config_file" ]
then
  echo "Error: no config file '$config_file' exists."
  exit 1;
else
  source "$config_file";
fi

echo ""
echo "**********************************************************************"
echo "Stopping the neo4j service in the UBKGBox back-end container..."
# Stopping the container shuts down the neo4j server so that the data in the external bind mount is stable prior
# to copying.
# Piping with true results in success even if the container is not running.
# Stop the neo4j database
echo "Stopping the neo4j instance inside the neo4j container..."
docker exec "neo4j" \
bash -c "./neo4j stop" || true
echo "Stopping the neo4j container..."
docker stop "neo4j" || true

# A UBKGBox distribution consists of:
# 1. The external volume for the neo4j instance hosted by the back end component.
# 2. The external volume api_config.
# 3. build_ubkgbox.sh - the build script
# 4. add_subnodes_to_host.sh - used by build_ubkgbox.sh
# 5. ubkgbox-docker-compose.yml - the Docker Compose file
# 6. swagger-initializer.js - the custom initialization file for the swagger component
# 7. container.cfg - the configuration file for the neo4j back end.

echo "Building file UBKGBox.zip."
zip -9 -r "UBKGBox.zip" data/
zip -9 -r "UBKGBox.zip" api_cfg/
zip -9 "UBKGBox.zip" build_ubkgbox.sh
zip -9 "UBKGBox.zip" add_subnodes_to_host.sh
zip -9 "UBKGBox.zip" ubkgbox-docker-compose.yml
zip -9 "UBKGBox.zip" swagger-initializer.js
zip -9 "UBKGBox.zip" container.cfg

echo "The UBKGBox distribution is available in UBKGBox.zip."
