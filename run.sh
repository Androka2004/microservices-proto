#!/bin/bash
GITHUB_USERNAME=Androka2004
GITHUB_EMAIL=dev.andrey2004@gmail.com

RELEASE_VERSION=v1.2.3

go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
export PATH="$PATH:$(go env GOPATH)/bin"

for SERVICE_NAME in payment order shipping; do
  echo "Generating Go source code for ${SERVICE_NAME}"
  mkdir -p golang/${SERVICE_NAME}
  protoc --go_out=./golang/${SERVICE_NAME} \
    --go_opt=paths=source_relative \
    --go-grpc_out=./golang/${SERVICE_NAME} \
    --go-grpc_opt=paths=source_relative \
    --proto_path=./${SERVICE_NAME} \
    ./${SERVICE_NAME}/${SERVICE_NAME}.proto

  echo "Generated Go source code files for ${SERVICE_NAME}"
  ls -al ./golang/${SERVICE_NAME}

  cd golang/${SERVICE_NAME}
  go mod init \
    github.com/${GITHUB_USERNAME}/microservices-proto/golang/${SERVICE_NAME} || true
  go mod tidy || true
  cd ../../
done
