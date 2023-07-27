FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,video

RUN apt-get update \
    && apt-get -y --no-install-recommends install build-essential curl ca-certificates python3 python-is-python3 ninja-build meson librsvg2-dev \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && update-ca-certificates

WORKDIR /app
COPY ./build-ffmpeg /app/build-ffmpeg

RUN AUTOINSTALL=yes /app/build-ffmpeg --build --enable-gpl-and-non-free --full-static

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,video

# Copy ffmpeg
RUN cp /app/workspace/bin/ffmpeg /ffmpeg
RUN cp /app/workspace/bin/ffprobe /ffprobe
RUN cp /app/workspace/bin/ffplay /ffplay

CMD         ["--help"]
ENTRYPOINT  ["/ffmpeg"]
