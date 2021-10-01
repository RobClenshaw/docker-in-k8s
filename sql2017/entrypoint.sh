#!/bin/bash

if [ "$(id -u)" = '0' ]; then
    # fix up ownership so mssql user can read and write
    [[ ! -z $MSSQL_DATA_DIR ]] && chown -R mssql $MSSQL_DATA_DIR
    [[ ! -z $MSSQL_LOG_DIR ]] && chown -R mssql $MSSQL_LOG_DIR
    [[ ! -z $MSSQL_BACKUP_DIR ]] && chown -R mssql $MSSQL_BACKUP_DIR
    [[ ! -z $MSSQL_MASTER_DATA_FILE ]] && chown -R mssql $MSSQL_MASTER_DATA_FILE
    [[ ! -z $MSSQL_MASTER_LOG_FILE ]] && chown -R mssql $MSSQL_MASTER_LOG_FILE
    [[ ! -z $MSSQL_ERROR_LOG_FILE ]] && chown -R mssql $MSSQL_ERROR_LOG_FILE

    chown -R mssql /var/opt/mssql

    # then restart script as mssql user
    exec gosu mssql "$BASH_SOURCE" "$@"
fi

/opt/mssql/bin/sqlservr $@