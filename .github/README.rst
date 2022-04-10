.. .github/README.rst
   ------------------

   SPDX-License-Identifier: CC0-1.0

   Written in 2020, 2022 by Lawrence Velazquez <vq@larryv.me>.

   To the extent possible under law, the author(s) have dedicated all
   copyright and related and neighboring rights to this software to the
   public domain worldwide.  This software is distributed without any
   warranty.

   You should have received a copy of the CC0 Public Domain Dedication
   along with this software.  If not, see
   <https://creativecommons.org/publicdomain/zero/1.0/>.


githooks
========

This is my collection of `Git hooks`_. Unlike arq-helpers_, it has earned its
plural moniker. (Barely.)

----

The name of each script begins with "*FOO*-", where *FOO* is the name of
a `supported Git hook`_. Scripts can be installed to a repository's hooks
directory (``git rev-parse --git-path hooks``) in two ways.

-   To use a single "*FOO*-" script, install it as *FOO*. For example,
    install ``pre-push-require-sigs`` as ``pre-push``.
-   To use multiple "*FOO*-" scripts, install them using their original names
    and install ``omnihook`` as *FOO*. For example, to use both
    ``pre-push-no-WIP`` and ``pre-push-require-sigs``, install them as-is and
    install ``omnihook`` as ``pre-push``.

When installed to a hooks directory as *FOO* and invoked by Git, ``omnihook``
runs all executables in that directory whose names begin with "*FOO*-",
passing along its command-line arguments and standard input. This accommodates
the use of hooks that are not part of this collection, as long as they adhere
to the naming convention.

----

Here are quick summaries of the hooks. Refer to the comments in the source
code for more details.

pre-push_-no-WIP
    Blocks commits whose messages begin with a tag labeling them as works in
    progress.
pre-push_-require-sigs
    Blocks commits that lack a good PGP signature.

Maybe there will be more one day! Reach for the stars.

----

To the extent possible under law, the author(s) have `dedicated all
copyright and related and neighboring rights to this software to the
public domain worldwide`_.  This software is published from the United
States of America and distributed without any warranty.


.. _Git hooks: https://git-scm.com/docs/githooks/2.24.0
.. _arq-helpers: https://github.com/larryv/arq-helpers
.. _supported Git hook: https://git-scm.com/docs/githooks/2.24.0#_hooks
.. _pre-push: https://git-scm.com/docs/githooks/2.24.0#_pre_push
.. _dedicated all copyright and related and neighboring rights to this software to the public domain worldwide:
   https://creativecommons.org/publicdomain/zero/1.0/
