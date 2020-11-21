# docker build -t gem5 --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" --squash .
# docker run -ti gem5
# docker run -it --rm --volumes-from SharedData gem5 
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ARG ssh_prv_key
ARG ssh_pub_key


WORKDIR /code
VOLUME  /SharedData
RUN apt update -y
RUN apt install -y  openssh-server git build-essential python-dev scons swig m4 zlib1g-dev python-six
RUN apt install -y libprotobuf-dev python-protobuf protobuf-compiler libgoogle-perftools-dev python3-pip python3-virtualenv
# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0644 /root/.ssh && \
    ssh-keyscan gitlab.com > /root/.ssh/known_hosts

#RUN ssh-keygen -m PEM -t rsa -P "" -f /root/.ssh/id_rsa.pub

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /root/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /root/.ssh/id_rsa.pub && \
    chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub


RUN  echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config

# RUN virtualenv -p python3 .
RUN pip3 install pydot gem5art-artifact gem5art-run gem5art-tasks
RUN mkdir GEM5 
WORKDIR GEM5
RUN git clone https://gem5.googlesource.com/public/gem5
# Remove SSH keys
RUN rm -rf /root/.ssh/
WORKDIR gem5
RUN cat /proc/cpuinfo | grep processor | wc -l  | xargs -t -n1  scons build/X86/gem5.opt -j ;

