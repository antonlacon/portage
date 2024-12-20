# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_DRI="always"
inherit flag-o-matic xorg-3

DESCRIPTION="X.Org driver for VIA/S3G cards"
HOMEPAGE="https://www.freedesktop.org/wiki/Openchrome/"

LICENSE="MIT"
KEYWORDS="amd64 x86"
IUSE="debug viaregtool"

RDEPEND="
	>=x11-base/xorg-server-1.9
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXvMC
	x11-libs/libdrm"
DEPEND="
	${RDEPEND}
	x11-libs/libXv"

PATCHES=(
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-Fix-for-X.Org-X-Server-1.20.patch
)

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/864406
	# Upstream appears to have never migrated from the old bugzilla and
	# cgit hosting over to gitlab.fd.o, no activity in a year, no way
	# to report a bug I guess. Yay dead software.
	#
	# Do not trust for LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	local XORG_CONFIGURE_OPTIONS=(
		$(use_enable debug)
		$(use_enable debug xv-debug)
		$(use_enable viaregtool)
	)
	xorg-3_src_configure
}

pkg_postinst() {
	xorg-3_pkg_postinst

	elog "Supported chipsets:"
	elog "CLE266 (VT3122), KM400/P4M800 (VT3205), K8M800 (VT3204),"
	elog "PM800/PM880/CN400 (VT3259), VM800/CN700/P4M800Pro (VT3314),"
	elog "CX700 (VT3324), P4M890 (VT3327), K8M890 (VT3336),"
	elog "P4M900/VN896 (VT3364), VX800 (VT3353), VX855 (VT3409), VX900"
	elog
	elog "The driver name is 'openchrome', and this is what you need"
	elog "to use in your xorg.conf (and not 'via')."
	elog
	elog "See the ChangeLog and release notes for more information."
}
