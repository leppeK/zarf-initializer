FROM busybox:stable AS busybox

FROM scratch
ARG ZARF_VERSION="v0.81.0"
ARG ZARF_ARCH="amd64"
COPY --from=busybox /bin/sh /bin/sh
ADD --chmod=+x "https://github.com/zarf-dev/zarf/releases/download/${ZARF_VERSION}/zarf_${ZARF_VERSION}_Linux_${ZARF_ARCH}" /zarf 
ADD "https://github.com/zarf-dev/zarf/releases/download/${ZARF_VERSION}/zarf-init-${ZARF_ARCH}-${ZARF_VERSION}.tar.zst" /zarf-cache/
ENTRYPOINT [ "/zarf", "--zarf-cache", "/zarf-cache" ]
WORKDIR /tmp

LABEL org.opencontainers.image.source=https://github.com/leppek/zarf-initializer
