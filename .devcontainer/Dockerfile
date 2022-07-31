# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.238.1/containers/java/.devcontainer/base.Dockerfile

ARG VARIANT="bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

USER vscode
WORKDIR /home/vscode

ENV FLUTTER_VERSION=3.0.5
RUN git clone https://github.com/flutter/flutter -b ${FLUTTER_VERSION} --depth=1

ENV PATH="/home/vscode/flutter/bin:$PATH"
ENV PUB_CACHE="/workspaces/.pub_cache"

############################################################
############################ WEB ###########################
############################################################

# Install Google Chrome
USER root
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb \
  && apt-get -y install /tmp/chrome.deb
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y firefox-esr

# TODO: Chrome is crashing
# [0731/121628.405381:ERROR:file_io_posix.cc(144)] open /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq: No such file or directory (2)
# [0731/121628.405460:ERROR:file_io_posix.cc(144)] open /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq: No such file or directory (2)
# This SO answer (https://stackoverflow.com/a/71203432/1683224) says it crashes because it can't connect to a GUI
# Maybe see what Gitpod team has done may help

############################################################
########################### MISC ###########################
############################################################

# # misc deps
# RUN apt-get install -y \
#   libasound2-dev \
#   libgtk-3-dev \
#   libnss3-dev \
#   fonts-noto \
#   fonts-noto-cjk

USER vscode
