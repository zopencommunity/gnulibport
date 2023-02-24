#!/bin/sh

gnulibtool="$PWD/../gnulib/gnulib-tool"
if ! [ -f "${gnulibtool}" ]; then
  echo "Can not find gnulib-tool" >&2
  exit 4
fi

rm -rf example 
mkdir example || exit 99
cd example || exit 99

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

cat >configure.ac || exit 99 <<ZZ
AC_INIT([example-c], [0])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_SRCDIR([src/example.c])
AM_INIT_AUTOMAKE

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([Makefile.am])

AC_PROG_CC

gl_EARLY
gl_INIT

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
ZZ

cat >Makefile.am || exit 99 <<ZZ
ACLOCAL_AMFLAGS = -I m4 
SUBDIRS = lib
EXTRA_DIST = m4/gnulib-cache.m4

ZZ

if ! "${gnulibtool}" --import strdup ; then
  echo "Unable to run gnulibtool to create simple stdup example" >&2
  exit 8
fi

