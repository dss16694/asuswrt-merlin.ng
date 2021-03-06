CROSS_COMPILE = mipsel-linux-
ifeq($(HND_ROUTER),y)
HNDLN := hnd_shared
BCMEX7 := _arm_94908hnd
endif
KSRC := $(shell /bin/pwd)/../../$(HNDLN)/..
KINCLUDE = -I$(KSRC)/include -I$(LINUXDIR)/include/asm/gcc \
	   -I$(KSRC)/router/emf$(BCMEX7)/emf -I$(KSRC)/router/emf$(BCMEX7)/igs

CC := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)ld

OFILES = emfc.o emf_linux.o

IFLAGS1 = -I$(LINUXDIR)/include
IFLAGS2 = $(KINCLUDE)
DFLAGS += -DMODULE -D__KERNEL__ $(IFLAGS) -G 0 -mno-abicalls \
	  -fno-pic -pipe -gstabs+ -mcpu=r4600 -mips2 -Wa,--trap \
	  -m4710a0kern -mlong-calls -fno-common -nostdinc \
	  -iwithprefix include


RMFLAGS += -DBCMINTERNAL -DBCMDBG

WFLAGS = $(IFLAGS1) -Wall -Wstrict-prototypes -Wno-trigraphs -O2 \
	 -fno-strict-aliasing -fno-common -fomit-frame-pointer $(IFLAGS2)

CFLAGS += $(WFLAGS) $(DFLAGS) $(RMFLAGS)

TARGETS = emf.o

all: $(TARGETS)

emf.o: $(OFILES)
	$(LD) -r -o $@ $(OFILES)

clean:
	rm -f $(OFILES) $(TARGETS) *~

.PHONY: all clean

include $(LINUXDIR)/Rules.make
