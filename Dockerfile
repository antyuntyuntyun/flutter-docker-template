# Base image
ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}

# ENV
ENV DEBIAN_FRONTEND=noninteractive
# ENV LC_ALL=ja_JP.UTF-8
# ENV LC_CTYPE=ja_JP.UTF-8
# ENV LANGUAGE=ja_JP:jp

# timezone
ARG TIMEZONE=Asia/Tokyo
RUN echo $TIMEZONE > /etc/timezone

ARG WORKDIR=/workspace
RUN mkdir -p ${WORKDIR}
WORKDIR ${WORKDIR}

# change default shell
SHELL ["/bin/bash", "-c"]
RUN chsh -s /bin/bash

# TODO
# # [Optional] Add sudo support
# RUN apt-get install -y sudo \
#     && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
#     chmod 0440 /etc/sudoers.d/$USERNAME

# Increase timeout for apt-get to 300 seconds
RUN /bin/echo -e "\n\
    Acquire::http::Timeout \"300\";\n\
    Acquire::ftp::Timeout \"300\";" >> /etc/apt/apt.conf.d/99timeout

# Install tools
RUN apt-get update && apt-get install -y --no-install-recommends tzdata && \
    apt-get update && \
    apt-get install -y --no-install-recommends bash ca-certificates clang cmake curl file git libglu1-mesa libgtk-3-dev ninja-build pkg-config unzip xz-utils zip wget gnupg

# Install Chrome
RUN sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    apt update && \
    apt-get install -y --no-install-recommends google-chrome-stable

# Install Dart
ARG DART_VERSION=2.13.0
RUN mkdir -p /usr/share/man/man1 && \
    curl https://storage.googleapis.com/dart-archive/channels/stable/release/$DART_VERSION/sdk/dartsdk-linux-x64-release.zip -o /tmp/dart-sdk.zip && \
    unzip /tmp/dart-sdk.zip -d /usr/lib && rm /tmp/dart-sdk.zip

# Install Flutter
ARG WORKDIR=/workspace
RUN cd ${WORKDIR}
ARG PATH=/usr/lib/dart-sdk/bin:$PATH
ARG PATH=/root/.pub-cache/bin:$PATH
ARG FLUTTER_VERSION=2.2.0
RUN dart pub global activate fvm --verbose && \
    fvm doctor --verbose && \
    fvm install $FLUTTER_VERSION --verbose && \
    fvm use --force $FLUTTER_VERSION --verbose && \
    fvm flutter config --enable-web --enable-linux-desktop --enable-macos-desktop --enable-windows-desktop --enable-android --enable-ios --enable-fuchsia && \
    # fvm flutter precache --verbose && \
    fvm flutter doctor --verbose

# TODO
# # Install Android sdk
# RUN mkdir -p Android/sdk
# ENV ANDROID_SDK_ROOT /usr/local/Android/sdk
# RUN mkdir -p .android && touch .android/repositories.cfg
# RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
# RUN unzip sdk-tools.zip && rm sdk-tools.zip
# RUN mv tools Android/sdk/tools
# RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
# RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
# ENV PATH "$PATH:/usr/local/Android/sdk/platform-tools"

# terminal setting
RUN apt-get install bash-completion
RUN wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -O /root/.git-completion.bash \
    && wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -O /root/.git-prompt.sh \
    && chmod a+x /root/.git-completion.bash \
    && chmod a+x /root/.git-prompt.sh \
    && echo -e "\n\
    source ~/.git-completion.bash\n\
    source ~/.git-prompt.sh\n\
    export PS1='\\[\\e]0;\\u@\\h: \\w\\a\\]\${debian_chroot:+(\$debian_chroot)}\\[\\033[01;32m\\]\\u\\[\\033[00m\\]:\\[\\033[01;34m\\]\\w\\[\\033[00m\\]\\[\\033[1;30m\\]\$(__git_ps1)\\[\\033[0m\\] \\$ '\n\
    " >>  /root/.bashrc

# Clean up
RUN apt-get clean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Set paths
ENV FVM_ROOT=/root/.pub-cache
ENV PATH $FVM_ROOT/bin:$PATH

ARG WEB_SERVER_PORT=8888
EXPOSE ${WEB_SERVER_PORT}
