PRG = mapimage-c64.prg

# Unix or Windows
ifeq ($(shell echo),)
	CP = cp $1
else
	CP = copy $(subst /,\,$1)
endif

REMOVES += $(PRG)

.PHONY: prg
prg: $(PRG)

$(PRG): mapimage.c64
	$(call CP, $< $@)
