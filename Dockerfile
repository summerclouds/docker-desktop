# Builds a base Docker image for Ubuntu with X Windows and VNC support.
#
# The built image can be found at:
#
#   https://hub.docker.com/r/x11vnc/docker-desktop
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM x11vnc/desktop:17.10
LABEL maintainer Xiangmin Jiao <xmjiao@gmail.com>

WORKDIR /tmp

# Install some required system tools and packages for X Windows
RUN add-apt-repository ppa:webupd8team/atom && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        atom \
        meld \
        docker.io && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


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
        platformio-ide-terminal \
        intentions \
        busy-signal \
        linter-ui-default \
        linter \
        linter-flake8 \
        python-autopep8 \
        clang-format && \
    usermod -aG docker $DOCKER_USER && \
    usermod -aG staff $DOCKER_USER && \
    rm -rf /tmp/* && \
    echo '@atom .' >> $DOCKER_HOME/.config/lxsession/LXDE/autostart && \
    chown -R $DOCKER_USER:$DOCKER_GROUP $DOCKER_HOME


WORKDIR $DOCKER_HOME
