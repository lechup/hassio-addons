ARG BUILD_FROM=esphome/esphome-hassio-${BUILD_ARCH}
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
