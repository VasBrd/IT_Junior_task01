FROM ubuntu:18.04
MAINTAINER Vasily Borodin <vasbrdn@yandex.ru>

ENV DEBIAN_FRONTEND noninteractive
ENV SOFT='/soft'
RUN mkdir $SOFT
#WORKDIR $SOFT


CMD ["bash"]
