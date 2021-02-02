EDJE_OPTS =
EDJE_CMD = edje_cc -id images -fd /usr/share/fonts/misc -sd sounds $(EDJE_OPTS)

all: dark-fir.edj

dark-fir.edj: dark-fir.edc df-*.edc
	$(EDJE_CMD) $< $@
