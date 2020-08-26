
.SUFFIXES: 
.SUFFIXES: .s .c

PATH_TO_ORICUTRON="C:\Users\Public\Oricutron"

OSDK="C:\Users\Public\osdk_1_16\Bin"

LIBNAME=gl65
PROGNAME=main

PLATFORM=atmos

XA=$(OSDK)/xa.exe

AS=ca65	
ASFLAGS=-t$(PLATFORM) -g --include-dir . -D SCREEN_WIDTH=40 -D SCREEN_HEIGHT=26

CC=cc65
CFLAGS= -g -D SCREEN_WIDTH=40 -D SCREEN_HEIGHT=26

AR=ar65
ARFLAGS=r

LD=cl65
#LDFLAGS=-v -vm -g -t$(PLATFORM) 
LDFLAGS= -t$(PLATFORM) -Cl -O -C atmosc.cfg
#SRC_ASM= camera.asm temp.asm fill8.asm zbuff.asm hzfill.asm projection.asm glProjectPoint.asm scene.asm
#SRC_C= glOric_c.c
#OBJS= $(SRC_ASM:.asm=.o) $(SRC_C:.c=.o)

OBJS= gl65_c.o gl65_s.o

CONTRIBS= atmos/print.o atmos/platOric.o

%.o: %.s
	$(LD) -t$(PLATFORM) -c --create-dep $(@:.o=.d) -o $@ $^
	#$(AS) $(ASFLAGS) $^ -l $(@:.o=.lst) -o $@

%.s: %.c
	$(CC) $(CFLAGS) $^ -o $@

%.o: %.c
	$(LD) -t$(PLATFORM) -c --create-dep $(@:.o=.d) -D SCREEN_WIDTH=40 -D SCREEN_HEIGHT=26 -g -Oris -o $@ $^
	
#%.o: %.c
#	$(CC) $(CFLAGS) $^ -o $@

#%.asm: %.s
#	$(XA) -v -R -cc -e error.txt -l xa_labels.txt $^ -o $(@:.asm=.o)
#	co65 $(@:.asm=.o) -o $@
#	rm -f $(@:.asm=.o)
	
	#$(XA) -v -R -cc -e error.txt -l xa_labels.txt -DTARGET_ORIX -DSAVE_ZERO_PAGE glOric_s.s -o glOric_s.o
	#co65 glOric_s.o -o glOric_s.asm
#%.o: %.asm
#	$(AS) $(ASFLAGS) $^ -l $(@:.o=.lst) -o $@

#GL: glOric_s.o start.o
#	$(LD) -m GL.map -Ln GL.vice $(LDFLAGS) start.o glOric_asm.o -o GL.tap
#	sed -re 's/al 00(.{4}) \.(.+)$$/\1 \2/' GL.vice | sort > $(PATH_TO_ORICUTRON)/symbols
#	cp GL.tap $(PATH_TO_ORICUTRON)/usbdrive/bin/d
#	cd $(PATH_TO_ORICUTRON) && ./oricutron.exe -s symbols &
#	cd -

#	cl65 -g -o GL -DTARGET_ORIX -DSAVE_ZERO_PAGE -ttelestrat start.c glOric_s.asm
#	cp GL $(PATH_TO_ORICUTRON)\usbdrive\bin\


all: $(PROGNAME).tap


$(LIBNAME).lib: $(OBJS)
	$(AR) r $@ $^

$(PROGNAME).tap: $(OBJS) $(PROGNAME).o $(CONTRIBS)
	$(LD) -v -vm -m main.map -Ln main.vice -g -t$(PLATFORM) -o $@ -C atmos/atmos.cfg gl65_s.o  gl65_c.o main.o $(CONTRIBS)
	#cl65 -v -vm -m $(@:.tap=.map) -Ln $(@:.tap=.vice) -g -t$(PLATFORM) $^ -o $@
	sed -re 's/al 00(.{4}) \.(.+)$$/\1 \2/' main.vice | sort > $(PATH_TO_ORICUTRON)/symbols
	cp $@ $(PATH_TO_ORICUTRON)

$(PROGNAME).dsk: $(PROGNAME).o $(OBJS) $(CONTRIBS)
	$(LD) -m $(@:.dsk=.map) -Ln $(@:.dsk=.vice) $(LDFLAGS) $^  -o $(@:.dsk=.bin)
	sed -re 's/al 00(.{4}) \.(.+)$$/\1 \2/' $(@:.dsk=.vice) | sort > $(PATH_TO_ORICUTRON)/symbols
	$(OSDK)/header.exe $(@:.dsk=.bin) $(@:.dsk=.bin) 1280
	$(OSDK)/tap2dsk.exe -i$(@:.dsk=.com) $(@:.dsk=.bin) $@
	$(OSDK)/old2mfm.exe $@

	cp $@ $(PATH_TO_ORICUTRON)/disks



testdsk: $(PROGNAME).dsk
	cp $^ $(PATH_TO_ORICUTRON)\disks
	cd $(PATH_TO_ORICUTRON) && ./oricutron.exe -s symbols &
	cd -

testtap: $(PROGNAME).tap
	cp $^ $(PATH_TO_ORICUTRON)
	cd $(PATH_TO_ORICUTRON) && ./oricutron.exe -t $^ -s symbols &
	#cd -

# $(SRC_C:.c=.asm)

clean:
	rm -f *.o *.lib $(PROGNAME).s *.lst *.bin  *.dsk *.tap *.map *.vice *.d atmos/*.o atmos/*.d

