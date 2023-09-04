SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

name ?= $(shell basename ${SELF_DIR})
version := $(shell helm local-chart-version get -c ${SELF_DIR})
TAG ?= test

chart-add-repo:
	helm plugin install https://github.com/chartmuseum/helm-push || true
	helm plugin install https://github.com/mbenabda/helm-local-chart-version || true
	helm repo add digital-coupons https://chartmuseum.buildenv.vqpn.net

bump-patch:
	helm local-chart-version bump -s 'patch' -c '${name}'

chart-build-publish: bump-patch
	echo Building helm chart ${name}
	helm dependency update ${name}
	helm package ${name} --app-version $(shell helm local-chart-version get -c '${name}')
	helm cm-push --force ${name}-$(shell helm local-chart-version get -c ${name}).tgz digital-coupons

chart-clean-tgz:
	rm ./*.tgz

docker-build:
	docker build -t 943239102098.dkr.ecr.eu-west-1.amazonaws.com/hello-world:$(TAG) .

docker-pull:
	docker pull 943239102098.dkr.ecr.eu-west-1.amazonaws.com/hello-world:$(TAG)

docker-run:
	docker run --rm -p 127.0.0.1:8082:80 943239102098.dkr.ecr.eu-west-1.amazonaws.com/hello-world:$(TAG)
