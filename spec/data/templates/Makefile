VERSION = 0.1.0

SRC_DIR = src
BUILD_DIR = build
DIST_DIR = dist/${VERSION}

JS_FILES = ${SRC_DIR}/email.js

RELEASE_FILES = README.txt HISTORY.txt
IMAGES = ${SRC_DIR}/images/*
CSS = ${SRC_DIR}/css/*

IMAGES_DIST = ${BUILD_DIR}/images
CSS_DIST = ${BUILD_DIR}/css

WE = ${BUILD_DIR}/jquery.email.js
WE_PACK = ${BUILD_DIR}/jquery.email.pack.js

WE_ARCH = ${DIST_DIR}/jquery.email.tar.gz
WE_RELEASE = ${DIST_DIR}/jquery.email-${VERSION}.tar.gz

MERGE = sed -e '1 s/^\xEF\xBB\xBF//' ${JS_FILES} > ${WE}
PACKER = perl -I$ lib/packer lib/packer/jsPacker.pl -i ${WE} -o ${WE_PACK} -e62

all: archive

merge:

	@@echo " - Cleaning Build dir " ${BUILD_DIR}
	@@rm -rf ${BUILD_DIR}
	@@mkdir -p ${BUILD_DIR}

	@@echo "Building" ${WE}

	@@echo " - Merging files"
	@@${MERGE}

	@@echo ${WE} "- built"
	@@echo

pack: merge
	@@echo " - Packing " ${WE_PACK}

	@@echo "Compressing using Packer"
	@@${PACKER}

	@@echo

archive: pack

	@@echo " - Cleaning Build dir " ${DIST_DIR}
	@@rm -rf ${DIST_DIR}
	@@mkdir -p ${DIST_DIR}
		
	@@echo "- Making archive" ${WE_RELEASE}

	@@echo "Making DIST dir" ${IMAGES_DIST} ${CSS_DIST}
	@@mkdir -p ${IMAGES_DIST} ${CSS_DIST}

	@@echo " - Coping CSS and images"
#	@@cp -R -f ${IMAGES} ${IMAGES_DIST}
	@@cp -R -f ${CSS} ${CSS_DIST}
	@@cp -f ${RELEASE_FILES} ${BUILD_DIR}
	
	@@echo " - Creating release"
	@@tar -cjf ${WE_RELEASE} ${BUILD_DIR}

	@@echo "Building" ${WE_ARCH}

	@@echo " - Creating archive"
	@@rm -f ${WE_ARCH}
	@@tar --exclude '.DS_Store ._' -czf ${WE_ARCH} .

	
	

