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


.. role:: sh(code)
   :language: sh

.. _make: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/make.html
.. _pre-push: https://git-scm.com/docs/githooks/2.24.0#_pre_push

.. |make| replace:: ``make(1)``
.. |pre-push-no-WIP| replace:: ``pre-push-no-WIP``
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

- The usual Unix tools, including:

  - |make|_ (build)

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


Installation, etc.
------------------

These commands must be run from the directory containing `the makefile`_
(using :sh:`make -C` is fine) [#privs]_:

- To install: `sudo make install`:sh:
- To uninstall: `sudo make uninstall`:sh:

To use an install location other than ``/usr/local/libexec/githooks``,
override |DESTDIR|__, |exec_prefix|__, |libexecdir|__, |PACKAGE|__, or
|prefix|__.  To modify build commands, override |INSTALL|_ or
|INSTALL_PROGRAM|__.

.. code:: sh

   sudo make prefix=/opt DESTDIR=/tmp/staging INSTALL=ginstall install

.. _the makefile: ../Makefile
__ https://www.gnu.org/software/make/manual/html_node/DESTDIR.html
__ https://www.gnu.org/software/make/manual/html_node/Directory-Variables.html
   #index-exec_005fprefix
__ https://www.gnu.org/software/make/manual/html_node/Directory-Variables.html
   #index-libexecdir
__ https://www.gnu.org/software/automake/manual/automake.html
   #index-PACKAGE_002c-directory
__ https://www.gnu.org/software/make/manual/html_node/Directory-Variables.html
   #index-prefix
.. _INSTALL:
   https://www.gnu.org/software/make/manual/html_node/Command-Variables.html
__ INSTALL_

.. |DESTDIR| replace:: ``DESTDIR``
.. |exec_prefix| replace:: ``exec_prefix``
.. |libexecdir| replace:: ``libexecdir``
.. |PACKAGE| replace:: ``PACKAGE``
.. |prefix| replace:: ``prefix``
.. |INSTALL| replace:: ``INSTALL``
.. |INSTALL_PROGRAM| replace:: ``INSTALL_PROGRAM``


Usage
-----

Most hooks' filenames begin with "*FOO*-", where *FOO* is the name of
a `supported Git hook`__.  A hook's prefix indicates its intended role
|--| e.g., |pre-push-require-sigs| is meant to be used as |pre-push|_.
To add a "*FOO*-" hook to a repository's hooks directory
(:sh:`git rev-parse --git-path hooks`):

- Copy or link it as *FOO*.  For example, to use |pre-push-require-sigs|
  as |pre-push|:

  .. code:: sh

     ln -s /usr/local/libexec/githooks/pre-push-require-sigs \
           /example/repo/.git/hooks/pre-push

  This necessarily precludes the use of other "*FOO*-" hooks.

- Copy or link it using its original name, then copy or link
  ``omnihook`` as *FOO*.  For example, to use both |pre-push-no-WIP| and
  |pre-push-require-sigs|:

  .. code:: sh

     ln -s /usr/local/libexec/githooks/omnihook \
           /example/repo/.git/hooks/pre-push &&
     ln -s /usr/local/libexec/githooks/pre-push-no-WIP \
           /usr/local/libexec/githooks/pre-push-require-sigs \
           /example/repo/.git/hooks

  As *FOO*, ``omnihook`` runs every "*FOO*-" executable in the hooks
  directory, repeatedly passing along its arguments and standard input.
  Hooks that are external to this collection can be integrated by
  renaming them to adhere to the "*FOO*-" convention.

__ https://git-scm.com/docs/githooks/2.24.0#_hooks

.. |--| unicode:: U+2014 .. EM DASH
.. |pre-push| replace:: ``pre-push``


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

.. [#privs] Feel free to replace |sudo|__ with |doas|__, |su|, or some
   other tool, or to omit it entirely if elevated privileges are not
   desired.

__ https://www.gnu.org/software/bash/
__ https://www.in-ulm.de/~mascheck/bourne/
__ https://www.sudo.ws
__ https://man.openbsd.org/doas

.. |sudo| replace:: ``sudo(8)``
.. |doas| replace:: ``doas(1)``
.. |su| replace:: ``su(1)``
