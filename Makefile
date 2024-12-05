ARCHS := x86_64 arm aarch64 powerpc mips mipsel
TARGETS := $(addprefix build-, $(ARCHS))
PACK_TARGETS := $(addprefix pack-, $(ARCHS))
SUBMODULE_PACKAGES := $(wildcard src/submodule_packages/*)
BUILD_PACKAGES_DIR := "build/packages"

.PHONY: clean help download_packages build build-docker-image $(TARGETS) $(PACK_TARGETS)

help:
	@echo "Usage:"
	@echo "  make build"
	@echo ""

	@for target in $(TARGETS); do \
		echo "  $$target"; \
	done

	@echo ""
	@echo "  make clean"

build/build-docker-image.stamp: Dockerfile
	mkdir -p build
	docker build -t gdb-static .
	touch build/build-docker-image.stamp

build-docker-image: build/build-docker-image.stamp

build/download-packages.stamp: build/build-docker-image.stamp src/compilation/download_packages.sh
	mkdir -p $(BUILD_PACKAGES_DIR)
	docker run --user $(shell id -u):$(shell id -g) \
		--rm --volume .:/app/gdb gdb-static env TERM=xterm-256color \
		/app/gdb/src/compilation/download_packages.sh /app/gdb/$(BUILD_PACKAGES_DIR)/
	touch build/download-packages.stamp

build/symlink-git-packages.stamp: $(SUBMODULE_PACKAGES)
	mkdir -p $(BUILD_PACKAGES_DIR)
	ln -sf $(addprefix /app/gdb/, $(SUBMODULE_PACKAGES)) $(BUILD_PACKAGES_DIR)/

symlink-git-packages: build/symlink-git-packages.stamp

download-packages: build/download-packages.stamp

build: $(TARGETS)

$(TARGETS): build-%: symlink-git-packages download-packages build-docker-image
	mkdir -p build
	docker run --user $(shell id -u):$(shell id -g) \
		--rm --volume .:/app/gdb gdb-static env TERM=xterm-256color \
		/app/gdb/src/compilation/build.sh $* /app/gdb/build/ /app/gdb/src

pack: $(PACK_TARGETS)

$(PACK_TARGETS): pack-%: build-%
	if [ ! -f "build/artifacts/gdb-static-$*.tar.gz" ]; then \
		tar -czf "build/artifacts/gdb-static-$*.tar.gz" -C "build/artifacts/$*" .; \
	fi

clean-git-packages:
	git submodule foreach '[[ ! "$$sm_path" == src/submodule_packages/* ]] || git clean -xffd'

clean: clean-git-packages
	rm -rf build
# Kill and remove all containers of image gdb-static
	docker ps -a | grep -P "^[a-f0-9]+\s+gdb-static\s+" | awk '{print $$1}' | xargs docker rm -f 2>/dev/null || true
	docker rmi -f gdb-static 2>/dev/null || true
