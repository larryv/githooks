# Makefile
# --------
#
# SPDX-License-Identifier: CC0-1.0
#
# Written in 2023 by Lawrence Velazquez <vq@larryv.me>.
#
# To the extent possible under law, the author has dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide.  This software is distributed without any
# warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication
# along with this software.  If not, see
# <https://creativecommons.org/publicdomain/zero/1.0/>.


.POSIX:
.SUFFIXES:
.SUFFIXES: .m4


# ---------------
# "PUBLIC" MACROS

# Remember to update the READMEs after adding new macros here.

SHELL = /bin/sh

INSTALL = ./install-sh
INSTALL_PROGRAM = $(INSTALL)
M4 = m4
PACKAGE = githooks

exec_prefix = $(prefix)
libexecdir = $(exec_prefix)/libexec
prefix = /usr/local


# ----------------
# "PRIVATE" MACROS

do_cleanup = { rc=$$?; rm -f -- $@ && exit "$$rc"; }
do_m4 = $(M4) $(M4FLAGS)
pkglibexec_SCRIPTS = omnihook pre-push-no-WIP pre-push-require-sigs
pkglibexecdir = $(libexecdir)/$(PACKAGE)


# --------------
# "PUBLIC" RULES

all: FORCE $(pkglibexec_SCRIPTS)

clean: FORCE
	rm -f -- $(pkglibexec_SCRIPTS)

# If BAR/FOO is a directory or a symlink to one, then the behavior of
# `install FOO BAR` varies *significantly* among implementations. Ensure
# consistent results by detecting this situation early and bailing out.
install: FORCE all installdirs
	@for f in $(pkglibexec_SCRIPTS); do \
    p=$(DESTDIR)$(pkglibexecdir)/$$f; \
    if test -d "$$p"; then \
        printf 'will not overwrite directory: %s\n' "$$p" >&2; \
        exit 1; \
    fi; \
done
	$(INSTALL_PROGRAM) -- $(pkglibexec_SCRIPTS) $(DESTDIR)$(pkglibexecdir)

installdirs: FORCE
	$(INSTALL) -d -- $(DESTDIR)$(pkglibexecdir)

# Clear CDPATH to preclude unexpected cd(1) behavior [1].
uninstall: FORCE
	CDPATH= cd -- $(DESTDIR)$(pkglibexecdir) \
    && rm -f -- $(pkglibexec_SCRIPTS)


# ---------------
# "PRIVATE" RULES

# Portably imitate .PHONY [2].
FORCE:

# Portably imitate .DELETE_ON_ERROR [3] because m4(1) may fail after the
# shell creates/truncates the target.
.m4:
	$(do_m4) -- $< >$@ || $(do_cleanup)
	-chmod +x $@


# ----------
# REFERENCES
#
#  1. https://pubs.opengroup.org/onlinepubs/9699919799/utilities/cd.html
#  2. https://www.gnu.org/software/make/manual/html_node/Force-Targets
#  3. https://www.gnu.org/software/make/manual/html_node/Errors.html
