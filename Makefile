#-------------------------------- Project --------------------------------------------------#
SHELL := /bin/bash
export
#-------------------------------- Project --------------------------------------------------#

.PHONY: all

all:
	@ if [ -f .prod ]; then echo; echo; echo "DONT USE DEV MAKEFILE ON PROD!"; echo "use command:"; echo "    make -f Makefile.prod {command}"; echo; echo; exit 1; fi

$(MAKECMDGOALS): all ;

start:
	@echo Py Docker Makefile

#-------------------------------- Docker --------------------------------------------------#
DC_COMMAND=docker-compose -f docker-compose.yml
DC_PY=${DC_COMMAND} run --rm --user `id -u`:`id -g` py
DC_PY_ROOT=${DC_COMMAND} run --rm py
#-------------------------------- Docker --------------------------------------------------#
build:
	${DC_COMMAND} build
up:
	${DC_COMMAND} up -d
down:
	${DC_COMMAND} down --remove-orphans
ps:
	${DC_COMMAND} ps
remove-all-data:
	${DC_COMMAND} down --volumes

#-------------------------------- PYTHON --------------------------------------------------#
bash:
	$(DC_PY) bash

bash-root:
	$(DC_PY_ROOT) bash


#--------------------------------- Git ----------------------------------------------------#
GIT_LAST_TAG = $(lastword $(shell git tag --sort=taggerdate))
GIT_VERSION := $(subst -RC, , $(subst v,, $(subst ., ,$(GIT_LAST_TAG))))
GIT_MAJOR := $(word 1, $(GIT_VERSION))
GIT_MINOR := $(word 2, $(GIT_VERSION))
GIT_PATCH := $(word 3, $(GIT_VERSION))
GIT_RC := $(word 4, $(GIT_VERSION))
#--------------------------------- Git ----------------------------------------------------#

tag-major:
ifeq ($(GIT_RC),)
	$(eval tag = v$(shell echo $(GIT_MAJOR) + 1 | bc).0.0)
else
	$(eval tag = v$(GIT_MAJOR).0.0)
endif
	git tag $(tag) -m $(tag)

tag-major-rc:
ifeq ($(GIT_RC),)
	$(eval tag = v$(shell echo $(GIT_MAJOR) + 1 | bc).0.0-RC1)
else
	$(eval tag = v$(GIT_MAJOR).0.0-RC$(shell echo $(GIT_RC) + 1 | bc))
endif
	git tag $(tag) -m $(tag)

tag-minor:
ifeq ($(GIT_RC),)
	$(eval tag = v$(GIT_MAJOR).$(shell echo $(GIT_MINOR) + 1 | bc).0)
else
	$(eval tag = v$(GIT_MAJOR).$(GIT_MINOR).0)
endif
	git tag $(tag) -m $(tag)

tag-minor-rc:
ifeq ($(GIT_RC),)
	$(eval tag = v$(GIT_MAJOR).$(shell echo $(GIT_MINOR) + 1 | bc).0-RC1)
else
	$(eval tag = v$(GIT_MAJOR).$(GIT_MINOR).0-RC$(shell echo $(GIT_RC) + 1 | bc))
endif
	git tag $(tag) -m $(tag)

tag-patch:
ifeq ($(GIT_RC),)
	$(eval tag = v$(GIT_MAJOR).$(GIT_MINOR).$(shell echo $(GIT_PATCH) + 1 | bc))
else
	$(eval tag = v$(GIT_MAJOR).$(GIT_MINOR).$(GIT_PATCH))
endif
	git tag $(tag) -m $(tag)

tag-patch-rc:
ifeq ($(GIT_RC),)
	$(eval tag = v$(GIT_MAJOR).$(GIT_MINOR).$(shell echo $(GIT_PATCH) + 1 | bc)-RC1)
else
	$(eval tag = v$(GIT_MAJOR).$(GIT_MINOR).$(GIT_PATCH)-RC$(shell echo $(GIT_RC) + 1 | bc))
endif
	git tag $(tag) -m $(tag)
