ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-37}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

COPY build.sh /tmp/build.sh
COPY post-install.sh /tmp/post-install.sh
COPY packages.txt /tmp/packages.txt

COPY components/yafti /
COPY components/nitrokey /

COPY --from=ghcr.io/ublue-os/config:latest /files/ublue-os-update-services /

RUN /tmp/build.sh
RUN /tmp/post-install.sh

RUN ls -alhF /var/cache/rpm-ostree/repomd/updates-archive-37-x86_64 || true
RUN ls -alhF /var/cache/rpm-ostree/repomd/updates-archive-37-x86_64/gpgdir || true

RUN rm -rf /tmp/* /var/* || true

RUN ls -alhF /var/cache/rpm-ostree/repomd/updates-archive-37-x86_64 || true
RUN ls -alhF /var/cache/rpm-ostree/repomd/updates-archive-37-x86_64/gpgdir || true

RUN ostree container commit

RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp
