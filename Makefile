# Makefile for Oracle Database 12c  Docker Image
# Version: 2018-03-30
# Maintainer: nochmu <github@nochmu.net>
#

INSTALL_ZIP=linuxx64_12201_database.zip
DB_VERSION=12.2.0.1
BUILD_ARGS=-v $(DB_VERSION) -e   # Enterprise Edition 

## Shortcuts
DOCKER_IMAGES=docker-images
DOCKERFILES_DIR=$(DOCKER_IMAGES)/OracleDatabase/SingleInstance/dockerfiles
INSTALL_BINS=$(DOCKERFILES_DIR)/$(DB_VERSION)/$(INSTALL_ZIP)

# Targets
.PHONY: clean check image patch


$(DOCKER_IMAGES) : 
	git clone  https://github.com/oracle/docker-images.git $@

$(INSTALL_BINS) : $(DOCKER_IMAGES)  
#	ln -f ../../../../../downloads/$(INSTALL_ZIP) $(DOCKERFILES_DIR)/$(DB_VERSION)/
	cp downloads/$(INSTALL_ZIP) $(DOCKERFILES_DIR)/$(DB_VERSION)/

patch : $(DOCKER_IMAGES) 
	-patch -p1 -Nfi  patches/*


image : $(INSTALL_BINS) $(DOCKER_IMAGES) patch
	cd $(DOCKERFILES_DIR) && \
	./buildDockerImage.sh $(BUILD_ARGS) 

clean : 
	rm -rf docker-images

clean_downloads:
	$(MAKE) -C downloads clean 
