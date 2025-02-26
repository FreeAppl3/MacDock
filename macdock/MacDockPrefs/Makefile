TARGET := iphone:clang:15.6

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MacDockPrefs

MacDockPrefs_FILES = MacDockRootListController.m
MacDockPrefs_FRAMEWORKS = UIKit
MacDockPrefs_PRIVATE_FRAMEWORKS = Preferences
MacDockPrefs_INSTALL_PATH = /Library/PreferenceBundles
MacDockPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
