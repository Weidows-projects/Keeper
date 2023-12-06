FROM debian:buster-slim
ARG UPX_VER
ARG UPLOADER_VER
ENV export UPX_VER=${UPX_VER:-4.0.0}
ENV export UPLOADER_VER=${UPLOADER_VER:-v0.9.1}

RUN
DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  curl \
  wget \
  git \
  build-essential \
  zip \
  xz-utils \
  jq \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*
