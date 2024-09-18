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
# Install Mesa and Vulkan
##################################################
FROM base AS mesa

RUN apk --no-cache add \
    mesa-dev \
    mesa-egl \
    mesa-gbm \
    mesa-gl \
    mesa-glapi \
    mesa-gles \
    mesa-va-gallium \
    mesa

RUN if [[ "$BUILDPLATFORM" == "amd64" ]];then RUN apk --no-cache add mesa-vulkan-intel ; else echo "This build is not compatible with 'mesa-vulkan-intel'" ; fi