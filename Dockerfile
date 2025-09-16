# scratch is an empty image, the absolute minimal starting point.
FROM scratch

COPY _output/zarf /zarf
COPY _output/zarf-init-* /zarf-cache/
WORKDIR /tmp
ENTRYPOINT [ "/zarf", "--zarf-cache", "/zarf-cache" ]
CMD [ "init", "--confirm", "--components", "git-server"]

LABEL org.opencontainers.image.source=https://github.com/leppek/zarf-initializer

