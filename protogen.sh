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

# temporary container name
C=protogen_tmp

# image name
I=protogen

echo "Generating TS proto files..."

# Remove old container and image
docker rmi $I >/dev/null 2>&1

docker build -t $I .

docker run -t -d --rm --name $C $I

docker cp $IN_DIR $C:/.local/_proto_in

docker exec -it $C bash -c "mkdir _proto_out"

docker exec -it $C bash -c "protoc \
  --js_out=import_style=commonjs,binary:_proto_out \
  --grpc-web_out=import_style=typescript,mode=grpcweb:_proto_out \
  -I _proto_in \
  _proto_in/*.proto"

mkdir -p  $OUT_DIR

docker cp $C:/.local/_proto_out/. $OUT_DIR

echo "Exiting container $C..."
docker stop $C >/dev/null
echo "Done. Proto files saved to $PWD/$OUT_DIR"