#
# devkit.mk --Recursive make considered useful.
#
# Contents:
# build:          --The default target
# INSTALL_*:      --Specialised install commands.
# src:            --Make sure the src target can write to the Makefile
# bindir/archdir: --rules for installing any executable in archdir.
# %.gz:           --Rules for building compressed/summarised data.
# clean:          --Devkit-specific customisations for the "clean" target.
# distclean:      --Remove artefacts that devkit creates/updates.
#
# Remarks:
# The devkit makefiles together define a build system that extends
# the "standard" targets (as documented by GNU make) with a few extras
# for performing common maintenance functions.  The basic principles
# are:
#
#  * the standard make targets are magically recursive
#  * $(LANGUAGE).mk extends standard targets by defining "dependent" actions
#  * per-system tool customisations defined in $(OS).mk, $(ARCH).mk
#  * all system-specific files are saved in $(archdir) subdirectory
#  * file dependencies are auto-included, and auto-generated by build target.
#  * traditional macros work as expected (e.g. CFLAGS, LDFLAGS)
#
# This file defines variables according to the conventions described
# in the GNU make documentation (c.f. "Makefile Conventions" section).
#
# Note that these directories are not truly faithful to the GNU doc.s,
# in particular I avoid the $(archdir) suffix, for most of the
# installation directories.  This is more useful in practice.
#
SUBDIRS := $(shell find * -type d -prune)
#
# ECHO is a shell no-op by default, define it to "echo" for debugging output.
#
ECHO = :
ECHO_TARGET = @$(ECHO) "++ $$PWD $@ < $?"

.SUFFIXES:			# remove default suffix rules

#
# build: --The default target
#
all:	build
#
# Standard directories
#
# Remarks:
# These directories are set according to a blend of the following variables:
# * DESTDIR	-- an alternative root (e.g. chroot jail, pkg-building root)
# * prefix	-- the application's idea of its root installation directory
# * opt		-- FSHS "opt" component (undefined if not FSHS)
# * usr		-- bindir modfier: either undefined or "usr"
# * archdir	-- system+architecture-specific bindir modifier (unused)
#
# In typical usage, DESTDIR should be undefined (it's explicitly set
# as needed by some of the packaging targets), and prefix should be
# set to either "/usr/local" or $HOME (or a subdirectory).  Note that
# GNU make will search for include files in /usr/local/include, so
# installing devkit itself into /usr/local is a win.  However if you
# install devkit into $HOME, you must use/alias make as
# "make -I$HOME/include".
#
archdir         = $(OS)-$(ARCH)
rootdir 	= $(DESTDIR)/$(prefix)
rootdir_opt 	= $(DESTDIR)/$(prefix)/$(opt)
#exec_prefix = $(rootdir)/$(archdir)	# (GNU std)
exec_prefix	= $(rootdir_opt)/$(usr)

bindir		= $(exec_prefix)/bin
sbindir 	= $(exec_prefix)/sbin
#libexecdir	= $(exec_prefix)/libexec/$(archdir)	# (GNU std)
libexecdir	= $(exec_prefix)/libexec/$(subdir)
datadir		= $(exec_prefix)/share/$(subdir)

sysconfdir	= $(rootdir)/etc/$(opt)/$(subdir)
divertdir	= $(rootdir)/var/lib/divert/$(subdir)
sharedstatedir	= $(rootdir_opt)/com/$(subdir)
localstatedir	= $(rootdir)/var/$(opt)/$(subdir)
srvdir 		= $(rootdir)/srv/$(subdir)
wwwdir 		= $(rootdir)/srv/www/$(subdir)

#libdir		= $(exec_prefix)/lib/$(archdir)	# (GNU std)
libdir		= $(exec_prefix)/lib/$(subdir)
infodir		= $(rootdir_opt)/info
lispdir		= $(rootdir_opt)/share/emacs/site-lisp

includedir	= $(rootdir_opt)/$(usr)/include/$(subdir)
mandir		= $(datadir)/man
man1dir		= $(mandir)/man1
man2dir		= $(mandir)/man2
man3dir		= $(mandir)/man3
man4dir		= $(mandir)/man4
man5dir		= $(mandir)/man5
man6dir		= $(mandir)/man6
man7dir		= $(mandir)/man7
man8dir		= $(mandir)/man8

#
# INSTALL_*: --Specialised install commands.
#
INSTALL 	   = install -D
INSTALL_PROGRAM   = $(INSTALL) -m 755
INSTALL_FILE      = $(INSTALL) -m 644
INSTALL_DIRECTORY = $(INSTALL) -d
#
# Common patterns for installing stuff
#
$(bindir)/%:		%;	$(INSTALL_PROGRAM) $? $@
$(sbindir)/%:		%;	$(INSTALL_PROGRAM) $? $@
$(libexecdir)/%:	%;	$(INSTALL_PROGRAM) $? $@
$(libdir)/%:		%;	$(INSTALL_FILE) $? $@

#
# src: --Make sure the src target can write to the Makefile
#
src:			file-writable[Makefile]

#
# bindir/archdir: --rules for installing any executable in archdir.
#
$(bindir)/%:		$(archdir)/%;	$(INSTALL_PROGRAM) $? $@
$(libexecdir)/%:	$(archdir)/%;	$(INSTALL_PROGRAM) $? $@
#$(libdir)/%:		$(archdir)/%;	$(INSTALL_FILE) $? $@

#
# %.gz: --Rules for building compressed/summarised data.
#
%.gz:			%;		gzip -9 <$? >$@
%.gpg:			%;		gpg -b -o $? $@
%.sum:			%;		sum $? | sed -e 's/ .*//' >$@
%.md5:			%;		md5sum $? | sed -e 's/ .*//' >$@

#
# clean: --Devkit-specific customisations for the "clean" target.
#
clean:	devkit-clean
.PHONY:	devkit-clean
devkit-clean:
	$(ECHO_TARGET)
	$(RM) core *~ *.bak *.tmp *.out

#
# distclean: --Remove artefacts that devkit creates/updates.
#
distclean:	devkit-clean devkit-distclean
.PHONY:	devkit-distclean
devkit-distclean:
	$(ECHO_TARGET)
	$(RM) tags TAGS
	$(RM) -r $(OS) $(ARCH) $(archdir)

include targets.mk valid.mk
include lang/mk.mk $(SRC_LANG:%=lang/%.mk)
include os/$(OS).mk
include arch/$(ARCH).mk
include vcs/$(VCS).mk

#
# var[%]:	--pattern rule to print a make variable.
#
+vars:   $(.VARIABLES:%=+var[%])
+var[%]:
	@echo "# $(origin $*) variable \"$*\":"
	@echo "$* = '$($*)'"
+var[ECHO_TARGET]:
	@echo "# $(origin ECHO_TARGET) variable \"ECHO_TARGET\":"
	@echo "ECHO_TARGET = (unprintable)"

#
# +help: --Output some help text extracted from the included makefiles.
#
+help:
	@mk-help $(MAKEFILE_LIST)
