#!/bin/bash

echo " Waiting for SQL Server to start..."
sleep 1

echo " Running schema and data scripts..."

/opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P 'StrongP@ssw0rd' -i /tmp/setup/schema.sql -N -C
/opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P 'StrongP@ssw0rd' -i /tmp/setup/load_data.sql -N -C
/opt/mssql-tools18/bin/sqlcmd -S localhost -U SA -P 'StrongP@ssw0rd' -i /tmp/setup/star.sql -N -C
echo "✅ SQL Server initialized and data loaded."
