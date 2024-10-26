FROM archlinux:latest

# Use the fastest mirror and update the system
RUN pacman -Sy --noconfirm
RUN pacman -S --noconfirm reflector
RUN reflector --country SE --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Just some things to make life easier
RUN pacman -S neovim git curl wget jdk8-openjdk unzip jdk17-openjdk --noconfirm

# Set java to use version 8
RUN archlinux-java set java-8-openjdk
ENV JAVA_HOME="/usr/lib/jvm/default"

# Prepare Android directories and system variables
RUN mkdir -p /android_install/Android/sdk
ENV ANDROID_SDK_ROOT /android_install/Android/sdk
RUN mkdir -p /root/.android/ && touch /root/.android/repositories.cfg

# Set up Android SDK
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools /android_install/Android/sdk/tools

RUN cd /android_install/Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd /android_install/Android/sdk/tools/bin && ./sdkmanager "build-tools;34.0.0" "platform-tools" "platforms;android-34" "sources;android-34" "cmdline-tools;latest"
ENV PATH "$PATH:/android_install/Android/sdk/platform-tools"

# Flutter installation
WORKDIR /
RUN git clone --depth=1 https://github.com/flutter/flutter.git -b stable
ENV PATH "$PATH:/flutter/bin"
RUN flutter doctor

# JAva 11 AFTER installation of flutter
#RUN pacman -S jdk11-openjdk --noconfirm
RUN archlinux-java set java-11-openjdk

# Let me run git inside the container!
RUN git config --global --add safe.directory /workdir
