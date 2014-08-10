#
# PYTHON.MK --Rules for building PYTHON objects and programs.
#
# Contents:
# python-clean: --Remove script executables.
# python-toc:   --Build the table-of-contents for PYTHON-ish files.
# python-src:   --python-specific customisations for the "src" target.
# todo:         --Report unfinished work (identified by keyword comments)
#
# Remarks:
# I haven't used python yet...
#

#
# %.py:		--Rules for installing python scripts
#
pythonlibdir      = $(exec_prefix)/lib/python/$(subdir)
PY_TRG = $(PY_SRC:%.py=%)

%:			%.py;	$(INSTALL_PROGRAM) $? $@
$(pythonlibdir)/%.py:	%.py;	$(INSTALL_FILE) $? $@

pre-build:	src-var-defined[PY_SRC]
build:	$(PY_TRG)

#
# python-clean: --Remove script executables.
#
.PHONY: python-clean
clean:	python-clean
python-clean:
	$(RM) $(PY_TRG)

#
# python-toc: --Build the table-of-contents for PYTHON-ish files.
#
.PHONY: python-toc
toc:	python-toc
python-toc:
	$(ECHO_TARGET)
	mk-toc $(PY_SRC)

#
# python-src: --python-specific customisations for the "src" target.
#
.PHONY:	python-src
src:	python-src
python-src:
	$(ECHO) "++ make[$@]@$$PWD"
	@mk-filelist -qn PY_SRC *.py
#
# todo: --Report unfinished work (identified by keyword comments)
#
.PHONY: python-todo
todo:	python-todo
python-todo:
	$(ECHO_TARGET)
	@$(GREP) -e TODO -e FIXME -e REVISIT $(PY_SRC) /dev/null || true
