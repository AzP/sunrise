# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils linux-mod

DESCRIPTION="An entirely re-designed and re-implemented Unionfs."
HOMEPAGE="http://aufs.sourceforge.net/"
SRC_URI="http://www.fh-kl.de/~torsten.kockler/gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ksize nfs"

MODULE_NAMES="aufs(addon/fs/${PN}:)"
BUILD_PARAMS="KDIR=${KV_DIR} -f local.mk"
BUILD_TARGETS="all"

check_patch() {
	get_version

	# Check if ksize Patch has to be applied
	if use ksize ; then
		APPLY_KSIZE_PATCH="n"
		# If ksize patch is not applied 
		if ! grep -qs "EXPORT_SYMBOL(ksize);" "${KV_DIR}/mm/slab.c" ; then
			APPLY_KSIZE_PATCH="y"
		fi
	fi
	
	# Check if lhash Patch has to be applied
	if use nfs && kernel_is ge 2 6 19 ; then
		APPLY_LHASH_PATCH="n"
		# If lhash patch is not applied
		if ! grep -qs "EXPORT_SYMBOL(__lookup_hash);" "${KV_DIR}/fs/namei.c" \
		&& ! grep -qs "struct dentry * __lookup_hash(struct qstr *name, struct dentry
		* base, struct nameidata *nd);" "${KV_DIR}/fs/namei.h" ; then
			APPLY_LHASH_PATCH="y"
		fi
	fi
}

pkg_setup() {
	# kernel version check
	if kernel_is lt 2 6 16 ; then
		eerror "${PN} is being developed and tested on linux-2.6.16 and later."
		eerror "Make sure you have a proper kernel version!"
		die "Wrong kernel version"
	fi

	check_patch

	# If a patch has to be applied
	if [[ ${APPLY_KSIZE_PATCH} == "y" ]] || [[ ${APPLY_LHASH_PATCH} == "y" ]] ; then
		ewarn "Patching your kernel..."
		cd ${KV_DIR}
	fi
	
	# If the ksize patch has to be applied
	if [[ ${APPLY_KSIZE_PATCH} == "y" ]] ; then
		epatch "${FILESDIR}"/${P}-ksize.patch
	fi

	# If the lhash patch has to be applied
	if [[ ${APPLY_LHASH_PATCH} == "y" ]] ; then
		epatch "${FILESDIR}"/${P}-lhash.patch
	fi

	linux-mod_pkg_setup
}

src_unpack(){
	unpack ${A}
	cd "${S}"

	# Enable ksize Patch in local.mk
	if use ksize
	then
		sed -i -e 's/^#CONFIG_AUFS_KSIZE_PATCH/CONFIG_AUFS_KSIZE_PATCH/g' local.mk || die "Sed failed!"
	fi
	
	# Enable lhash Patch in local.mk
	if use nfs && kernel_is ge 2 6 19
	then
		sed -i -e 's/^#CONFIG_AUFS_LHASH_PATCH/CONFIG_AUFS_LHASH_PATCH/g' local.mk || die "Sed failed!"
	fi

}

src_install() {
	exeinto /sbin
	exeopts -m0500
	doexe mount.aufs umount.aufs auplink aulchown
	doman aufs.5
	linux-mod_src_install
}

pkg_postinst() {
	elog "To be able to use aufs, you have to load the kernel module by typing:"
	elog "modprobe aufs"
	elog "For further information refer to the aufs man page"

	linux-mod_pkg_postinst
}

pkg_postrm() {
	check_patch

	# Tell the user that his kernel has already been patched
	if [[ ${APPLY_KSIZE_PATCH} == "n" ]] || [[ ${APPLY_LHASH_PATCH} == "n" ]]
	then
		ewarn "Your kernel has been patched previously by this ebuild."
		ewarn "You can undo the patches by executing the following:"
		echo
		ewarn "cd ${KV_DIR}; make mrproper and re-emerge your kernel - ${KV_FULL}"
	fi

	# Tell the user to recompile his kernel
	if [[ ${APPLY_KSIZE_PATCH} == "y" ]] || [[ ${APPLY_LHASH_PATCH} == "y" ]]
	then
		echo
		ewarn "Remember to re-compile your kernel to make the patch(es) work"
		ewarn
	fi

	linux-mod_pkg_postrm
}
