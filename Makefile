
PRODUCT_NAME=BSTREditor
PRODUCT_EXTENSION=app
BUILD_PATH=./build
DEPLOYMENT=Release
APP_BUNDLE=$(PRODUCT_NAME).$(PRODUCT_EXTENSION)
APP=$(BUILD_PATH)/$(DEPLOYMENT)/$(APP_BUNDLE)
APP_NAME=$(BUILD_PATH)/$(DEPLOYMENT)/$(PRODUCT_NAME)
INFO_PLIST=Info.plist

URL_BSTREditor = svn+ssh://macmini/usr/local/svnrepos/BSTREditor
HEAD = $(URL_BSTREditor)/BSTREditor
TAGS_DIR = $(URL_BSTREditor)/tags

VER_CMD=grep -A1 'CFBundleShortVersionString' $(INFO_PLIST) | tail -1 | tr -d "'\t</string>" 
VERSION=$(shell $(VER_CMD))

all:
	@echo do  nothig.
	@echo use target tagging 

tagging:
	@echo "Tagging the $(VERSION) (x) release of BSTREditor project."
	export LC_ALL=C;	\
	REV=`svn info | awk '/Last Changed Rev/ {print $$4}'` ;	\
	echo svn copy $(HEAD) $(TAGS_DIR)/release-$(VERSION).$${REV}

Localizable: BSTRADocument.m
	genstrings -o English.lproj $<
	(cd English.lproj; ${MAKE} $@;)
	genstrings -o Japanese.lproj $<
	(cd Japanese.lproj; ${MAKE} $@;)

checkLocalizable:
	(cd English.lproj; ${MAKE} $@;)
	(cd Japanese.lproj; ${MAKE} $@;)

release: updateRevision
	xcodebuild -configuration $(DEPLOYMENT)
	$(MAKE) restorInfoPlist

package: release
	export LC_ALL=C;	\
	REV=`svn info | awk '/Last Changed Rev/ {print $$4}'`;	\
	ditto -ck -rsrc --keepParent $(APP) $(APP_NAME)-$(VERSION)-$${REV}.zip

updateRevision: update_svn
	if [ ! -f $(INFO_PLIST).bak ] ; then cp $(INFO_PLIST) $(INFO_PLIST).bak ; fi ;	\
	export LC_ALL=C;	\
	REV=`svn info | awk '/Last Changed Rev/ {print $$4}'` ;	\
	sed -e "s/%%%%REVISION%%%%/$${REV}/" $(INFO_PLIST) > $(INFO_PLIST).r ;	\
	mv -f $(INFO_PLIST).r $(INFO_PLIST) ;	\

restorInfoPlist:
	if [ -f $(INFO_PLIST).bak ] ; then cp -f $(INFO_PLIST).bak $(INFO_PLIST) ; fi

update_svn:
	svn up

