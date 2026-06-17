FROM scratch
ARG ZARF_VERSION="v0.79.0"
ARG ZARF_ARCH="amd64"
ADD --chmod=+x "https://github.com/defenseunicorns/zarf/releases/download/${ZARF_VERSION}/zarf_${ZARF_VERSION}_Linux_${ZARF_ARCH}" /zarf 
ADD "https://github.com/defenseunicorns/zarf/releases/download/${ZARF_VERSION}/zarf-init-${ZARF_ARCH}-${ZARF_VERSION}.tar.zst" /zarf-cache/
ENTRYPOINT [ "/zarf", "--zarf-cache", "/zarf-cache" ]

LABEL org.opencontainers.image.source=https://github.com/leppek/zarf-initializer

