FROM centos:7

LABEL Author="Yu Chen"

RUN yum install -y centos-release-scl epel-release
RUN yum install -y devtoolset-7-gcc-* cmake3 git
RUN ln -s /usr/bin/cmake3 /usr/bin/cmake

RUN git clone -b v0.35.3 --single-branch https://github.com/nvm-sh/nvm.git .nvm
RUN bash -c 'export NVM_NODEJS_ORG_MIRROR=http://npm.taobao.org/mirrors/node && \
                source .nvm/nvm.sh && \
                source .nvm/bash_completion && \
                nvm install 12.16.0 && \
                npm i -g node-gyp cmake-js --registry=https://r.npm.taobao.org'

RUN echo "source /.nvm/nvm.sh" >> /init.sh
RUN echo "source /.nvm/bash_completion" >> /init.sh
RUN echo "source scl_source enable devtoolset-7" >> /init.sh

RUN yum install -y make
RUN bash -c 'source /init.sh && cmake-js 2>&1 > /dev/null || true && ELECTRON_MIRROR=http://npm.taobao.org/mirrors/atom-shell cmake-js --runtime=electron --runtime-version=5.0.10 2>&1 > /dev/null || true'
