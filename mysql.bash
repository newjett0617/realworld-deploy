#!/usr/bin/env bash

docker run \
  -d \
  --init \
  --name mysql \
  --network bridge \
  --publish 127.0.0.1:3306:3306 \
  --env MYSQL_ROOT_PASSWORD=root \
  --env MYSQL_USER=realworld \
  --env MYSQL_PASSWORD=realworld \
  --env MYSQL_DATABASE=realworld \
  -v mysql_data:/var/lib/mysql \
  docker.io/library/mysql:5.7