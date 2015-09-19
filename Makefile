all:  wrapper onetimeserver-go install-local

wrapper: wrapper/wrapper.c wrapper/wrapper
	gcc -g -o wrapper/onetimeserver-wrapper wrapper/wrapper.c

onetimeserver-go:
	go install github.com/osheroff/onetimeserver/...

DIR=${HOME}/.onetimeserver/$(shell uname -s)-$(shell uname -m)

release: onetimeserver-crossbuild

onetimeserver-crossbuild:
	env GOOS=linux GOARCH=386 go build -o onetimeserver-binaries/onetimeserver-go/linux/onetimeserver-go cmd/onetimeserver-go/main.go
	env GOOS=darwin GOARCH=386 go build -o onetimeserver-binaries/onetimeserver-go/darwin/onetimeserver-go cmd/onetimeserver-go/main.go

install-local:
	mkdir -p $(DIR)
	cp wrapper/wrapper $(DIR)
	cp ${GOPATH}/bin/onetimeserver-go $(DIR)


