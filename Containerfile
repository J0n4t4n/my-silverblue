ARG IMAGE_NAME="${IMAGE_NAME:-kinoite}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-kinoite}"
ARG BASE_IMAGE="quay.io/fedora-ostree-desktops/${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-38}"

FROM ${BASE_IMAGE}:${FEDORA_MAJOR_VERSION} AS builder

ARG IMAGE_NAME="${IMAGE_NAME}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION}"

COPY --from=ghcr.io/ublue-os/config:latest /files/ublue-os-update-services /

COPY components/ax210-fix /
COPY components/nitrokey /
COPY components/yafti /

COPY *.sh *.txt /tmp/

RUN /tmp/prepare.sh
RUN /tmp/build.sh
RUN /tmp/post-install.sh

RUN rm -rf /tmp/* /var/*

RUN ostree container commit

RUN mkdir -p /var/tmp && chmod -R 1777 /var/tmp
