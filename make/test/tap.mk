#
# TAP.MK --Rules for running unit tests.
#
# Remarks:
# This defines some tap-specific targets related to testing,
# and actions that are triggered by the "test" target.
#
TAP_TRG	= $(TAP_TESTS:%=%.tap)
%.tap:	%;	./$* > $@
%.tap:	%.t;	perl $*.t > $@

pre-test:	var-defined[TAP_TESTS]
test:	test-tap
test-tap:	$(TAP_TESTS)
	prove $(PROVE_FLAGS) $(TAP_TESTS)

test[%]:        %;      ./$*

#
# tap: --make the tap files explicitly
#
.PHONY:	tap
tap:	$(TAP_TRG)

clean:		clean-tap
distclean:	clean-tap

.PHONY:		clean-tap
clean-tap:
	$(RM) $(TAP_TRG)