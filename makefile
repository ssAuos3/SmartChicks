# This how we want to name the binary output
BINARY=SC

# These are the values we want to pass for VERSION and BUILD
VERSION=v0.0.1
BUILD=`date +%FT%T%z`

# Target directory
TAR_DIR=./

LDFLAGS=-ldflags "-X ${BINARY}/version.BINARY=${BINARY}  -X ${BINARY}/version.Version=${VERSION} -X ${BINARY}/version.Build=${BUILD} "

all:build_linux 
	
build_linux:	
	GOOS=linux  GOARCH=amd64 go build  -mod=vendor -tags=jsoniter ${LDFLAGS}  -o ${BINARY}
	
clean:
	go clean

release:
	rm -f ./${BINARY}
	mkdir -p ./release/logs
	make build_linux
	cp -r ${BINARY} config      makefile     ./release
	tar -czf  ${BINARY}_${VERSION}.tgz  ./release 

start:
	nohup ./${BINARY} & 
	echo -e "\n"

stop:
	cat /tmp/SC.pid | xargs kill


.PHONY:clean  release start stop