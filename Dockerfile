FROM mcr.microsoft.com/mssql/server:2022-latest

ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=StrongP@ssw0rd
ENV MSSQL_PID=Developer

RUN mkdir -p /tmp/setup/data

COPY *.csv /tmp/setup/data/
COPY schema.sql load_data.sql /tmp/setup/
COPY init.sh /tmp/setup/init.sh


CMD ["/bin/bash", "-c", "/opt/mssql/bin/sqlservr & sleep 20 && /tmp/setup/init.sh && tail -f /dev/null"]


