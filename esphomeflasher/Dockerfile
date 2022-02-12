ARG BUILD_FROM=homeassistant/${BUILD_ARCH}-base-python/tags
FROM ${BUILD_FROM}

RUN pip install esphome 2>&1

COPY run.sh /
RUN chmod a+x /run.sh

# Entrypoint & CMD
ENTRYPOINT ["/run.sh"]
