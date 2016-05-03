#!/bin/bash

# looks like this must be hard coded since the directory structure here is different than the conda package
# tried to emulate it below but couldn't figure it out yet
export ORACLE_HOME='/Users/jsandhu/Documents/projects/oracle/oracle-instantclient/instantclient_11_2'

# how should ORACLE_HOME be set if I conda install the client binaries using:
#   conda install -c jsandhu oracle-instantclient=11.2.0.4.0
echo $ORACLE_HOME
$PYTHON setup.py install

# Add more build steps here, if they are necessary.

# See
# http://docs.continuum.io/conda/build.html
# for a list of environment variables that are set during the build process.
