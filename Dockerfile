ARG BASE_VERSION="3.12"
FROM alpine:$BASE_VERSION

ARG OVERLAY_VERSION="v2.1.0.2"
ARG OVERLAY_ARCH="amd64"
ARG OVERLAY_RELEASE_URL="https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}-installer"

WORKDIR /tmp
RUN apk add --no-cache \
    coreutils \
    curl \
    shadow \
    tzdata \
  && curl -L "$OVERLAY_RELEASE_URL" -o s6-install \
  && chmod +x s6-install \
  && ./s6-install / \
  && apk del --no-cache curl \
  && apk del --purge \
  && rm -rf /tmp/*

RUN groupadd abc \
  && groupmod -g 1000 abc \
  && useradd \
    -u 1000 \
    -g 1000 \
    -d /config \
    -s /bin/sh abc \
  && usermod -G abc abc \
  && mkdir -p /app /config /defaults

COPY ./root/ /

ENTRYPOINT [ "/init" ]
