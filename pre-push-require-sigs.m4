changequote([, ])dnl
divert(1)dnl
dnl
dnl
dnl pre-push-require-sigs.m4
dnl ------------------------
dnl
dnl SPDX-License-Identifier: CC0-1.0
dnl
dnl Written by Lawrence Velazquez <vq@larryv.me> in:
dnl   - 2018, 2020, 2022 (as pre-push-require-sigs)
dnl   - 2023 (as pre-push-require-sigs.m4)
dnl
# To the extent possible under law, the author has dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide.  This software is distributed without any
# warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication
# along with this software.  If not, see
# <https://creativecommons.org/publicdomain/zero/1.0/>.
dnl
dnl
divert[]dnl
[#]!ifdef([SHELL], [defn([SHELL])], [[/bin/sh]]) -

# pre-push-require-sigs - Block commits without a good PGP signature
# ------------------------------------------------------------------
#
# SPDX-License-Identifier: CC0-1.0
#
# Written in 2018, 2020, 2022-2023 by Lawrence Velazquez <vq@larryv.me>.
#
undivert(1)dnl

# ---------------------------------------------------------------------
# Exits with a zero status if all outgoing commits have good signatures
# (including ones that have unknown validity, are expired, or were made
# by keys that are now expired or revoked) and nonzero otherwise.
#
# See also:
#   - https://git-scm.com/docs/githooks/2.24.0#_pre_push
#   - https://git-scm.com/docs/gitformat-signature/2.40.0
# ---------------------------------------------------------------------

exec >&2

# Git prepends its exec directory to PATH, so this just works.
# shellcheck source=/dev/null  # I don't want to check Git's code.
. git-sh-setup

exit_status=0

while read -r local_ref local_sha1 remote_ref remote_sha1; do
	if test "$local_sha1" = 0000000000000000000000000000000000000000; then
		# Deleting a remote ref doesn't push any commits.
		continue
	elif test "$remote_sha1" = 0000000000000000000000000000000000000000; then
		# Creating new remote ref.
		range=$local_sha1
	else
		# Updating existing remote ref.
		range=$remote_sha1..$local_sha1
	fi

	git rev-list --pretty='%h %G? %s' "$range" | {
		# I tried this in awk(1) but gave up due to an overabundance of
		# implementation wrinkles.  (See commit 2ef18bd.)

		range_blocked=no

		# Every other line is "commit [full SHA1]", which we don't want.
		# (Only the "oneline" pretty-format omits them.)
		while read -r && read -r hash sig_status subject; do
			# See git-rev-list(1) for possible outputs of '%G?'.
			case $sig_status in
				[[GUXYR]]) continue ;;
				B) sig_status_msg='bad signature' ;;
				E) sig_status_msg="cannot check signature" ;;
				N) sig_status_msg='no signature' ;;
				*) sig_status_msg='unknown signature status' ;;
			esac

			if test "$range_blocked" = no; then
				range_blocked=yes

				# Print a blank line between ranges.
				if test "$exit_status" -ne 0; then
					echo
				fi

				printf '%s: blocked push to %s\n' "${0##*/}" "$remote_ref"
				printf '%s: commits in %s without good signatures:\n' \
					"${0##*/}" "$local_ref"
			fi

			printf '%s %s: %s\n' "$hash" "$sig_status_msg" "$subject"
		done

		# https://mywiki.wooledge.org/BashFAQ/024 - The enclosing
		# command grouping may run in a subshell, so use the exit status
		# of the pipeline to set 'exit_status' on the outside.
		test "$range_blocked" = yes
	} && exit_status=1
done

exit "$exit_status"
