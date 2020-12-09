# docker build -t gem5 --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)"  .
# docker run --rm -ti gem5
# En caso de remover los contenedores docker run -it --rm --volumes-from SharedData gem5 
# docker run -ti --rm -v  /home/junavarro/projects/tec/arqui1/p2/sharedData:/home/SharedData gem5 
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ARG ssh_prv_key
ARG ssh_pub_key


WORKDIR /code
#VOLUME  /code/GEM5/gem5/SharedData
RUN apt update -y
RUN apt install -y  openssh-server git build-essential python-dev scons swig m4 zlib1g-dev libpng-dev python-six graphviz
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
WORKDIR GEM5
RUN git clone https://gem5.googlesource.com/public/gem5
# Remove SSH keys
RUN rm -rf /root/.ssh/
WORKDIR gem5
RUN cat /proc/cpuinfo | grep processor | wc -l  | xargs -t -n1  scons build/X86/gem5.opt -j ;
RUN apt install nano
WORKDIR /code
RUN wget http://parsec.cs.princeton.edu/download/2.1/parsec-2.1-core.tar.gz
RUN tar -xf parsec-2.1-core.tar.gz
WORKDIR /code/parsec-2.1/pkgs/apps/blackscholes/inputs/
RUN tar -xf ./input_test.tar
WORKDIR /code/parsec-2.1/pkgs/apps/blackscholes/src
RUN sed -i '284s/.*/\/\/ if (argc != 4)/' blackscholes.c && \
sed -i '285s/.*/\/\/ {/' blackscholes.c && \
sed -i '286s/.*/\/\/ printf(\"Usage:\n\t%s <nthreads> <inputFile> <outputFile>\n\", argv[0]);/' blackscholes.c && \
sed -i '287s/.*/\/\/ exit(1);/' blackscholes.c && \
sed -i '288s/.*/\/\/ }/' blackscholes.c && \
sed -i '289s/.*/nThreads = 1;/' blackscholes.c && \
sed -i '290s/.*/char *inputFile = argv[1];/' blackscholes.c && \
sed -i '291s/.*/char *outputFile = \"prueba\";/' blackscholes.c && \
sed -i '292s/.*/ /' blackscholes.c && \
sed -i '293s/.*/ /' blackscholes.c 
RUN make
RUN apt install -y nano 
WORKDIR /code/parsec-2.1/pkgs/apps/freqmine/inputs
RUN tar -xf ./input_test.tar
WORKDIR /code/parsec-2.1/pkgs/apps/freqmine/src
RUN sed -i '127s/.*/\/\/exit(1);/' fpmax.cpp && \
sed -i '129s/.*/	THRESHOLD = 2;/' fpmax.cpp && \
sed -i '131s/.*/	Data* fdat=new Data(\".\/..\/inputs\/T10I4D100K_3.dat\");/' fpmax.cpp
RUN make
WORKDIR /home/SharedData