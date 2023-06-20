#!/usr/bin/env bash

if [[ -z $1 ]]; then
    echo "Error: Missing input directory"
    exit 1
else 
    IN_DIR=$1
    echo "Using input directory $IN_DIR"
fi

if [[ -z $2 ]]; then
    OUT_DIR=gen/proto
    echo "Using default output directory $OUT_DIR"
else 
    OUT_DIR=$2
    echo "Using output directory $OUT_DIR"
fi

# Feel free to adjust versions
V_COMPILER=23.3
V_PLUGIN_JS=3.21.2
V_PLUGIN_GRPC=1.4.2

# Temporary container name
CONTAINER_NAME=protogen_tmp

# Image name
IMAGE=protogen

echo "Generating TS proto files..."

# Pass in versions as build args
docker build -t $IMAGE . \
    --build-arg V_COMPILER=$V_COMPILER \
    --build-arg V_PLUGIN_JS=$V_PLUGIN_JS \
    --build-arg V_PLUGIN_GRPC=$V_PLUGIN_GRPC

docker run -t -d --rm --name $CONTAINER_NAME $IMAGE

docker cp $IN_DIR $CONTAINER_NAME:/.local/_proto_in

docker exec -it $CONTAINER_NAME bash -c "mkdir _proto_out"

docker exec -it $CONTAINER_NAME bash -c "protoc \
  --js_out=import_style=commonjs,binary:_proto_out \
  --grpc-web_out=import_style=typescript,mode=grpcweb:_proto_out \
  -I _proto_in \
  _proto_in/*.proto"

mkdir -p  $OUT_DIR

docker cp $CONTAINER_NAME:/.local/_proto_out/. $OUT_DIR

echo "Exiting container $CONTAINER_NAME..."
docker stop $CONTAINER_NAME >/dev/null
echo "Done. Proto files saved to $PWD/$OUT_DIR"