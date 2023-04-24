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

  - The usual Unix tools

  - One or more tools for verifying signatures (pre-push-require-sigs):

      - gpg(1) or a drop-in replacement [5], for PGP signatures

      - gpgsm(1) or a drop-in replacement [6], for X.509 signatures

      - ssh-keygen(1) or a drop-in replacement [6], for SSH signatures


Usage
-----

Most hooks' filenames begin with "FOO-", where FOO is the name of
a supported Git hook.  A hook's prefix indicates its intended role --
e.g., pre-push-require-sigs is meant to be used as pre-push.  To add
a "FOO-" hook to a repository's hooks directory (`git rev-parse
--git-path hooks`):

  - Copy or link it as FOO.  For example, to use pre-push-require-sigs
    as pre-push:

        ln -s /this/project/pre-push-require-sigs \
              /example/repo/.git/hooks/pre-push

    This necessarily precludes the use of other "FOO-" hooks.

  - Copy or link it using its original name, then copy or link omnihook
    as FOO.  For example, to use both pre-push-no-WIP and
    pre-push-require-sigs:

        ln -s /this/project/omnihook \
              /example/repo/.git/hooks/pre-push &&
        ln -s /this/project/pre-push-no-WIP \
              /this/project/pre-push-require-sigs \
              /example/repo/.git/hooks

    As FOO, omnihook runs every "FOO-" executable in the hooks
    directory, repeatedly passing along its arguments and standard
    input.  Hooks that are external to this collection can be integrated
    by renaming them to adhere to the "FOO-" convention.


Legal
-----

To the extent possible under law, the author(s) have dedicated all
copyright and related and neighboring rights to this software to the
public domain worldwide.  This software is published from the United
States of America and distributed without any warranty.

You should have received a copy of the CC0 Public Domain Dedication
along with this software.  If not, see
<https://creativecommons.org/publicdomain/zero/1.0/>.


Notes
-----

 A. Shells known to work at one point or another include bash 3.2.57.
    Traditional Bourne shells [12] are not supported.


References
----------

 1. https://git-scm.com/docs/githooks/2.24.0
 2. https://github.com/larryv/arq-helpers
 3. https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html
 5. https://git-scm.com/docs/git-config/2.40.0#Documentation/git-config.txt-gpgprogram
 6. https://git-scm.com/docs/git-config/2.40.0#Documentation/git-config.txt-gpgltformatgtprogram
12. https://www.in-ulm.de/~mascheck/bourne/


SPDX-License-Identifier: CC0-1.0

Written in 2020, 2022-2023 by Lawrence Velazquez <vq@larryv.me>.
