#!/bin/sh

#
# A basic program that uses a function from gnulib
# to validate that gnulib can be used.
# 
# This requires:
#  - autoconf, automake, make, perl, m4
mydir="$( cd "$(dirname "$0")" >/dev/null 2>&1 && pwd -P )"
cd "${mydir}" || exit 99

gnulibtool="${mydir}/../gnulib/gnulib-tool"
if ! [ -f "${gnulibtool}" ]; then
  echo "Can not find gnulib-tool" >&2
  exit 4
fi

rm -rf example 
mkdir example || exit 99
cd example || exit 99
mkdir src || exit 99

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

#include <string.h> /* for stpcpy */

int main () {
    char buffer [10];
    char *name = buffer;


    name = stpcpy (stpcpy (stpcpy (name, "ice"),"-"), "cream");
    puts (buffer);
    return 0;
}
ZZ

cat >src/Makefile.am <<ZZ
AM_CPPFLAGS = -I\$(top_builddir)/lib -I\$(top_srcdir)/lib
LDADD = \$(top_builddir)/lib/libgnu.a
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

if ! "${gnulibtool}" --import stpcpy ; then
  echo "Unable to run gnulibtool to create simple stpcpy example" >&2
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

if ! src/example ; then
  echo "example program failed" >&2
  exit 8
fi

echo "Test Passed"
exit 0
