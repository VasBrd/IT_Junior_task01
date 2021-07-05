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
	libcurl4-gnutls-dev \
	pkg-config \
	sudo



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
ENV LIBDEFLATEGUNZIP=${SOFT}/libdeflate-1.7/bin/libdeflate-gunzip \
	LIBDEFLATEGZIP=${SOFT}/libdeflate-1.7/bin/libdeflate-gzip



# HTSlib 1.12 released 17 Mar 2021
RUN wget https://github.com/samtools/htslib/releases/download/1.12/htslib-1.12.tar.bz2 && \
	appver='htslib-1.12' && \
	tar -xjf *.tar.bz2 && \
	rm *.tar.bz2 && \
    cd ${appver} && \
    ./configure --prefix=${SOFT}/${appver} && \
    make && \
    make install && \
    cd .. && rm -r ${appver} && \
    ldconfig
    
ENV PATH=${SOFT}/htslib-1.12/bin:$PATH \
	LD_LIBRARY_PATH=${SOFT}/htslib-1.12/lib



# samtools 1.12 released 17 Mar 2021
RUN wget https://github.com/samtools/samtools/releases/download/1.12/samtools-1.12.tar.bz2 && \
	appver='samtools-1.12' && \
	tar -xjf *.tar.bz2 && \
	rm *.tar.bz2 && \
	cd ${appver} && \
	./configure --prefix=${SOFT}/${appver} --with-htslib=$(echo ${SOFT}/htslib-*) && \
	make && \
	make install && \
	cd .. && rm -r ${appver}
	
ENV PATH=${SOFT}/samtools-1.12/bin:$PATH
ENV SAMTOOLS=${SOFT}/samtools-1.12/bin/samtools \
	ACE2SAM=${SOFT}/samtools-1.12/bin/ace2sam \
	FASTASANITIZE=${SOFT}/samtools-1.12/bin/fasta-sanitize.pl \   
	MD5FA=${SOFT}/samtools-1.12/bin/md5fa \               
	PLOTBAMSTATS=${SOFT}/samtools-1.12/bin/plot-bamstats \  
	SAMTOOLS.PL=${SOFT}/samtools-1.12/bin/samtools.pl \            
	WGSIM_EVAL=${SOFT}/samtools-1.12/bin/wgsim_eval.pl \
	BLAST2SAM=${SOFT}/samtools-1.12/bin/blast2sam.pl \   
	INTERPOLATE_SAM=${SOFT}/samtools-1.12/bin/interpolate_sam.pl \  
	MD5SUMLITE=${SOFT}/samtools-1.12/bin/md5sum-lite \         
	PSL2SAM=${SOFT}/samtools-1.12/bin/psl2sam.pl  \    
	SEQ_CACHE_POPULATE=${SOFT}/samtools-1.12/bin/seq_cache_populate.pl \  
	ZOOM2SAM=${SOFT}/samtools-1.12/bin/zoom2sam.pl \
	BOWTIE2SAM=${SOFT}/samtools-1.12/bin/bowtie2sam.pl \  
	MAQ2SAM=${SOFT}/samtools-1.12/bin/maq2sam-long \        
	NOVO2SAM=${SOFT}/samtools-1.12/bin/novo2sam.pl \         
	SAM2VCF=${SOFT}/samtools-1.12/bin/sam2vcf.pl \     
	SOAP2SAM=${SOFT}/samtools-1.12/bin/soap2sam.pl \
	EXPORT2SAM=s${SOFT}/amtools-1.12/bin/export2sam.pl \  
	MAQ2SAM=${SOFT}/samtools-1.12/bin/maq2sam-short  \      
	PLOTAMPLICONSTATS=${SOFT}/samtools-1.12/bin/plot-ampliconstats \      
	WGSIM=${SOFT}/samtools-1.12/bin/wgsim 



# gcc-9 and g++-9
# updating compiler since the one included in ubuntu:18.04 is outdated for the build of current release of libmaus2
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
    ./configure --prefix=${SOFT}/${appver%-release*}  && \
    make && \
    cd . && \
    make install && \
	cd .. && rm -r ${appver}
	
ENV PATH=${SOFT}/libmaus2-2.0.791/bin:$PATH



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

RUN adduser --shell /bin/bash --disabled-password --gecos '' theuser
WORKDIR /home/theuser
RUN rm -rf /TEMP_installs 
USER    theuser

CMD ["bash"]
