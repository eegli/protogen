FROM ubuntu:latest

WORKDIR /.local

RUN apt update
RUN apt install -y curl
RUN apt install -y unzip

ARG V_COMPILER
ARG V_PLUGIN_JS
ARG V_PLUGIN_GRPC

# Protobuf: https://grpc.io/docs/protoc-installation/
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v${V_COMPILER}/protoc-${V_COMPILER}-linux-x86_64.zip

RUN unzip protoc-${V_COMPILER}-linux-x86_64 -d protoc
RUN chmod +x protoc/bin/protoc

# protobuf-js: https://github.com/protocolbuffers/protobuf-javascript/releases
RUN curl -LO https://github.com/protocolbuffers/protobuf-javascript/releases/download/v${V_PLUGIN_JS}/protobuf-javascript-${V_PLUGIN_JS}-linux-x86_64.zip

# bin folder is created automatically
RUN unzip protobuf-javascript-${V_PLUGIN_JS}-linux-x86_64.zip -d protobuf-js
RUN chmod +x protobuf-js/bin/protoc-gen-js

# gRPC-web: https://github.com/grpc/grpc-web/tree/master#code-generator-plugin

RUN  curl -L -o protoc-gen-grpc-web https://github.com/grpc/grpc-web/releases/download/${V_PLUGIN_GRPC}/protoc-gen-grpc-web-${V_PLUGIN_GRPC}-linux-x86_64
RUN chmod +x protoc-gen-grpc-web
RUN mkdir grpc-web
RUN mv protoc-gen-grpc-web grpc-web/protoc-gen-grpc-web

RUN rm -rf *.zip

ENV PATH=/.local/protoc/bin:$PATH
ENV PATH=/.local/protobuf-js/bin:$PATH
ENV PATH=/.local/grpc-web:$PATH
