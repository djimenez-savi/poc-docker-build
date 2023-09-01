SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

name ?= $(shell basename ${SELF_DIR})
version := $(shell helm local-chart-version get -c ${SELF_DIR})

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
