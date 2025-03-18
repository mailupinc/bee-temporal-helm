#!/bin/sh
if [ "$1" = "" ]
then
  echo "You need to specify an environment"
  exit
fi

SCRIPT_NAME=$( basename $0 )
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
PRJ_DIR="$( cd "${SCRIPT_DIR}/.." && pwd )"
PRJ_NAME=$( basename ${PRJ_DIR} )

echo "** Running $SCRIPT_NAME in project $PRJ_NAME **"

env="${1:-}"

if [ -f "$PRJ_DIR/.envs/$env" ]; then
    source "$PRJ_DIR/.envs/$env"
else
    echo "Environment file not found"
    exit
fi

export SQL_PLUGIN=postgres12
export SQL_HOST=$TEMPORAL_DEFAULT_DB_HOST
export SQL_PORT=5432
export SQL_USER=$TEMPORAL_DEFAULT_DB_USER
export SQL_PASSWORD=$TEMPORAL_DEFAULT_DB_PASSWORD
export SQL_DATABASE=temporal 

# If TEMPORAL_REPO_HOME is defined in the environment file, use it, otherwise use the default value, which suppose that the temporal repo is in the same directory as the project
if [ -z "$TEMPORAL_REPO_HOME" ]; then
    TEMPORAL_REPO_HOME="$PRJ_DIR/../temporal" 
fi

{
    # Change to the directory specified by TEMPORAL_REPO_DIR
    cd "$TEMPORAL_REPO_HOME" || { echo "Failed to change directory to $TEMPORAL_REPO_HOME"; exit 1; }
    TEMPORAL_SQL_TOOL="./temporal-sql-tool"

    if [ -x "$TEMPORAL_SQL_TOOL" ]; then
        echo "Temporal SQL Tool found"
        echo "Updating main postgresql schema"
        "$TEMPORAL_SQL_TOOL" --tls --tls-disable-host-verification update -schema-dir schema/postgresql/v12/temporal/versioned
        echo "Main postgresql schema updated"
    else
        echo ''
        echo "Temporal SQL Tool not found at $TEMPORAL_REPO_HOME please set the path the temporal repo, and build the tool with 'make temporal-sql-tool'"
        echo ''
    fi
}
