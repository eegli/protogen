FROM ubuntu:latest

WORKDIR /.local

RUN apt update
RUN apt install -y curl
RUN apt install -y unzip

# Protobuf: https://grpc.io/docs/protoc-installation/
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v23.3/protoc-23.3-linux-x86_64.zip

RUN unzip protoc-23.3-linux-x86_64 -d protoc
RUN chmod +x protoc/bin/protoc

# protobuf-js: https://github.com/protocolbuffers/protobuf-javascript/releases
RUN curl -LO https://github.com/protocolbuffers/protobuf-javascript/releases/download/v3.21.2/protobuf-javascript-3.21.2-linux-x86_64.zip

# bin folder is created automatically
RUN unzip protobuf-javascript-3.21.2-linux-x86_64.zip -d protobuf-js
RUN chmod +x protobuf-js/bin/protoc-gen-js

# gRPC-web: https://github.com/grpc/grpc-web/tree/master#code-generator-plugin

RUN curl -L -o protoc-gen-grpc-web https://github.com/grpc/grpc-web/releases/download/1.4.2/protoc-gen-grpc-web-1.4.2-linux-x86_64
RUN chmod +x protoc-gen-grpc-web
RUN mkdir grpc-web
RUN mv protoc-gen-grpc-web grpc-web/protoc-gen-grpc-web

RUN rm -rf *.zip

ENV PATH=/.local/protoc/bin:$PATH
ENV PATH=/.local/protobuf-js/bin:$PATH
ENV PATH=/.local/grpc-web:$PATH
