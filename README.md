# Docker Web Development Stack (DWDS)

Docker Containers (as microservice approach), which are executed with `docker-compose` as a multi-container application (stack).

> Develop only through the container.

> Each container should have only one concern.

## Images and Containers

- **Persistent storage** (Application and Data Volume Container).
  - `./application/frontend`
  - `./application/backend`
- [**NGINX**](https://www.nginx.com/) Web server. Deliver the frontend `./application/frontend/dist` and provide API access via proxy forwarder.
- **PHP 7.4.x (CLI)** with Composer, PHP CodeSniffer, phpDocumentor, phpunit and XDebug (Multi Stage) for development.
- [**MariaDB**](https://mariadb.org/) SQL database.
- [**Adminer**](https://www.adminer.org/) for database administration.
- [**Grafana**](https://grafana.com/) logging.
  - Loki: log aggregator
  - Promtail: Agent which will read up the contents of the log file/files and ship those logs to Loki
- [**Gitea**](https://gitea.io/) Repository and Issue tracker.
- [**MailCatcher**](https://mailcatcher.me/) to catch all mail and stores it for display.

## Initial services configuration

### Gitea

- To access gitea from your development environment you should set `SSH-Server-Domain` and `Gitea-Base-URL` to an appropriate resolvable name or IP address.
- Add the administration user on setup or the first user registered will be the admin
- Gitea supports Git over SSH. You might be familiar with this when you work with GitHub repositories. You need to create a key pair on your computer and add the public key under _Your Settings_ -> _SSH / GPG Keys_ . Copy and paste the public key into the Content text field then click the green Add Key button.

### Logging

The Docker plugin must be installed on each Docker host that will be running containers you want to collect logs from. [Read Docker Driver Client](https://grafana.com/docs/loki/latest/clients/docker-driver/)

```bash
docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
```

Add loki to docker container:

```byaml
    logging:
      driver: loki
      options:
        loki-url: "http://loki:3100/"
```

* [Check loki URL: http://<ip_address>:7431/metrics](http://localhost:7431/metrics)
* [Check promtail URL: http://<ip_address>:9080](http://localhost:7431/metrics)
*
Additional setup steps and informations:

* [Monitoring your docker container’s logs the Loki way](https://itnext.io/monitoring-your-docker-containers-logs-the-loki-way-e9fdbae6bafd) and
*  [Log Aggregation With Grafana+Loki+Promtail](https://cloudsbaba.com/log-aggregation-with-grafanalokipromtail/)
*  [Loki Syslog All-In-One example](https://computingforgeeks.com/forward-logs-to-grafana-loki-using-promtail/)

## Command line usage

**Since everything that has to do with the stack, only runs in the container, you have to put the commands into the corresponding container.**

To start/stop the stack, enter the following command in the terminal:

```bash
docker-compose -f "docker-compose.yml" up -d
docker-compose -f "docker-compose.yml" down
```

To open a shell in the application's container, use:

```bash
docker exec -it <container> /bin/bash
```

To execute a PHP script:

```bash
docker exec php /usr/local/bin/php /var/www/backend/public/index.php
```

Creating database dumps:

```bash
docker exec db sh -c 'exec mysqldump --all-databases -uroot -p"$MARIADB_ROOT_PASSWORD"' > /some/path/on/your/host/all-databases.sql
```

Restoring data from dump files

```bash
docker exec -i db sh -c 'exec mysql -uroot -p"$MARIADB_ROOT_PASSWORD"' < /some/path/on/your/host/all-databases.sql
```

## License

MIT © Fabian Dennler
