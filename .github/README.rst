.. .github/README.rst
   ------------------

   SPDX-License-Identifier: CC0-1.0

   Written in 2020, 2022-2023 by Lawrence Velazquez <vq@larryv.me>.

   To the extent possible under law, the author(s) have dedicated all
   copyright and related and neighboring rights to this software to the
   public domain worldwide.  This software is distributed without any
   warranty.

   You should have received a copy of the CC0 Public Domain Dedication
   along with this software.  If not, see
   <https://creativecommons.org/publicdomain/zero/1.0/>.


.. _pre-push: https://git-scm.com/docs/githooks/2.24.0#_pre_push

.. |pre-push-require-sigs| replace:: ``pre-push-require-sigs``


githooks
========

This is my collection of `Git hooks`__.  Unlike arq-helpers__, it has earned its
plural moniker. (Barely.)

Here are quick summaries of the hooks.  Refer to the comments in the source
code for more details.

pre-push_-no-WIP
    Blocks commits whose messages begin with a tag labeling them as works in
    progress.

pre-push_-require-sigs
    Blocks commits that lack a good PGP signature.

Maybe there will be more one day!  Reach for the stars.

__ https://git-scm.com/docs/githooks/2.24.0
__ https://github.com/larryv/arq-helpers


Requirements
------------

- Git__, obviously

- A `shell that conforms to POSIX`__ or comes close enough
  [#good-shells]_

- The usual Unix tools

- One or more tools for verifying signatures (|pre-push-require-sigs|):

  - |gpg|__ or a |drop-in replacement (gpg)|__, for PGP signatures

  - |gpgsm|__ or a |drop-in replacement (gpgsm)|_, for X.509 signatures

  - |ssh-keygen|__ or a |drop-in replacement (ssh-keygen)|__, for SSH
    signatures

__ https://git-scm.com
__ https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html
__ https://gnupg.org/documentation/manuals/gnupg/Invoking-GPG.html
__ https://git-scm.com/docs/git-config/2.40.0
   #Documentation/git-config.txt-gpgprogram
__ https://gnupg.org/documentation/manuals/gnupg/Invoking-GPGSM.html
.. _drop-in replacement (gpgsm):
   https://git-scm.com/docs/git-config/2.40.0
   #Documentation/git-config.txt-gpgltformatgtprogram
__ https://man.openbsd.org/ssh-keygen.1
__ `drop-in replacement (gpgsm)`_

.. |gpg| replace:: ``gpg(1)``
.. |drop-in replacement (gpg)| replace:: drop-in replacement
.. |gpgsm| replace:: ``gpgsm(1)``
.. |drop-in replacement (gpgsm)| replace:: drop-in replacement
.. |ssh-keygen| replace:: ``ssh-keygen(1)``
.. |drop-in replacement (ssh-keygen)| replace:: drop-in replacement


Usage
-----

The name of each script begins with "*FOO*-", where *FOO* is the name of
a `supported Git hook`__.  Scripts can be installed to a repository's hooks
directory (``git rev-parse --git-path hooks``) in two ways.

-   To use a single "*FOO*-" script, install it as *FOO*.  For example,
    install ``pre-push-require-sigs`` as ``pre-push``.

-   To use multiple "*FOO*-" scripts, install them using their original names
    and install ``omnihook`` as *FOO*.  For example, to use both
    ``pre-push-no-WIP`` and ``pre-push-require-sigs``, install them as-is and
    install ``omnihook`` as ``pre-push``.

When installed to a hooks directory as *FOO* and invoked by Git, ``omnihook``
runs all executables in that directory whose names begin with "*FOO*-",
passing along its command-line arguments and standard input.  This accommodates
the use of hooks that are not part of this collection, as long as they adhere
to the naming convention.

__ https://git-scm.com/docs/githooks/2.24.0#_hooks


Legal
-----

To the extent possible under law, `the author(s) have dedicated all
copyright and related and neighboring rights to this software to the
public domain worldwide`__.  This software is published from the United
States of America and distributed without any warranty.

__ ../COPYING.txt


Notes
-----

.. [#good-shells] Shells known to work at one point or another include
   bash__ 3.2.57.  `Traditional Bourne shells`__ are not supported.

__ https://www.gnu.org/software/bash/
__ https://www.in-ulm.de/~mascheck/bourne/
