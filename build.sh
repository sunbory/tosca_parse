#!/bin/bash -

set -eu

VERSION="0.0.1.beta"
GITCOMMIT=$(git rev-parse HEAD)
BUILDTIME=$(date -u +%Y/%m/%d-%H:%M:%S)

LDFLAGS="-X main.VERSION=$VERSION -X main.BUILDTIME=$BUILDTIME -X main.GITCOMMIT=$GITCOMMIT"
if [[ -n "${EX_LDFLAGS:-""}" ]]
then
	LDFLAGS="$LDFLAGS $EX_LDFLAGS"
fi

build() {
	echo "$1 $2 ..."
	GOOS=$1 GOARCH=$2 go build \
		-ldflags "$LDFLAGS" \
		-o dist/tosca_parse-${3:-""}
}

# go-bindata-assetfs -tags bindata res/...

build linux arm linux-arm
build darwin amd64 mac-amd64
build linux amd64 linux-amd64
build linux 386 linux-386
# build windows amd64 win-amd64.exe
