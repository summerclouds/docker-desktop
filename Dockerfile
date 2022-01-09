# Builds a base Docker image for Ubuntu with X Windows and VNC support.
#
# The built image can be found at:
#
#   https://hub.docker.com/r/x11vnc/docker-desktop
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

#FROM x11vnc/desktop:master
FROM x11vnc-desktop
LABEL maintainer Xiangmin Jiao <xmjiao@gmail.com>

WORKDIR /tmp
ADD image/etc /etc

ARG DEBIAN_FRONTEND=noninteractive 

# Install some required system tools and packages for X Windows
RUN apt install software-properties-common apt-transport-https wget && \
    wget -q https://packagecloud.io/AtomEditor/atom/gpgkey -O- | sudo apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" && \
    apt-get install -y --no-install-recommends \
        automake \
        autoconf \
        gettext \
        libtool-bin \
        libltdl-dev \
        ruby \
        ruby-dev \
        atom \
        meld \
        docker.io && \
    apt-get -y autoremove && \
    gem install travis && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ADD image/home $DOCKER_HOME

########################################################
# Customize atom
########################################################
RUN pip install -U \
        autopep8 flake8 &&\
    apm install \
        language-docker \
        autocomplete-python \
        git-plus \
        merge-conflicts \
        split-diff \
        intentions \
        busy-signal \
        linter-ui-default \
        linter \
        linter-flake8 \
        python-autopep8 \
        clang-format && \
    rm -rf /tmp/* && \
    \
    chown -R $DOCKER_USER:$DOCKER_GROUP $DOCKER_HOME

WORKDIR $DOCKER_HOME
