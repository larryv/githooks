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

# NOTE: Update the READMEs after adding new macros here.

# Hard-coded into the shebangs of shell scripts.
SHELL = /bin/sh

INSTALL = ./install-sh
INSTALL_PROGRAM = $(INSTALL)
M4 = m4
PACKAGE = githooks
SHELLCHECK = shellcheck
SHELLCHECKFLAGS = --norc

exec_prefix = $(prefix)
libexecdir = $(exec_prefix)/libexec
prefix = /usr/local


# ----------------
# "PRIVATE" MACROS

# Clear CDPATH to preclude unexpected cd(1) behavior [1].
do_cd = CDPATH= cd
do_cleanup = { rc=$$?; rm -f -- $@ && exit "$$rc"; }
# Insert M4FLAGS first to allow the use of System V options that must
# precede -D [2].
do_m4 = $(M4) $(M4FLAGS) -D SHELL=$(SHELL)
pkglibexec_SCRIPTS = pre-push pre-push-no-WIP pre-push-require-sigs
pkglibexecdir = $(libexecdir)/$(PACKAGE)


# --------------
# "PUBLIC" RULES

all: FORCE $(pkglibexec_SCRIPTS)

check: FORCE $(pkglibexec_SCRIPTS)
	$(SHELLCHECK) $(SHELLCHECKFLAGS) -- $(pkglibexec_SCRIPTS)

clean: FORCE
	rm -f -- $(pkglibexec_SCRIPTS)

# If BAR/FOO is a directory or a symbolic link to one, then the behavior
# of "install FOO BAR" varies *significantly* among implementations.
# Ensures consistency by detecting this situation early and bailing out.
install: FORCE all installdirs
	@for f in $(pkglibexec_SCRIPTS); \
do \
    p=$(DESTDIR)$(pkglibexecdir)/$$f; \
    if test -d "$$p"; \
    then \
        printf 'will not overwrite directory: %s\n' "$$p" >&2; \
        exit 1; \
    fi; \
done
	$(INSTALL_PROGRAM) -- $(pkglibexec_SCRIPTS) $(DESTDIR)$(pkglibexecdir)

# Intentionally does not depend on the "install" target, so a casual
# "make installcheck" won't overwrite an existing installation.
installcheck: FORCE
	$(do_cd) -- $(DESTDIR)$(pkglibexecdir) \
    && $(SHELLCHECK) $(SHELLCHECKFLAGS) -- $(pkglibexec_SCRIPTS)

installdirs: FORCE
	$(INSTALL) -d -- $(DESTDIR)$(pkglibexecdir)

uninstall: FORCE
	$(do_cd) -- $(DESTDIR)$(pkglibexecdir) \
    && rm -f -- $(pkglibexec_SCRIPTS)


# ---------------
# "PRIVATE" RULES

# Portably imitate .PHONY [3].
FORCE:

# Portably imitate .DELETE_ON_ERROR [4] because m4(1) may fail after the
# shell creates/truncates the target.

pre-push: omnihook.m4
	$(do_m4) -D HOOK=$@ omnihook.m4 >$@ || $(do_cleanup)
	-chmod +x $@

.m4:
	$(do_m4) -- $< >$@ || $(do_cleanup)
	-chmod +x $@


# ----------
# REFERENCES
#
#  1. https://pubs.opengroup.org/onlinepubs/9699919799/utilities/cd.html
#  2. https://docs.oracle.com/cd/E88353_01/html/E37839/m4-1.html
#  3. https://www.gnu.org/software/make/manual/html_node/Force-Targets
#  4. https://www.gnu.org/software/make/manual/html_node/Errors.html
