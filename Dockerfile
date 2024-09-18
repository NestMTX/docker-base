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
    py3-pip \
    pkgconfig \
    cairo-dev \
    pango-dev \
    jpeg-dev \
    giflib-dev \
    g++ \
    make

##################################################
# Install Mesa with VDPAU support
##################################################
FROM base AS mesa

# Install additional dependencies including the Python mako module
RUN apk add --no-cache \
    clang-dev \
    cmake \
    git \
    glib-dev \
    glslang \
    libclc-dev \
    libdrm-dev \
    libva-vdpau-driver \
    libx11 \
    libx11-dev \
    libxdamage-dev \
    libxext-dev \
    libxfixes-dev \
    libxml2-dev \
    libxshmfence-dev \
    llvm-dev \
    mesa-dev \
    mesa-egl \
    mesa-gbm \
    mesa-gl \
    mesa-glapi \
    mesa-gles \
    mesa-va-gallium \
    meson \
    ninja \
    wayland-protocols-dev \
    xorg-server-dev \
    xz-dev \
    zlib-dev \
    libvdpau-dev \
    py3-mako

# Install libglvnd
RUN git clone https://github.com/NVIDIA/libglvnd.git /tmp/libglvnd && \
    cd /tmp/libglvnd && \
    meson builddir --prefix=/usr && \
    ninja -C builddir/ install && \
    rm -rf /tmp/libglvnd

# Install Mesa
RUN git clone https://gitlab.freedesktop.org/mesa/mesa.git /tmp/mesa && \
    cd /tmp/mesa && \
    meson setup builddir/ --prefix=/usr && \
    ninja -C builddir/ && \
    ninja -C builddir/ install && \
    cd / && \
    rm -rf /tmp/mesa
