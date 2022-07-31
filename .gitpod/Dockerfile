FROM gitpod/workspace-full-vnc
SHELL ["/bin/bash", "-c"]

############################################################
######################### FLUTTER ##########################
############################################################

USER gitpod
WORKDIR /home/gitpod

ENV FLUTTER_VERSION=3.0.5
RUN git clone https://github.com/flutter/flutter -b ${FLUTTER_VERSION} --depth=1

ENV PATH="/home/gitpod/flutter/bin:$PATH"
ENV PUB_CACHE="/workspace/.pub_cache"

############################################################
######################### ANDROID ##########################
############################################################

# DISABLED FOR NOW

# ENV ANDROID_HOME=/home/gitpod/androidsdk

# # Install Open JDK
# USER root
# RUN apt update \
#     && apt install openjdk-8-jdk -y \
#     && update-java-alternatives --set java-1.8.0-openjdk-amd64

# # Install SDK Manager
# USER gitpod
# RUN  wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip \
#     && mkdir -p $ANDROID_HOME/cmdline-tools/latest \
#     && unzip commandlinetools-linux-*.zip -d $ANDROID_HOME \
#     && rm -f commandlinetools-linux-*.zip \
#     && mv $ANDROID_HOME/cmdline-tools/bin $ANDROID_HOME/cmdline-tools/latest \
#     && mv $ANDROID_HOME/cmdline-tools/lib $ANDROID_HOME/cmdline-tools/latest

# RUN echo "export ANDROID_HOME=$ANDROID_HOME" >> /home/gitpod/.bashrc \
#     && echo 'export PATH=$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/bin:$ANDROID_HOME/platform-tools:$PATH' >> /home/gitpod/.bashrc

# # Install Android Image version 30
# USER gitpod
# RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-30" "emulator"
# RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "system-images;android-30;google_apis;x86_64"
# RUN echo no | $ANDROID_HOME/cmdline-tools/latest/bin/avdmanager create avd -n avd28 -k "system-images;android-30;google_apis;x86_64"

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

############################################################
########################### MISC ###########################
############################################################

# misc deps
RUN apt-get install -y \
  libasound2-dev \
  libgtk-3-dev \
  libnss3-dev \
  fonts-noto \
  fonts-noto-cjk

# For Qt WebEngine on docker
ENV QTWEBENGINE_DISABLE_SANDBOX 1
