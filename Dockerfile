FROM tomcat:8-jre8-alpine
RUN apk add --no-cache ffmpeg 'su-exec>=0.2'

ENV LIBRESONIC_VERSION v6.2
ENV LIBRESONIC_PATH /var/libresonic
ENV LIBRESONIC_WAR_URL https://github.com/Libresonic/libresonic/releases/download/$LIBRESONIC_VERSION/libresonic-$LIBRESONIC_VERSION.war
ENV TOMCAT_PATH /usr/local/tomcat
ENV JAVA_OPTS -Xms256m -Xmx768M -XX:MaxPermSize=512m

RUN set -x \
    && addgroup -g 82 -S tomcat \
    && adduser -u 82 -D -S -G tomcat tomcat \
    && rm -rf "$TOMCAT_PATH"/webapps/* \
    && apk add --no-cache --virtual .fetch-deps ca-certificates openssl \
    && wget -O "$TOMCAT_PATH"/webapps/libresonic.war "$LIBRESONIC_WAR_URL" \
    && apk del .fetch-deps \
    && chown -R tomcat:tomcat "$TOMCAT_PATH" \
    && mkdir -p "$LIBRESONIC_PATH"/transcode \
    && ln -sf /usr/bin/ffmpeg ffmpeg \
    && chown -R tomcat:tomcat "$LIBRESONIC_PATH"

COPY docker-entrypoint.sh /usr/bin
ENTRYPOINT ["docker-entrypoint.sh"] 

CMD ["catalina.sh", "run"]
