githooks
========

This is my collection of Git hooks [1].  Unlike arq-helpers [2], it has earned
its plural moniker. (Barely.)

Here are quick summaries of the hooks.  Refer to the comments in the source
code for more details.

pre-push-no-WIP

    Blocks commits whose messages begin with a tag labeling them as works in
    progress.

pre-push-require-sigs

    Blocks commits that lack a good PGP signature.

Maybe there will be more one day!  Reach for the stars.


Requirements
------------

  - Git, obviously

  - A shell that conforms to POSIX [3] or comes close enough [A]

  - The usual Unix tools, including:

      - m4(1) (build)

      - make(1) (build)

  - One or more tools for verifying signatures (pre-push-require-sigs):

      - gpg(1) or a drop-in replacement [5], for PGP signatures

      - gpgsm(1) or a drop-in replacement [6], for X.509 signatures

      - ssh-keygen(1) or a drop-in replacement [6], for SSH signatures


Installation, etc.
------------------

These commands must be run from the directory containing the makefile
(using `make -C` is fine) [B]:

  - To install: `make && sudo make install`
  - To uninstall: `sudo make uninstall`
  - To clean: `make clean`

To use an install location other than /usr/local/libexec/githooks,
override DESTDIR [7], exec_prefix [8], libexecdir [8], PACKAGE [9], or
prefix [8].  To modify build commands, override INSTALL [10],
INSTALL_PROGRAM [10], M4, or M4FLAGS.

    make M4=gm4 M4FLAGS=-G &&
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

  - Copy or link it using its original name, then copy or link omnihook
    as FOO.  For example, to use both pre-push-no-WIP and
    pre-push-require-sigs:

        ln -s /usr/local/libexec/githooks/omnihook \
              /example/repo/.git/hooks/pre-push &&
        ln -s /usr/local/libexec/githooks/pre-push-no-WIP \
              /usr/local/libexec/githooks/pre-push-require-sigs \
              /example/repo/.git/hooks

    As FOO, omnihook runs every "FOO-" executable in the hooks
    directory, repeatedly passing along its arguments and standard
    input.  Hooks that are external to this collection can be integrated
    by renaming them to adhere to the "FOO-" convention.


Legal
-----

To the extent possible under law, the author has dedicated all copyright
and related and neighboring rights to this software to the public domain
worldwide [11].  This software is published from the United States of
America and distributed without any warranty.


Notes
-----

 A. Shells known to work at one point or another include bash 3.2.57.
    Traditional Bourne shells [12] are not supported.

 B. Feel free to replace sudo(8) with doas(1), su(1), or some other
    tool, or to omit it entirely if elevated privileges are not desired.


References
----------

 1. https://git-scm.com/docs/githooks/2.24.0
 2. https://github.com/larryv/arq-helpers
 3. https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html
 5. https://git-scm.com/docs/git-config/2.40.0#Documentation/git-config.txt-gpgprogram
 6. https://git-scm.com/docs/git-config/2.40.0#Documentation/git-config.txt-gpgltformatgtprogram
 7. https://www.gnu.org/software/make/manual/html_node/DESTDIR.html
 8. https://www.gnu.org/software/make/manual/html_node/Directory-Variables.html
 9. https://www.gnu.org/software/automake/manual/automake.html#index-PACKAGE_002c-directory
10. https://www.gnu.org/software/make/manual/html_node/Command-Variables.html
11. https://creativecommons.org/publicdomain/zero/1.0/
12. https://www.in-ulm.de/~mascheck/bourne/


SPDX-License-Identifier: CC0-1.0

Written in 2020, 2022-2023 by Lawrence Velazquez <vq@larryv.me>.
