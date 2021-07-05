FROM ubuntu:18.04
MAINTAINER Vasily Borodin <vasbrdn@yandex.ru>

ENV DEBIAN_FRONTEND noninteractive
ENV SOFT='/soft'
RUN mkdir $SOFT

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
	tar -xjf *.tar.bz2 && \
	rm *.tar.bz2 && \
    cd ${appver} && \
    ./configure --prefix=${SOFT}/${appver} && \
    make && \
    make install && \
    cd .. && rm -r ${appver}
    
ENV PATH=${SOFT}/htslib-1.12/bin:$PATH


# samtools 1.12 released 17 Mar 2021
RUN wget https://github.com/samtools/samtools/releases/download/1.12/samtools-1.12.tar.bz2 && \
	appver='samtools-1.12' && \
	tar -xjf *.tar.bz2 && \
	rm *.tar.bz2 && \
	cd ${appver} && \
	./configure --prefix=${SOFT}/${appver} --with-htslib=${SOFT}/htslib-1.12 && \
	make && \
	make install && \
	cd .. && rm -r ${appver}
	
ENV PATH=${SOFT}/samtools-1.12/bin:$PATH


# libdeflate released 10 Nov 2020
RUN wget https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.7.tar.gz && \
	appver='libdeflate-1.7' && \
	tar -xzf *.tar.gz && \
	rm *.tar.gz && \
	cd ${appver} && \
	make && \
	make install PREFIX=${SOFT}/${appver} && \
	cd .. && rm -r ${appver}
	
ENV PATH=${SOFT}/libdeflate-1.7/bin:$PATH

# gcc-9 and g++-9
# updating compiler since the one form ubuntu:18.04 is outdated for the build of current release of libmaus2 -  
RUN apt install -y software-properties-common && \
	add-apt-repository ppa:ubuntu-toolchain-r/test && \
	apt update && \
	apt install -y gcc-9 g++-9 && \
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9

# libmaus2 released 26 Jun 2021
RUN wget https://gitlab.com/german.tischler/libmaus2/-/archive/2.0.791-release-20210626211042/libmaus2-2.0.791-release-20210626211042.tar.bz2 && \
	appver='libmaus2-2.0.791-release-20210626211042' && \
	tar -xjf *.tar.bz2 && \
	rm *.tar.bz2 && \
    cd ${appver} && \
    ./configure --prefix=${SOFT}/${appver%-release*} && \
    make && \
    make install && \
	cd .. && rm -r ${appver}
	
#--with-libdeflate ?

ENV PATH=${SOFT}/libmaus2-2.0.791/bin:$PATH


RUN apt-get install -y pkg-config

# biobambam2 released 12 Apr 2021
RUN wget https://gitlab.com/german.tischler/biobambam2/-/archive/2.0.182-release-20210412001032/biobambam2-2.0.182-release-20210412001032.tar.bz2 && \
	appver='biobambam2-2.0.182-release-20210412001032' && \
	tar -xjf *.tar.bz2 && \
	rm *.tar.bz2 && \
    cd ${appver} && \
    ./configure --prefix=${SOFT}/${appver%-release*} \
    	--with-libmaus2=${SOFT}/libmaus2-2.0.791 && \
    make && \
    make install && \
	cd .. && rm -r ${appver}

ENV PATH=${SOFT}/biobambam2-2.0.182/bin:$PATH

#RUN rm -r TEMP_installs
CMD ["bash"]
