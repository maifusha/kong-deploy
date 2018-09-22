#!/bin/bash

# set global CORS
curl -X POST http://127.0.0.1:8001/plugins \
    --data "name=cors" \
    --data "config.exposed_headers=Link, X-Total-Count" \
    --data "config.max_age=86400"

# set global UUID
curl -X POST http://127.0.0.1:8001/plugins \
    --data "name=correlation-id" \
    --data "config.header_name=X-Request-ID" \
    --data "config.generator=uuid" \
    --data "config.echo_downstream=true"

# set global HSTS
curl -X POST http://127.0.0.1:8001/plugins \
    --data "name=response-transformer" \
    --data "config.add.headers[1]=Strict-Transport-Security:max-age=15768000"

# set global TCP log
curl -X POST http://127.0.0.1:8001/plugins \
    --data "name=tcp-log" \
    --data "config.host=192.168.xxx.yyy" \
    --data "config.port=5140" \
    --data "config.timeout=3000" \
    --data "config.keepalive=60000"
