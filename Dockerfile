FROM ubuntu:latest
LABEL maintainer "Ralph Plawetzki <ralph@purejava.org>"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
  zim \
  hicolor-icon-theme \
  libcanberra-gtk-module \
  bzr \
  git \
  locales \
  sudo \
  --no-install-recommends \
  && apt-get autoclean \
  && apt-get autoremove \
  && rm -rf /var/lib/apt/lists/*

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
  mkdir -p /home/developer && \
  echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
  echo "developer:x:${uid}:" >> /etc/group && \
  echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
  chmod 0440 /etc/sudoers.d/developer && \
  chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer

CMD [ "zim","--standalone" ]