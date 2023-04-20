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

The name of each script begins with "FOO-", where FOO is the name of
a supported Git hook.  Scripts can be installed to a repository's hooks
directory (`git rev-parse --git-path hooks`) in two ways.

-   To use a single "FOO-" script, install it as FOO.  For example, install
    "pre-push-require-sigs" as "pre-push".

-   To use multiple "FOO-" scripts, install them using their original names
    and install "omnihook" as FOO.  For example, to use both "pre-push-no-WIP"
    and "pre-push-require-sigs", install them as-is and install "omnihook" as
    "pre-push".

When installed to a hooks directory as FOO and invoked by Git, "omnihook" runs
all executables in that directory whose names begin with "FOO-", passing along
its command-line arguments and standard input.  This accommodates the use of
hooks that are not part of this collection, as long as they adhere to the
naming convention.


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
