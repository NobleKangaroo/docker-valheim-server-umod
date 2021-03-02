FROM debian:buster
MAINTAINER noblekangaroo

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Valheim Server with uMod" \
      org.label-schema.description="Valheim dedicated server with uMod" \
      org.label-schema.url="http://github.com/NobleKangaroo/docker-valheim-server-umod" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="http://github.com/NobleKangaroo/docker-valheim-server-umod" \
      org.label-schema.vendor="NobleKangaroo" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

# Install packages
RUN apt-get -y update && \
    apt-get -y install \
        lib32gcc1 \
        lib32stdc++6 \
        curl

# Install uMod
RUN curl -o \
        /tmp/umod-develop.sh \
        "https://umod.io/umod-develop.sh" && \
    chmod +x /tmp/umod-develop.sh && \
    /tmp/umod-develop.sh

# Cleanup
RUN apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}

# Copy the server script
RUN mkdir -pv /opt/valheim
COPY server.sh /opt/valheim
RUN chmod +x /opt/valheim/server.sh

# Mount volumes
VOLUME /opt/valheim/server
VOLUME /opt/valheim/data

# Start the server script
CMD ["/opt/valheim/server.sh"]

