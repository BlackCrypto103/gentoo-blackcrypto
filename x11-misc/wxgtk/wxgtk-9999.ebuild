# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit git-r3 wrapper xdg-utils desktop

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
	exeinto /opt/${PN}
	doexe wxgtk
	insinto /opt/${PN}
	doins -r resourceCreation
	doicon -s 512 resourceCreation/images/wx_launcher.png
	make_wrapper ${PN} "/opt/${PN}/${PN}" /opt/${PN} "/usr/lib64:/usr/lib" /usr/bin
	make_desktop_entry /usr/bin/wxgtk "wX" wx_launcher Science
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	elog "make sure to delete the \$HOME/.config/joshua.tee@gmail.com/wxgtk.conf file"
	elog "If the file is not removed it may cause the ${PN} program to crash after reinstalling with the old config file unfortunately"
	elog "https://gitlab.com/joshua.tee/wxgtk#output-to-local-filesystem-file-should-not-exist-before-running-program-for-first-time"
	xdg_icon_cache_update
	xdg_desktop_database_update
}
