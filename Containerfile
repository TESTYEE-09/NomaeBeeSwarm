ARG BASE_IMAGE=ghcr.io/ublue-os/bazzite-deck:stable

FROM scratch AS ctx
COPY build_files /build_files
COPY system_files /system_files
COPY LICENSE /LICENSE
COPY NOTICE.md /NOTICE.md

FROM ${BASE_IMAGE}

ARG VERSION=0.1.0
ARG REVISION=development

LABEL org.opencontainers.image.title="NomaeOS" \
      org.opencontainers.image.description="Console operating system for the Nomae Box, based on Bazzite Deck" \
      org.opencontainers.image.source="https://github.com/TESTYEE-09/NomaeOS" \
      org.opencontainers.image.vendor="NomaePC" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${REVISION}" \
      org.opencontainers.image.licenses="Apache-2.0"

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    NOMAEOS_VERSION="${VERSION}" NOMAEOS_REVISION="${REVISION}" bash /ctx/build_files/build.sh

RUN bootc container lint
