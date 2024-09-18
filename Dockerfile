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

RUN apk add --no-cache git

RUN git clone https://github.com/NVIDIA/libglvnd.git /tmp/libglvnd && \
    git clone https://gitlab.freedesktop.org/mesa/mesa.git /tmp/mesa

# Install additional dependencies
RUN apk add --no-cache \
    ca-certificates \
    binutils \
    bison \
    clang-dev \
    cmake \
    elfutils-dev \
    flex \
    glib-dev \
    glslang \
    gcompat \
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
    libxrandr-dev \
    lua5.3 \
    spirv-llvm-translator-dev \
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
    py3-cparser \
    py3-mako \
    py3-yaml \
    valgrind \
    wget \
    wayland-dev \
    xrandr

# RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
#     wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk && \
#     apk add glibc-2.28-r0.apk

# Install libglvnd
RUN cd /tmp/libglvnd && \
    meson builddir --prefix=/usr && \
    ninja -C builddir/ install && \
    rm -rf /tmp/libglvnd

# Install Mesa
RUN cd /tmp/mesa && \
    meson setup builddir/ --prefix=/usr && \
    ninja -C builddir/ && \
    ninja -C builddir/ install && \
    cd / && \
    rm -rf /tmp/mesa
