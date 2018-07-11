# # If the first argument is "run"...
# ifeq (scan,$(firstword $(MAKECMDGOALS)))
#   # use the rest as arguments for "run"
#   RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
#   # ...and turn them into do-nothing targets
#   $(eval $(RUN_ARGS):;@:)
# endif

DOCKER_IMAGE_VERSION=0.3
DOCKER_IMAGE_NAME=kammin/clair_scanner
DOCKER_IMAGE_TAGNAME=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

build:
	docker build -t $(DOCKER_IMAGE_TAGNAME) .
	docker tag $(DOCKER_IMAGE_TAGNAME) $(DOCKER_IMAGE_NAME):latest
#
# scan:
# 	docker run --rm --network="docker_scan" -v /var/run/docker.sock:/var/run/docker.sock $(DOCKER_IMAGE_TAGNAME) clair-scanner --ip ${SCANNER_IP} --clair="http://${CLAIR_IP}:6060" $(RUN_ARGS)
