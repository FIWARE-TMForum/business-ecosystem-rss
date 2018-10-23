# Business Ecosystem RSS Docker Image

Starting on version 5.4.0, you are able to run the Business API Ecosystem with Docker. In this context, the current repository contains the Docker image of the Business Ecosystem RSS component, so you can run it stand alone. As you may know, the Business Ecosystem RSS needs a MySQL database to store some information. For this reason, you must create an additional container to run the database. You can do it automatically with `docker-compose` or manually by following the given steps.

## OAuth2 Authentication

The Business API Ecosystem authenticates with the [FIWARE Lab identity manager](https://account.lab.fiware.org). In this regard, it is needed to register an application in this portal in order to acquire the OAuth2 credentials.

The Business Ecosystem RSS itself does not need to know the credentials (Client Id and Client Secret) of the registered application, but it needs to know the name given to the created roles. The current image uses *admin* for the admin role and *Seller* for the seller role.

## Automatically

You can install the Business Ecosystem RSS automatically if you have `docker-compose` installed in your machine. To do so, you must create a folder to place a new file file called `docker-compose.yml` that should include the following content:

```
version: '3'

services:
    rss_db:
        image: mysql:5.7
        ports:
            - "3334:3306"
        volumes:
            - ./rss-data:/var/lib/mysql
        environment:
            - MYSQL_ROOT_PASSWORD=my-secret-pw
            - MYSQL_DATABASE=RSS

    rss:
        image: fiware/biz-ecosystem-rss
        ports:
            - "9999:8080"
            - "4444:4848"
            - "1111:8181"
        links:
            - rss_db
        depends_on:
            - rss_db
        # volumes:
        #    Used when the RSS is not configured by environment
        #    - ./rss-config:/etc/default/rss
        environment:
            - MYSQL_HOST=mysql
            - MYSQL_PORT=3306
            - BAE_RSS_DATABASE_URL=jdbc:mysql://mysql:3306/RSS
            - BAE_RSS_DATABASE_USERNAME=root
            - BAE_RSS_DATABASE_PASSWORD=my-secret-pw
            - BAE_RSS_DATABASE_DRIVERCLASSNAME=com.mysql.jdbc.Driver
            - BAE_RSS_OAUTH_CONFIG_GRANTEDROLE=admin
            - BAE_RSS_OAUTH_CONFIG_SELLERROLE=Seller
            - BAE_RSS_OAUTH_CONFIG_AGGREGATORROLE=Aggregator
```

**Note**: The provided docker-compose file is using a port schema that can be easily changed modifying the file

Starting in version 7.4.0 the RSS can be configured using environment variables. In this regard, the variables
included in the previous example override the default values included in the config files.

Once you have created the file, run the following command:

```
docker-compose up
```

Then, the Business Ecosystem RSS should be up and running in `http://YOUR_HOST:PORT/DSRevenueSharing` replacing `YOUR_HOST` by the host of your machine and `PORT` by the port selected in the previous step. 

Once the different containers are running, you can stop them using:

```
docker-compose stop
```

And start them again using:

```
docker-compose start
```

Additionally, you can terminate the different containers by executing:

```
docker-compose down
```

**Note**: The provided docker compose requires a volume rss-config which must include the configuration files of the RSS. If this files are not included you will see an error when running the container

## Manually

### 1) Creating a Container to host the Database

The first thing that you have to do is to create a docker container that will host the database used by the Business Ecosystem RSS. To do so, you can execute the following command:

```
docker run --name rss_db -e MYSQL_ROOT_PASSWORD=my-secret-pw -e MYSQL_DATABASE=rss -p PORT:8080 -v ./rss-data:/var/lib/mysql -d mysql
```

### 2) Deploying the Business Ecosystem RSS Image

Once that the database is configured, you can deploy the image by running the following command:

```
docker run -p PORT:8080 -v ./rss-config:/etc/default/rss --link rss_db conwetlab/biz-ecosystem-rss
```
**Note**: The provided docker image requires a volume rss-config which must include the configuration files of the RSS. If this files are not included you will see an error when running the container

**Note**: You can change the values of the MySQL connection (database password, and database host), but they must be same as the used when running the MySQL container. 

Once that you have run these commands, the RSS should be up and running in `http://YOUR_HOST:PORT/fiware-rss` replacing `YOUR_HOST` by the host of your machine and `PORT` by the port selected in the previous step. 
