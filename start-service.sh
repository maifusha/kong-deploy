#!/bin/bash

docker swarm init --advertise-addr xxx.manager.ip.xxx

docker network create --driver overlay docker-network

docker service create --name kong-database --network docker-network --replicas 1 \
           --env "POSTGRES_USER=kong" \
           --env "POSTGRES_DB=kong" \
           --mount type=bind,src=/data/postgres,dst=/var/lib/postgresql/data postgres:latest

docker service create --name kong-server --network docker-network --replicas 1 \
           --env "KONG_DATABASE=postgres" \
           --env "KONG_PG_HOST=kong-database" \
           --env "KONG_ALLOW_DOMAIN=\\\\.(yoursite.com|yoursite.net)\$" \
           --publish 80:8000 \
           --publish 443:8443 \
           --publish 8001:8001 \
           --mount type=bind,src=/root/storage/resty-auto-ssl,dst=/etc/resty-auto-ssl kong:latest

docker service create --name kong-dashboard --network docker-network --replicas 1 \
           --publish 8080:8080 kong-dashboard:latest

docker service create --name kongfig --network docker-network --replicas 1 \
           --mount type=bind,src=/root/config/kong.yml,dst=/config/kong.yml \
           kongfig:latest --host kong-server:8001 --path /config/kong.yml
