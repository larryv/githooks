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

.. _Git hooks: https://git-scm.com/docs/githooks/2.24.0
.. _arq-helpers: https://github.com/larryv/arq-helpers
.. _supported Git hook: https://git-scm.com/docs/githooks/2.24.0#_hooks
.. _pre-push: https://git-scm.com/docs/githooks/2.24.0#_pre_push
