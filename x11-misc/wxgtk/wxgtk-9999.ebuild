# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 xdg-utils desktop

DESCRIPTION="The wX weather app port to GTK written in Vala"
HOMEPAGE="https://gitlab.com/joshua.tee/wxgtk"
EGIT_REPO_URI="https://gitlab.com/joshua.tee/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk4"
DEPEND=""
RDEPEND="${DEPEND}
		dev-libs/libgee:0.8
		dev-libs/glib:2
		net-libs/libsoup:2.4
		dev-libs/libzip
		gtk4? ( gui-libs/gtk ) !gtk4? ( x11-libs/gtk+:3 )
"
BDEPEND="
		sys-devel/make
		dev-util/meson
		dev-util/ninja
"

src_compile() {
	if use gtk4;then
		./makeAll.py --gtk4
	else
		./makeAll.py
	fi
}

src_install() {
	default
	insinto /usr/bin
	dobin wxgtk

	doicon -s 512 resourceCreation/images/wx_launcher.png
	make_desktop_entry /usr/bin/${PN} "wX" wx_launcher Science 
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
