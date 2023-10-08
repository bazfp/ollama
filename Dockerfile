FROM nvidia/cuda:11.4.3-devel-ubuntu20.04

ARG TARGETARCH
ARG GOFLAGS="'-ldflags=-w -s'"

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /go/src/github.com/jmorganca/ollama
RUN apt-get update && apt-get install -y git build-essential cmake
ADD https://dl.google.com/go/go1.21.1.linux-$TARGETARCH.tar.gz /tmp/go1.21.1.tar.gz
RUN mkdir -p /usr/local && tar xz -C /usr/local </tmp/go1.21.1.tar.gz

# Get newer CMake
RUN apt-get install wget
RUN wget https://github.com/Kitware/CMake/releases/download/v3.24.1/cmake-3.24.1-Linux-x86_64.sh \
      -q -O /tmp/cmake-install.sh \
      && chmod u+x /tmp/cmake-install.sh \
      && mkdir /opt/cmake-3.24.1 \
      && /tmp/cmake-install.sh --skip-license --prefix=/opt/cmake-3.24.1 \
      && rm /tmp/cmake-install.sh \
      && ln -s /opt/cmake-3.24.1/bin/* /usr/local/bin

COPY . .
ENV GOARCH=$TARGETARCH
ENV GOFLAGS=$GOFLAGS
RUN /usr/local/go/bin/go generate ./... \
    && /usr/local/go/bin/go build .

FROM nvidia/cuda:11.4.3-devel-ubuntu20.04
RUN apt-get update && apt-get install -y ca-certificates && apt-get install -y libc6
COPY --from=0 /go/src/github.com/jmorganca/ollama/ollama /bin/ollama
COPY entrypoint.sh /bin/entrypoint.sh
RUN ["chmod", "+x", "/bin/entrypoint.sh"]
EXPOSE 11434
ENV OLLAMA_HOST 0.0.0.0
ENTRYPOINT ["/bin/entrypoint.sh"]