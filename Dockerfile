FROM amazoncorretto:17-alpine

RUN apk --no-cache add fontconfig libreoffice && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

