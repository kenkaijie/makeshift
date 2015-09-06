#
# Makefile --Build rules for devkit, the developer utilities kit.
#
package = rpm deb
PACKAGE = devkit
VERSION = 0.2
RELEASE = 3

include devkit.mk package.mk

devkit-staging-root:
	$(ECHO_TARGET)
	$(MAKE) install DESTDIR=$$(pwd)/$@ prefix=/usr/local

devkit.mk:
	@echo "you need to do a self-hosted install:"
	@echo "    sh install.sh [make-arg.s...]"
	@false
