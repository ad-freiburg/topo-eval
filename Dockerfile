FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --no-install-recommends -y\
       ca-certificates  \
       make \
       cmake \
       libglpk-dev \
	   g++ \
       git

RUN git clone --recurse-submodules https://github.com/ad-freiburg/loom /loom

RUN cd /loom && rm -rf build && mkdir build && cd build && cmake .. && make -j20 topo && make -j20 topoeval

RUN mkdir -p /output

COPY Makefile /
COPY README.md /
ADD datasets /datasets

ENV PATH $PATH:/loom/build

WORKDIR /

RUN make help

ENTRYPOINT ["make", "RESULTS_DIR=/output"]
