# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="5"

DESCRIPTION="empty project"
HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"

S=$WORKDIR

src_install() {
  exeinto /opt/google/drive-file-stream
  doexe ${FILESDIR}/${ARCH}/drivefs
  exeinto /usr/lib64
  doexe ${FILESDIR}/${ARCH}/libdrivefs.so
}
