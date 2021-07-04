FROM ubuntu:18.04
MAINTAINER Vasily Borodin <vasbrdn@yandex.ru>

ENV DEBIAN_FRONTEND noninteractive
ENV SOFT='/soft'
RUN mkdir $SOFT
#WORKDIR $SOFT

WORKDIR TEMP_installs

RUN apt-get update && apt-get install -y \
	wget \
	build-essential \
	zlib1g-dev \
	libncurses5-dev \
	libbz2-dev \
	liblzma-dev \
	libcurl4-gnutls-dev

# HTSlib 1.12 released 17 Mar 2021
RUN wget https://github.com/samtools/htslib/releases/download/1.12/htslib-1.12.tar.bz2 && \
	appver='htslib-1.12' && \
	tar -xjf ${appver}.tar.bz2 && \
	rm ${appver}.tar.bz2 && \
    cd ${appver} && \
    ./configure --prefix=${SOFT}/${appver} && \
    make && \
    make install && \
    cd .. && rm -r ${appver}
    
ENV PATH=${SOFT}/htslib-1.12/bin:$PATH

# samtools 1.12 released 17 Mar 2021
RUN wget https://github.com/samtools/samtools/releases/download/1.12/samtools-1.12.tar.bz2 && \
	appver='samtools-1.12' && \
	tar -xjf ${appver}.tar.bz2 && \
	rm ${appver}.tar.bz2 && \
	cd ${appver} && \
	./configure --prefix=${SOFT}/${appver} --with-htslib=${SOFT}/htslib-1.12 && \
	make && \
	make install && \
	cd .. && rm -r ${appver}
	
ENV PATH=${SOFT}/samtools-1.12/bin:$PATH

#RUN rm -r TEMP_installs
CMD ["bash"]
