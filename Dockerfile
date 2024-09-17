ARG IMAGE_PREFIX=
ARG NODE_IMAGE=node:21-alpine
ARG BUILDPLATFORM=amd64
FROM --platform=${BUILDPLATFORM} ${IMAGE_PREFIX}${NODE_IMAGE} AS base

##################################################
# Install the base OS packages
##################################################
ENV LC_ALL=C.UTF-8

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk --no-cache add dumb-init \
    gnupg \
    wget \
    unzip \
    tzdata \
    libxml2 \
    xz \
    curl \
    jq \
    nethogs \
    openssl \
    ffmpeg \
    gstreamer-tools \
    gst-plugins-base \
    gst-plugins-good \
    gst-plugins-bad \
    gst-plugins-ugly \
    gst-rtsp-server \
    gstreamer-dev \
    gst-libav \
    build-base \
    python3 \
    pkgconfig \
    cairo-dev \
    pango-dev \
    jpeg-dev \
    giflib-dev \
    g++ \
    make

##################################################
# Install Mesa
##################################################
FROM base AS mesa

RUN apk add --no-cache \
    meson \
    ninja \
    glib-dev \
    libdrm-dev \
    llvm-dev \
    mesa-dev \
    mesa-gl \
    mesa-gbm \
    mesa-glapi \
    mesa-egl \
    mesa-gles \
    mesa-va-gallium \
    wayland-protocols-dev \
    libx11-dev \
    libx11 \
    libxext-dev \
    libxdamage-dev \
    libxfixes-dev \
    libxshmfence-dev \
    zlib-dev \
    xz-dev \
    xorg-server-dev \
    clang-dev \
    libxml2-dev \
    git \
    cmake

RUN git clone https://github.com/NVIDIA/libglvnd.git /tmp/libglvnd && \
    cd /tmp/libglvnd && \
    meson builddir --prefix=/usr && \
    ninja -C builddir/ install && \
    rm -rf /tmp/libglvnd

RUN git clone https://gitlab.freedesktop.org/mesa/mesa.git /tmp/mesa && \
    cd /tmp/mesa && \
    meson setup builddir/ --prefix=/usr && \
    ninja -C builddir/ && \
    ninja -C builddir/ install && \
    cd / && \
    rm -rf /tmp/mesa