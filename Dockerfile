ARG BASE_VERSION="3.14"
FROM alpine:$BASE_VERSION

ARG OVERLAY_VERSION="v3.1.0.1"
ARG OVERLAY_ARCH="x86_64"
ARG OVERLAY_ARCH_URL="https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.xz"
ARG OVERLAY_NOARCH_URL="https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-noarch.tar.xz"

WORKDIR /tmp
RUN apk add --no-cache \
    coreutils \
    curl \
    shadow \
    tzdata \
    xz \
  && curl -LO "$OVERLAY_ARCH_URL" \
  && curl -LO "$OVERLAY_ARCH_URL.sha256" \
  && curl -LO "$OVERLAY_NOARCH_URL" \
  && curl -LO "$OVERLAY_NOARCH_URL.sha256" \
  && sha256sum -c "s6-overlay-$OVERLAY_ARCH.tar.xz.sha256" \
  && sha256sum -c "s6-overlay-noarch.tar.xz.sha256" \
  && tar -C / -Jxpf "s6-overlay-noarch.tar.xz" \
  && tar -C / -Jxpf "s6-overlay-$OVERLAY_ARCH.tar.xz" \
  && apk del --no-cache \
    curl \
    xz \
  && apk del --purge \
  && rm -rf /tmp/*

RUN groupadd abc \
  && groupmod -g 1000 abc \
  && useradd \
    -u 1000 \
    -g 1000 \
    -d /home/abc \
    -s /bin/sh abc \
  && usermod -G abc abc \
  && mkdir -p /app /default /home/abc \
  && chown abc:abc /app /default /home/abc

COPY ./root/ /

ENTRYPOINT [ "/init" ]
