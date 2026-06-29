# zarf-initializer

Minimal container image for initializing a Kubernetes cluster with [Zarf](https://github.com/defenseunicorns/zarf) in an unattended manner.

The image is built from `scratch` and bundles the `zarf` binary alongside the `zarf-init` package, so no network access is needed at runtime to fetch the init package.

## Image

```
ghcr.io/leppek/zarf-initializer:<zarf-version>
```

Tags follow upstream Zarf release versions (e.g. `v0.79.0`). A `latest` tag is also available.

Images are signed with [cosign](https://github.com/sigstore/cosign) (keyless/OIDC).

## Usage

### Docker (mount kubeconfig)

Run the image locally with your kubeconfig mounted in:

```sh
docker run --rm \
  -v ~/.kube/config:/root/.kube/config \
  ghcr.io/leppek/zarf-initializer:latest \
  init --confirm
```

If your kubeconfig references `localhost` or `127.0.0.1`, use host networking:

```sh
docker run --rm --network host \
  -v ~/.kube/config:/root/.kube/config \
  ghcr.io/leppek/zarf-initializer:latest \
  init --confirm
```

### Kubernetes Job

Deploy the image as a Job on the target cluster. The Job needs a ServiceAccount with `cluster-admin` privileges since Zarf creates namespaces, deployments, and other cluster-scoped resources.

See the [`examples/`](./examples/) directory for ready-to-use manifests.

Quick apply:

```sh
kubectl apply -f examples/
```

This creates the ServiceAccount, ClusterRoleBinding, and Job in `kube-system`.

## Passing additional Zarf flags

The entrypoint is `zarf --zarf-cache /zarf-cache`, so any arguments you provide are appended directly. For example, to select specific components:

```sh
docker run --rm --network host \
  -v ~/.kube/config:/root/.kube/config \
  ghcr.io/leppek/zarf-initializer:latest \
  init --confirm --components=git-server
```

## How it works

The Dockerfile downloads the statically-linked `zarf` binary and the compressed init package at build time:

```dockerfile
FROM scratch
ARG ZARF_VERSION="v0.79.0"
ARG ZARF_ARCH="amd64"
ADD --chmod=+x ".../zarf_${ZARF_VERSION}_Linux_${ZARF_ARCH}" /zarf
ADD ".../zarf-init-${ZARF_ARCH}-${ZARF_VERSION}.tar.zst" /zarf-cache/
ENTRYPOINT [ "/zarf", "--zarf-cache", "/zarf-cache" ]
```

Because the base is `scratch`, the image contains nothing but the Zarf binary and the init package -- no shell, no OS libraries.

## Upstream

This project tracks [Zarf](https://github.com/defenseunicorns/zarf) releases.

## Automated updates

[Renovate](https://github.com/renovatebot/renovate) monitors upstream Zarf releases and automatically bumps the version in the Dockerfile.
