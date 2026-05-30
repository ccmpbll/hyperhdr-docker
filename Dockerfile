FROM debian:trixie-slim

ARG HYPERHDR_VERSION
ARG TARGETARCH

RUN test -n "$HYPERHDR_VERSION" || (echo "ERROR: HYPERHDR_VERSION build arg is required" && exit 1)

RUN case "${TARGETARCH}" in \
      amd64)  ARCH=x86_64  ;; \
      arm64)  ARCH=aarch64 ;; \
      arm)    ARCH=armhf   ;; \
      *)      echo "Unsupported arch: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl ca-certificates && \
    DEB_URL=$(curl -sf "https://api.github.com/repos/awawa-dev/HyperHDR/releases/tags/v${HYPERHDR_VERSION}" \
      | grep -o '"browser_download_url": *"[^"]*Linux-'"${ARCH}"'\.deb"' \
      | grep -o 'https://[^"]*') && \
    echo "Downloading: ${DEB_URL}" && \
    curl -fL "${DEB_URL}" -o /tmp/hyperhdr.deb && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends /tmp/hyperhdr.deb && \
    apt-get purge -y curl && \
    apt-get autoremove -y && \
    rm -rf /tmp/* /var/lib/apt/lists/*

EXPOSE 8090 8092 19400 19444 19445 19333 5568/udp
VOLUME /config

CMD ["/usr/bin/hyperhdr", "--userdata", "/config"]
