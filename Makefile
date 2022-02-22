# CC = gcc
CC = gcc

# CFLAGS = -Wall -g
CFLAGS = -Wall -g

# LFLAGS = -L/path/to/lib -L..
LFLAGS =

# INCLUDES = -I/path/to/include -I..
INCLUDES =

# LIBS = -lmylib -lm
LIBS =

# SRCS = .c's
SRCS = main.c dep1.c

# $(name:string1=string2)
# OBJS = $(SRCS:.c=.o)
OBJS = $(SRCS:.c=.o)

TARGET = main

SHELL = /bin/sh
prefix = /usr
exec_prefix = ${prefix}
lib_prefix = ${prefix}
execdir = ${exec_prefix}/bin
libdir = ${lib_prefix}/lib
srcdir = .

INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644
MKDIR_P = /usr/bin/mkdir -p

all: $(TARGET)

.PHONY: all install uninstall clean

# $(TARGET): $(OBJS)
#   $(CC) $(CFLAGS) $(INCLUDES) -o $(TARGET) $(OBJS) $(LFLAGS) $(LIBS)
$(TARGET): $(OBJS)
	$(CC) -o $(TARGET) $(OBJS)

# .c.o:
#   $(CC) $(FLAGS) $(INCLUDES) -c $< -o $@
main.o: main.c dep.h dep2.h
	$(CC) -c main.c

dep1.o: dep1.c
	$(CC) -c dep1.c

install: $(TARGET)
	$(MKDIR_P) ~/tmp/bin
	$(INSTALL_PROGRAM) $< ~/tmp/bin

uninstall:
	$(RM) -rd ~/tmp/bin

clean:
	$(RM) *.o *~ $(TARGET)
