# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.238.1/containers/debian/.devcontainer/base.Dockerfile

# [Choice] Debian version (use bullseye on local arm64/Apple Silicon): bullseye, buster
ARG VARIANT="buster"
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
RUN apt-get update \
  && apt-get install -y apt-transport-https \
  && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update \
  && sudo apt-get install -y google-chrome-stable

# TODO: Chrome is crashing
# [0731/121628.405381:ERROR:file_io_posix.cc(144)] open /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq: No such file or directory (2)
# [0731/121628.405460:ERROR:file_io_posix.cc(144)] open /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq: No such file or directory (2)
# This SO answer (https://stackoverflow.com/a/71203432/1683224) says it crashes because it can't connect to a GUI
# Maybe see what Gitpod team has done may help
