#!/bin/bash

export PATH=$PATH:/glassfish4/glassfish/bin
asadmin start-domain

# Check if the properties files have been included
if [ -z  ${BAE_RSS_DATABASE_URL} ]; then
    if [ ! -f /etc/default/rss/oauth.properties ]; then
        echo "Missing oauth.properties file"
        exit 1
    fi

    if [ ! -f /etc/default/rss/database.properties ]; then
        echo "Missing database.properties file"
        exit 1
    fi
else
    if [ -f /etc/default/rss/oauth.properties ]; then
        rm /etc/default/rss/oauth.properties
    fi

    if [ -f /etc/default/rss/database.properties ]; then
        rm /etc/default/rss/database.properties
    fi

    cp /properties/oauth.properties /etc/default/rss/oauth.properties
    cp /properties/database.properties /etc/default/rss/database.properties

    sed -i "s|\${BAE_RSS_OAUTH_CONFIG_GRANTEDROLE}|${BAE_RSS_OAUTH_CONFIG_GRANTEDROLE}|g" /etc/default/rss/oauth.properties
    sed -i "s|\${BAE_RSS_OAUTH_CONFIG_SELLERROLE}|${BAE_RSS_OAUTH_CONFIG_SELLERROLE}|g" /etc/default/rss/oauth.properties
    sed -i "s|\${BAE_RSS_OAUTH_CONFIG_AGGREGATORROLE}|${BAE_RSS_OAUTH_CONFIG_AGGREGATORROLE}|g" /etc/default/rss/oauth.properties

    sed -i "s|\${BAE_RSS_DATABASE_URL}|${BAE_RSS_DATABASE_URL}|g" /etc/default/rss/database.properties
    sed -i "s|\${BAE_RSS_DATABASE_USERNAME}|${BAE_RSS_DATABASE_USERNAME}|g" /etc/default/rss/database.properties
    sed -i "s|\${BAE_RSS_DATABASE_PASSWORD}|${BAE_RSS_DATABASE_PASSWORD}|g" /etc/default/rss/database.properties
    sed -i "s|\${BAE_RSS_DATABASE_DRIVERCLASSNAME}|${BAE_RSS_DATABASE_DRIVERCLASSNAME}|g" /etc/default/rss/database.properties
fi

# Get MySQL info
if [ -z  ${BAE_RSS_DATABASE_URL} ]; then
    MYSQL_HOST=`grep -o 'database\.url=.*' /etc/default/rss/database.properties | grep -oE '//.+:' | grep -oE '[^/:]+'`
    MYSQL_PORT=`grep -o 'database\.url=.*' /etc/default/rss/database.properties | grep -oE ':[0-9]+/' | grep -oE '[0-9]+'`
else
    MYSQL_HOST=`echo ${BAE_RSS_DATABASE_URL} | grep -oE '//.+:' | grep -oE '[^/:]+'`
    MYSQL_PORT=`echo ${BAE_RSS_DATABASE_URL} | grep -oE ':[0-9]+/' | grep -oE '[0-9]+'`
fi

# Check if MySQL is running
echo "testing MySQL connection..."
exec 8<>/dev/tcp/${MYSQL_HOST}/${MYSQL_PORT}
mysqlStatus=$?

i=1
while [[ ${mysqlStatus} -ne 0 && ${i} -lt 50 ]]; do
    echo "MySQL not running, retrying in 5 seconds"
    sleep 5
    i=${i}+1

    exec 8<>/dev/tcp/${MYSQL_HOST}/${MYSQL_PORT}
    mysqlStatus=$?
done

if [[ ${mysqlStatus} -ne 0 ]]; then
    echo "It has not been possible to connect to MySQL"
    exit 1
fi

exec 8>&- # close output connection
exec 8<&- # close input connection

# Deploy RSS war
echo "Deploying WAR file..."
asadmin deploy --force false --contextroot DSRevenueSharing --name DSRevenueSharing ./fiware-rss/target/DSRevenueSharing.war

echo "RSS deployed"
if [[ $1 == "-bash" ]]; then
  /bin/bash
else
  while true; do sleep 1000; done
fi

