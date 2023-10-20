APP := $(shell head -n 1 "shard.yml"|cut -d ':' -f 2|tr -d ' ')
VERSION := $(shell sed '2!d' "shard.yml"|cut -d ':' -f 2|tr -d ' ')
DEST = /tmp/${APP}

all: build

bin:
	mkdir -p bin

bin/${APP}:
	crystal build src/${APP}.cr -o bin/${APP} --release --stats

build: bin bin/${APP}

dependencies:
	shards install

${DEST}:
	mkdir -p ${DEST}

${APP}-${VERSION}.tar.gz: build ${DEST}
	mkdir -p ${DEST}/config
	cp bin/* ${DEST}/
	cp -r service/ ${DEST}/
	cp README.md ${DEST}/
	tar cvfJ "${APP}-${VERSION}.tar.xz" -C /tmp/ ${APP}
	rm -rf ${DEST}

extract: ${APP}-${VERSION}.tar.gz

clean:
	rm -f bin/${APP}
	rm -rf ${DEST}
