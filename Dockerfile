FROM ubuntu:latest
LABEL maintainer "Ralph Plawetzki <ralph@purejava.org>"
ENV DEBIAN_FRONTEND noninteractive

# Run the docker image as a GUI app on macOS
# ------------------------------------------
# brew install socat
# brew cask install xquartz
# open -a XQuartz (ignore the xterm that opens or close it)
# socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
# docker run -e DISPLAY=<your_IPv4_address>:0 -v ~/Documents/Notebooks/book:/home/developer/Notebooks/book --name zim purejava/docker-zim

RUN apt-get update && apt-get install -y \
  zim \
  python-gtkspellcheck \
  aspell-de \
  python-gtksourceview2 \
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
RUN locale-gen de_DE.UTF-8
ENV LANG de_DE.UTF-8
ENV LANGUAGE de_DE:de
ENV LC_ALL de_DE.UTF-8

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
