### MUST BE COMPILED IN UNIX/LINUX ENVIRONMENT ###

OPTS=-O2
BINDIR=bin
SRC=$(basename $(wildcard *.adb))
OUTFILES=$(foreach f,$(basename $(SRC)),$(BINDIR)/$(f))

.DEFAULT_GOAL := default

ifdef QUIET
QUIETIN:=2>&1
QUIETOUT:=>/dev/null
endif

$(BINDIR)/%: %.adb
	@echo "Rebuilding $(notdir $@)"
	@mkdir -p $@
	@{ gnatmake $(OPTS) -D $@ -o $@/$(notdir $@) $(notdir $@).adb $(QUIETIN) ; } $(QUIETOUT)

clean:
	@rm -rfv $(OUTFILES)

all: $(OUTFILES)
	@echo >/dev/null

default: clean all
	@echo >/dev/null

.PHONY: all clean default
