githooks
========

These are some Git hooks [1] I use regularly.

pre-push-no-WIP

    Aborts `git push` if any outgoing commit message begins with any of
    the following strings (whitespace included):

      - "(FIXUP)", "(NOCOMMIT)", "(REWORD)", "(SQUASH)", or "(WIP)"
      - "[FIXUP]", etc.
      - "{FIXUP}", etc.
      - "amend! ", "fixup! ", or "squash! " [2]

pre-push-require-sigs

    Aborts `git push` unless all outgoing commits have good
    signatures [3] (including ones that have unknown validity, are
    expired, or were made by keys that are now expired or revoked).

Maybe there will be more one day!  Reach for the stars.


Requirements
------------

  - Git, obviously

  - A shell that conforms to POSIX [4] or comes close enough [A]

  - The usual Unix tools, including:

      - m4(1) (build)

      - make(1) (build)

  - ShellCheck [6] (`make check` and `make installcheck`)

  - One or more tools for verifying signatures (pre-push-require-sigs):

      - gpg(1) or a drop-in replacement [7], for PGP signatures

      - gpgsm(1) or a drop-in replacement [8], for X.509 signatures

      - ssh-keygen(1) or a drop-in replacement [8], for SSH signatures


Installation, etc.
------------------

These commands must be run from the directory containing the makefile
(using `make -C` is fine) [B]:

  - To install: `make && sudo make install`
  - To uninstall: `sudo make uninstall`
  - To test before installing: `make check`
  - To test after installing: `make installcheck`
  - To clean: `make clean`

To use an install location other than /usr/local/libexec/githooks,
override DESTDIR [9], exec_prefix [10], libexecdir [10], PACKAGE [11],
or prefix [10].  To modify build commands, override INSTALL [12],
INSTALL_PROGRAM [12], M4, M4FLAGS, SHELLCHECK, or SHELLCHECKFLAGS.  To
use something other than /bin/sh as the interpreter for installed shell
scripts, override SHELL [C].

    make M4=gm4 M4FLAGS=-G SHELL=/usr/local/bin/dash &&
    make SHELLCHECKFLAGS='--norc --severity=warning' check &&
    sudo make prefix=/opt DESTDIR=/tmp/staging INSTALL=ginstall install


Usage
-----

Most hooks' filenames begin with "FOO-", where FOO is the name of
a supported Git hook.  A hook's prefix indicates its intended role --
e.g., pre-push-require-sigs is meant to be used as pre-push.  To add
a "FOO-" hook to a repository's hooks directory (`git rev-parse
--git-path hooks`):

  - Copy or link it as FOO.  For example, to use pre-push-require-sigs
    as pre-push:

        ln -s /usr/local/libexec/githooks/pre-push-require-sigs \
              /example/repo/.git/hooks/pre-push

    This necessarily precludes the use of other "FOO-" hooks.

  - Copy or link it using its original name, then copy or link the FOO
    driver hook.  For example, to use both pre-push-no-WIP and
    pre-push-require-sigs:

        ln -s /usr/local/libexec/githooks/pre-push \
              /usr/local/libexec/githooks/pre-push-no-WIP \
              /usr/local/libexec/githooks/pre-push-require-sigs \
              /example/repo/.git/hooks

    The FOO driver hook runs every "FOO-" executable in the hooks
    directory, repeatedly passing along its arguments and standard
    input.  Hooks that are external to this collection can be integrated
    by renaming them to adhere to the "FOO-" convention.


Legal
-----

To the extent possible under law, the author has dedicated all copyright
and related and neighboring rights to this software to the public domain
worldwide [13].  This software is published from the United States of
America and distributed without any warranty.


Notes
-----

 A. Shells known to work at one point or another include bash 3.2.57.
    Traditional Bourne shells [14] are not supported.

 B. Feel free to replace sudo(8) with doas(1), su(1), or some other
    tool, or to omit it entirely if elevated privileges are not desired.

 C. Overriding SHELL also changes the interpreter [15] used by POSIX-
    conformant make(1) implementations.  This shouldn't be a problem; if
    a shell can handle the installed scripts, it can handle the build.


References
----------

 1. https://git-scm.com/docs/githooks/2.24.0
 2. https://git-scm.com/docs/git-rebase/2.40.0#Documentation/git-rebase.txt---autosquash
 3. https://git-scm.com/docs/gitformat-signature/2.40.0
 4. https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html
 6. https://www.shellcheck.net
 7. https://git-scm.com/docs/git-config/2.40.0#Documentation/git-config.txt-gpgprogram
 8. https://git-scm.com/docs/git-config/2.40.0#Documentation/git-config.txt-gpgltformatgtprogram
 9. https://www.gnu.org/software/make/manual/html_node/DESTDIR.html
10. https://www.gnu.org/software/make/manual/html_node/Directory-Variables.html
11. https://www.gnu.org/software/automake/manual/automake.html#index-PACKAGE_002c-directory
12. https://www.gnu.org/software/make/manual/html_node/Command-Variables.html
13. https://creativecommons.org/publicdomain/zero/1.0/
14. https://www.in-ulm.de/~mascheck/bourne/
15. https://www.gnu.org/software/make/manual/html_node/Choosing-the-Shell.html


SPDX-License-Identifier: CC0-1.0

Written in 2020, 2022-2023 by Lawrence Velazquez <vq@larryv.me>.
