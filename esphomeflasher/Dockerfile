ARG BUILD_FROM=homeassistant/aarch64-base-python:latest
FROM ${BUILD_FROM}

RUN apk add --no-cache \
    g++ make \
    libffi-dev

RUN pip install esphome 2>&1

COPY run.sh /
RUN chmod a+x /run.sh

# Entrypoint & CMD
ENTRYPOINT ["/run.sh"]
