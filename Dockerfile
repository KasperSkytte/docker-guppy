#may want to use base instead of runtime flavor
FROM nvidia/cuda:12.0.1-runtime-ubuntu20.04

MAINTAINER Kasper Skytte Andersen <kasper@cafekapper.dk>

# ubuntu codename must match that of the base image
ARG PLATFORM=focal

# required packages for Guppy
ARG BUILD_PACKAGES="wget apt-transport-https lsb-release"
ARG DEBIAN_FRONTEND=noninteractive
ARG GUPPY_CFG="dna_r10.4.1_e8.2_400bps_sup.cfg"
ARG GUPPY_CHUNKS_PER_RUNNER=500
ARG GUPPY_GPU_RUNNERS_PER_DEVICE=9
ARG GUPPY_PORT=5555
ARG GUPPY_GUP_RUNNERS_PER_DEVICE=8
ARG GUPPY_CUDA_DEVICES=auto

# locales
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# add ONT repo signing key and repo
RUN apt-get update -qqy \
  && apt-get -y install --fix-broken --no-install-recommends --no-install-suggests $BUILD_PACKAGES \
  && wget -O- https://cdn.oxfordnanoportal.com/apt/ont-repo.pub | apt-key add - \
  && echo "deb http://cdn.oxfordnanoportal.com/apt ${PLATFORM}-stable non-free" > /etc/apt/sources.list.d/nanoporetech.sources.list \
  && apt-get update -qqy \
  && apt-get install -y ont-guppy \
  && apt-get autoremove --purge --yes \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# alternatively just install from the deb file:
#wget -q https://mirror.oxfordnanoportal.com/software/analysis/ont_guppy_${PACKAGE_VERSION}-1~bionic_amd64.deb

#CMD guppy_basecall_server --config $GUPPY_CFG --port $GUPPY_PORT --allow_non_local --use_tcp --num_callers 1 --cpu_threads_per_caller 2 --ipc_threads 3 --chunks_per_runner $GUPPY_CHUNKS_PER_RUNNER --gpu_runners_per_device $GUPPY_GUP_RUNNERS_PER_DEVICE -x $GUPPY_CUDA_DEVICE

CMD ["guppy_basecall_server", \
  "--config", $GUPPY_CFG \
]