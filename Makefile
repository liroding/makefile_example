CC = gcc
CFLAG = -Wall
TARGET =main

OUTFILE=debug

OUTBIN=bin

OBJFILE=obj

ifneq ($(OUTFILE), $(wildcard $(OUTFILE)))
$(shell mkdir -p $(OUTFILE) $(OUTFILE)/$(OUTBIN) $(OUTFILE)/$(OBJFILE))
$(shell echo 'OBJS=*.o\nODIR=obj\n$$(ROOT_DIR)/$$(BIN_DIR)/$$(BIN):$$(ODIR)/$$(OBJS)\n\t$$(CC) -g -o $$@ $$^ $$(CFLAGS) $$(LDFLAGS)'>$(OUTFILE)/Makefile)
endif

ifneq ($(OUTFILE)/$(OUTBIN), $(wildcard $(OUTFILE)/$(OUTBIN)))
$(shell mkdir -p $(OUTFILE)/$(OUTBIN))
endif

ifneq ($(OUTFILE)/$(OBJFILE), $(wildcard $(OUTFILE)/$(OBJFILE)))
$(shell mkdir -p $(OUTFILE)/$(OBJFILE))
endif

SUBDIRS=$(shell ls -l | grep ^d | awk '{if($$9 != "debug") print $$9}')

SUBDIRS:=$(patsubst includes,,$(SUBDIRS))

ROOT_DIR=$(shell pwd)

BIN = myapp

OBJS_DIR = debug/obj

BIN_DIR = debug/bin

CUR_SOURCE = ${wildcard *.c}

CUR_OBJS = ${patsubst %.c,%.o,$(CUR_SOURCE)}

INCLUDE_PATH := $(ROOT_DIR)/includes/

#get all include path
CFLAGS  += $(foreach dir, $(INCLUDE_PATH), -I$(dir))

export CC BIN OBJS_DIR BIN_DIR ROOT_DIR CFLAGS

all:$(SUBDIRS) $(CUR_OBJS) DEBUG

$(SUBDIRS):ECHO
	make -C $@
	@echo "--------------------------------------------------------------------"
DEBUG:ECHO
	make -C debug
	@echo "--------------------------------------------------------------------"
	cp $(ROOT_DIR)/$(BIN_DIR)/myapp ./
ECHO:
	@echo "[Enter] -->" $(SUBDIRS)

$(CUR_OBJS):%.o:%.c
	$(CC) -c $^ -g -o $(ROOT_DIR)/$(OBJS_DIR)/$@ $(CFLAGS)
	@echo "--------------------------------------------------------------------"
#	cp $(ROOT_DIR)/$(BIN_DIR)/myapp ./
clean:
	@echo "[Clean Handle] -->"
	rm $(OBJS_DIR)/*.o
	$(RM) $(BIN_DIR)/*
	@echo "--------------------------------------------------------------------"

hello:
	echo $(SUBDIRS) $(ROOT_DIR) $(CUR_SOURCE) $(CUR_OBJS) $(CFLAGS)
cp:
	echo $(ROOT_DIR)
	cp $(ROOT_DIR)/$(BIN_DIR)/myapp ./
