# Build unrar.  It has been moved to non-free since Alpine 3.15.
# https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.15.0#unrar_moved_to_non-free
FROM alpine:3.20 as unrar-build 
ARG UNRAR_VERSION=6.1.4
RUN apk add --no-cache --upgrade \
      make \
      g++ \
      gcc \
      curl && \
    mkdir /tmp/unrar && \
    curl -o \
      /tmp/unrar.tar.gz -L \
      "https://www.rarlab.com/rar/unrarsrc-${UNRAR_VERSION}.tar.gz" && \  
    tar xf \
      /tmp/unrar.tar.gz -C \
      /tmp/unrar --strip-components=1 && \
    cd /tmp/unrar && \
    make && \
    install -v -m755 unrar /usr/bin

FROM python:3.11-alpine3.19
LABEL maintainer="pymedusa"

LABEL name="medusa" \
      maintainer="Jee jee@eer.fr" \
      description="Automatic Video Library Manager for TV Shows. It watches for new episodes of your favorite shows, and when they are posted it does its magic." \
      url="https://pymedusa.com/" \
      org.label-schema.vcs-url="https://github.com/jee-r/docker-medusa" \
      org.opencontainers.image.source="https://github.com/jee-r/docker-medusa"

COPY rootfs /

RUN apk update && \
    apk upgrade && \
    apk add --no-cache --upgrade --virtual=base \
      git \
      mediainfo \
      tzdata \
      p7zip && \
    python -m pip install --no-cache-dir --upgrade \
    	setuptools \
    	pyopenssl && \
    mkdir -p /app && \
    chmod -R 777 /app && \
    rm -rf /tmp/* /pkgs ~/.cache /var/cache/apk/

COPY --from=unrar-build /usr/bin/unrar /usr/bin/

WORKDIR /config

EXPOSE 8081

HEALTHCHECK --interval=5m --timeout=3s --start-period=90s \
  CMD /usr/local/bin/healthcheck.sh 8081

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
