#!/bin/bash

if [ $SCRIPT_ENV == "mac" ]; then
  pwd="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
else
  pwd=$(readlink -f $(dirname $0))
fi

. $pwd/env.sh

start() {
  docker run --name studio --entrypoint '/bin/sh' \
    --publish $LEGEND_STUDIO_PORT:$LEGEND_STUDIO_PORT \
    -v $WORK_DIR/generated-studio-config:/config \
    -v $WORK_DIR/ssl:/ssl finos/legend-studio:0.2.10 \
    -c 'java -Xmx2G -Xms256M -Xss4M -Djavax.net.ssl.trustStore=/ssl/truststore.jks -Djavax.net.ssl.trustStorePassword=changeit -cp /app/bin/*-shaded.jar org.finos.legend.server.shared.staticserver.Server server /config/httpConfig.json'
}

stop() {
  docker container prune -f
  docker container stop studio
}

restart() {
  stop
  start
}

$*
