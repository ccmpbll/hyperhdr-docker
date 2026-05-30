# hyperhdr-docker

![Image Build Status](https://img.shields.io/github/actions/workflow/status/ccmpbll/hyperhdr-docker/sync.yml) ![Docker Image Size](https://img.shields.io/docker/image-size/ccmpbll/hyperhdr/latest) ![Docker Pulls](https://img.shields.io/docker/pulls/ccmpbll/hyperhdr.svg)

Docker image for [HyperHDR](https://github.com/awawa-dev/HyperHDR), automatically built and published to Docker Hub whenever new releases are made upstream.

## Usage

```yaml
services:
  hyperhdr:
    image: ccmpbll/hyperhdr:latest
    container_name: hyperhdr
    network_mode: host
    devices:
      - /dev/video0:/dev/video0
    environment:
      - TZ=America/New_York
    volumes:
      - ./config:/config
    restart: unless-stopped
```

To pin a specific version, replace `latest` with any available tag:

```yaml
image: ccmpbll/hyperhdr:22.0.0beta2
```

## Tags

| Tag | Description |
|-----|-------------|
| `latest` | Latest stable release |
| `beta` | Latest beta release |
| `21.0.0.0` | Specific stable version |
| `22.0.0beta2` | Specific beta version |

All available tags can be found on [Docker Hub](https://hub.docker.com/r/ccmpbll/hyperhdr/tags).

## Ports

| Port | Protocol | Description |
|------|----------|-------------|
| 8090 | TCP | HTTP Web UI |
| 8092 | TCP | HTTPS Web UI |
| 19400 | TCP | Flatbuffers Server |
| 19444 | TCP | JSON Server |
| 19445 | TCP | Protocol Buffers Server |
| 19333 | TCP | Boblight Server |
| 5568 | UDP | UDP RAW Receiver |

## Supported Architectures

- `linux/amd64`
- `linux/arm64`

## Automatic Updates

A GitHub Actions workflow checks for new HyperHDR releases daily and builds images for the 5 most recent versions (including betas). The `latest` tag always points to the newest stable release.
