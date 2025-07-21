FROM mcr.microsoft.com/mssql/server:2022-latest

ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=StrongP@ssw0rd
ENV MSSQL_PID=Developer

# Make a writable setup directory
RUN mkdir -p /tmp/setup/data

# Copy your SQL and CSVs into safe place
COPY *.csv /tmp/setup/data/
COPY schema.sql load_data.sql /tmp/setup/
COPY init.sh /tmp/setup/init.sh


# Start SQL Server and run init script
CMD ["/bin/bash", "-c", "/opt/mssql/bin/sqlservr & sleep 20 && /tmp/setup/init.sh && tail -f /dev/null"]


