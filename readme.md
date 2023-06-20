# Protogen - Protobuf/gRPC-Web Wizard

Generating client/server code for gRPC-web is painful. It requires a lot of manual work with the protobuf compiler, including dealing with plugins from three different projects. Here's a no-install, all-in-one solution using temporary Docker containers.

As opposed to other projects like [protobuf-ts](https://github.com/timostamm/protobuf-ts) or [ts-proto](https://github.com/stephenh/ts-proto), all tooling uses the official protobuf compiler and plugins.

### What does it do?

It facilitates code generation for [gRPC-web](https://github.com/grpc/grpc-web#code-generator-plugin) and [protobuf-javascript](https://github.com/protocolbuffers/protobuf-javascript). Running the example command from the [grpc/grpc-web](https://github.com/grpc/grpc-web#code-generator-plugin) repository

```bash
protoc -I=$DIR echo.proto \
    --js_out=import_style=commonjs:$OUT_DIR \
    --grpc-web_out=import_style=commonjs,mode=grpcwebtext:$OUT_DIR
```

requires (1) the `protoc` compiler (`protoc`), (2) the `protoc-gen-js` plugin (`--js_out`), and (3) the `protoc-gen-grpc-web` plugin (`--grpc-web_out`).

### How does it do it?

This project builds a temporary Docker container with all the binaries, then uses the local (i.e., host) `.proto` files for code generation and finally copies the generated files back to the host.

### Usage

```bash
./protogen.sh <proto_input_dir> <proto_output_dir>
```

- `<proto_input_dir>`: Relative input directory with `.proto` files. Required.
- `<proto_output_dir>`: Relative directory to save the output `.proto` files. Defaults to `gen/proto`.

### Examples

```bash
./protogen.sh proto proto_out
```

```bash
./protogen.sh proto

```
