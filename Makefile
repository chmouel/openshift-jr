# Just a Makefile for manual testing
.PHONY: all

all: build

build:
	docker build -t quay.io/chmouel/openshift-jr:latest . && docker push quay.io/chmouel/openshift-jr:latest
