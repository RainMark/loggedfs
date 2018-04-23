CC=g++
CFLAGS=-Wall -D_FILE_OFFSET_BITS=64 -DFUSE_USE_VERSION=26 -DRLOG_COMPONENT="loggedfs" `xml2-config --cflags` `pkg-config --cflags fuse`
LDFLAGS=-Wall -lpcre -lrlog `xml2-config --libs` `pkg-config --libs fuse`
srcdir=src
builddir=build

all: $(builddir) loggedfs

$(builddir):
	mkdir $(builddir)

loggedfs: $(builddir)/loggedfs.o $(builddir)/Config.o $(builddir)/Filter.o
	$(CC) -o loggedfs $(builddir)/loggedfs.o $(builddir)/Config.o $(builddir)/Filter.o $(LDFLAGS)
$(builddir)/loggedfs.o: $(builddir)/Config.o $(builddir)/Filter.o $(srcdir)/loggedfs.cpp
	$(CC) -o $(builddir)/loggedfs.o -c $(srcdir)/loggedfs.cpp $(CFLAGS)

$(builddir)/Config.o: $(builddir)/Filter.o $(srcdir)/Config.cpp $(srcdir)/Config.h
	$(CC) -o $(builddir)/Config.o -c $(srcdir)/Config.cpp $(CFLAGS)

$(builddir)/Filter.o: $(srcdir)/Filter.cpp $(srcdir)/Filter.h
	$(CC) -o $(builddir)/Filter.o -c $(srcdir)/Filter.cpp $(CFLAGS)

clean:
	rm -rf $(builddir)/
	
install:
	gzip --keep loggedfs.1
	cp loggedfs.1.gz /usr/share/man/man1/
	cp loggedfs /usr/bin/
	cp loggedfs.xml /etc/


mrproper: clean
	rm -rf loggedfs
			
release:
	tar -c --exclude="CVS" $(srcdir)/ loggedfs.xml LICENSE loggedfs.1.gz Makefile | bzip2 - > loggedfs.tar.bz2

