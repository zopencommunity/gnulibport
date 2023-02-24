#!/bin/sh

gnulibtool="$PWD/../gnulib/gnulib-tool"
if ! [ -f "${gnulibtool}" ]; then
  echo "Can not find gnulib-tool" >&2
  exit 4
fi

rm -rf example 
mkdir example || exit 99
cd example || exit 99
mkdir src || exit 99

#Instructions for using gnulib-tool
#
#You may need to add #include directives for the following .h files.
#  #include <string.h>
#
#Don't forget to
#  - add "lib/Makefile" to AC_CONFIG_FILES in ./configure.ac,
#  - mention "lib" in SUBDIRS in Makefile.am,
#  - mention "-I m4" in ACLOCAL_AMFLAGS in Makefile.am
#    or add an AC_CONFIG_MACRO_DIRS([m4]) invocation in ./configure.ac,
#  - mention "m4/gnulib-cache.m4" in EXTRA_DIST in Makefile.am,
#  - invoke gl_EARLY in ./configure.ac, right after AC_PROG_CC,
#  - invoke gl_INIT in ./configure.ac.

cat >configure.ac <<ZZ
AC_INIT([example-c], [0])
AM_INIT_AUTOMAKE([])
AC_PROG_CC
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([
 Makefile
 src/Makefile
 lib/Makefile
])

gl_EARLY
gl_INIT
AC_OUTPUT
ZZ

cat >Makefile.am <<ZZ
ACLOCAL_AMFLAGS = -I m4 
SUBDIRS = lib src
EXTRA_DIST = m4/gnulib-cache.m4
ZZ

cat >src/example.c <<ZZ
#include <config.h>
#include <stdio.h>

#include <string.h> /* for strdup */

int main () {
  puts(strdup("Hello world"));

  return 0;
}
ZZ

cat >src/Makefile.am <<ZZ
AM_CPPFLAGS = -I\$(top_builddir)/lib -I\$(top_srcdir)/lib
LDADD = ../lib/libgnu.a
bin_PROGRAMS = example
example_SOURCES = example.c
ZZ

cat >AUTHORS <<ZZ
  z/OS Open Tools
ZZ

cat >ChangeLog <<ZZ
  creation
ZZ

cat >NEWS <<ZZ
  I get all the news I need on the Weather Report
ZZ

cat >README <<ZZ
  Example to validate gnulib basics ok
ZZ

if ! "${gnulibtool}" --import strdup-posix ; then
  echo "Unable to run gnulibtool to create simple stdup example" >&2
  exit 8
fi

if ! autoreconf --install ; then
  echo "autoreconf failed" >&2
  exit 8
fi

if ! ./configure CC=xlclang ; then
  echo "configure failed" >&2
  exit 8
fi

if ! make ; then
  echo "make failed" >&2
  exit 8
fi


