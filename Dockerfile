FROM debian:trixie-slim

ARG HYPERHDR_VERSION
ARG TARGETARCH

RUN test -n "$HYPERHDR_VERSION" || (echo "ERROR: HYPERHDR_VERSION build arg is required" && exit 1)

RUN DEBIAN_FRONTEND=noninteractive && \
    case "${TARGETARCH}" in \
      amd64)  ARCH=x86_64  ;; \
      arm64)  ARCH=aarch64 ;; \
      arm)    ARCH=armhf   ;; \
      *)      echo "Unsupported arch: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates && \
    BASE_URL="https://github.com/awawa-dev/HyperHDR/releases/download/v${HYPERHDR_VERSION}" && \
    DEB="HyperHDR-${HYPERHDR_VERSION}-Linux-${ARCH}.deb" && \
    wget -q "${BASE_URL}/${DEB}" -O /tmp/hyperhdr.deb && \
    wget -q "${BASE_URL}/${DEB}.sha256" -O /tmp/hyperhdr.sha256 && \
    (cd /tmp && sha256sum -c hyperhdr.sha256) && \
    apt-get install -y --no-install-recommends /tmp/hyperhdr.deb && \
    apt-get purge -y wget && \
    apt-get autoremove -y && \
    rm -rf /tmp/* /var/lib/apt/lists/*

EXPOSE 8090 19444 19445
VOLUME /config

CMD ["/usr/bin/hyperhdr", "--userdata", "/config"]
