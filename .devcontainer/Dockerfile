FROM mcr.microsoft.com/devcontainers/universal:2-linux

ARG USERNAME=${USERNAME:-"codespace"}

ENV TOOLS_HOME=/usr/local

############################################################
########################## LINUX ###########################
############################################################

USER root

RUN apt update \
  && apt install -y cmake libgtk-3-dev ninja-build

############################################################
######################### ANDROID ##########################
############################################################

USER root

ENV ANDROID_HOME=$TOOLS_HOME/androidsdk
ENV PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# Install Android SDK Manager
RUN _file_name="commandlinetools-linux-11076708_latest.zip" \
  && wget "https://dl.google.com/android/repository/$_file_name" \
  && unzip "$_file_name" -d $ANDROID_HOME \
  && rm -f "$_file_name"

# Give remote user ownership of ANDROID_HOME
RUN chown -R ${USERNAME} $ANDROID_HOME

# Move Android Tools to latest dir and intsall Android packages
USER $USERNAME
RUN mkdir -p $ANDROID_HOME/cmdline-tools/latest \
  && mv $ANDROID_HOME/cmdline-tools/bin $ANDROID_HOME/cmdline-tools/latest \
  && mv $ANDROID_HOME/cmdline-tools/lib $ANDROID_HOME/cmdline-tools/latest \
  && yes | sdkmanager "platform-tools" "build-tools;35.0.0" "platforms;android-35"

############################################################
############################ WEB ###########################
############################################################

USER root

# Install Google Chrome
RUN apt install -y apt-transport-https \
  && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
  && apt update \
  && apt install -y google-chrome-stable

# Install Microsoft Edge
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
  && install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/ \
  && sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list' \
  && rm microsoft.gpg \
  && apt update \
  && apt install microsoft-edge-dev

############################################################
######################### FLUTTER ##########################
############################################################

USER root

ENV FLUTTER_ROOT=$TOOLS_HOME/flutter
ENV FLUTTER_VERSION=3.29.1
ENV FLUTTER_GIT_URL=https://github.com/flutter/flutter

# Create FLUTTER_ROOT dir
RUN mkdir -p $FLUTTER_ROOT
# Give remote user ownership of FLUTTER_ROOT
RUN chown -R ${USERNAME} $FLUTTER_ROOT

# Switch to remote user
USER ${USERNAME}
# Clone Flutter into FLUTTER_ROOT
RUN git clone ${FLUTTER_GIT_URL} -b $FLUTTER_VERSION $FLUTTER_ROOT

ENV PATH="$FLUTTER_ROOT/bin:$PATH"
ENV PUB_CACHE=$FLUTTER_ROOT/.pub_cache

# Enable Flutter Web, Android and Linux Desktop
# Also doing precache, to increase workspace init
RUN flutter precache && for _plat in web linux-desktop; do flutter config --enable-${_plat}; done \
  && flutter config --android-sdk $ANDROID_HOME \
  && yes | flutter doctor --android-licenses \
  && flutter doctor
