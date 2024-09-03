SHELL = /bin/sh
prefix = /usr
exec_prefix = $(prefix)
lib_prefix = $(prefix)
execdir = $(exec_prefix)/bin
libdir = $(lib_prefix)/lib
srcdir = .
destdir = ~/tmp/bin

INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644
MKDIR_P = /usr/bin/mkdir -p

# CFLAGS = -Wall -g
CFLAGS = -Wall -g

# LFLAGS = -L/path/to/lib -L..
LFLAGS =

# INCLUDES = -I/path/to/include -I..
INCLUDES =

# LIBS = -lmylib -lm
LIBS =

srcs = main.c dep1.c
objs = $(srcs:.c=.o)
target = main

all: $(target)

.PHONY: all install uninstall clean

# $(target): $(objs)
#   $(CC) $(CFLAGS) $(LFLAGS) $(LIBS) $(INCLUDES) -o $(target) $(objs) 
$(target): $(objs)
	$(CC) -o $(target) $(objs)

# %.o: %.c:
#   $(CC) $(CFLAGS) $(LFLAGS) $(LIBS) $(INCLUDES) -c $< -o $@
main.o: main.c dep.h dep2.h
	$(CC) -c main.c

dep1.o: dep1.c
	$(CC) -c dep1.c

install: $(target)
	$(MKDIR_P) $(destdir)
	$(INSTALL_PROGRAM) $< $(destdir)

uninstall:
	$(RM) -rd $(destdir)

clean:
	$(RM) *.o *~ $(target)
