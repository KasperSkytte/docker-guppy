#may want to use base instead of runtime flavor
FROM nvidia/cuda:12.0.1-runtime-ubuntu20.04

LABEL org.opencontainers.image.authors="kasper@cafekapper.dk"

# ubuntu codename must match that of the base image
ARG PLATFORM=focal

# required packages for Guppy
ARG GUPPY_VERSION="6.4.8"
ARG BUILD_PACKAGES="wget apt-transport-https lsb-release nano htop net-tools"
ARG DEBIAN_FRONTEND=noninteractive

# locales
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PATH $PATH:/opt/ont-guppy/bin/

# guppy_basecall_server port is hardcoded to 5555
EXPOSE 5555

# add ONT repo signing key and repo, install guppy, and cleanup
RUN apt-get update -qqy \
  && apt-get -y install --fix-broken --no-install-recommends --no-install-suggests ${BUILD_PACKAGES} \
  # && wget -O- https://cdn.oxfordnanoportal.com/apt/ont-repo.pub | apt-key add - \
  # && echo "deb http://cdn.oxfordnanoportal.com/apt ${PLATFORM}-stable non-free" > /etc/apt/sources.list.d/nanoporetech.sources.list \
  # && apt-get update -qqy \
  # && apt-get install -y ont-guppy \
  && apt-get autoremove --purge --yes \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# alternatively just install from tarball:
RUN wget -q https://cdn.oxfordnanoportal.com/software/analysis/ont-guppy_${GUPPY_VERSION}_linux64.tar.gz -O /tmp/guppy.tar.gz \
  && tar zxf /tmp/guppy.tar.gz -C /opt/ \
  && rm /tmp/guppy.tar.gz

ENTRYPOINT [ "guppy_basecall_server" ]

CMD [ \
  "--config", "dna_r10.4.1_e8.2_400bps_sup.cfg", \
  "--chunks_per_runner", "500", \
  "--log_path", "/var/log/guppy_basecall_server/", \
  "--gpu_runners_per_device", "8", \
  "--port", "5555", \
  "-x", "auto", \
  "--allow_non_local", \
  "--use_tcp" \
]
