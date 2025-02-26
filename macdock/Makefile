TARGET := iphone:clang:15.6

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = macdock

macdock_FILES = Tweak.xm
macdock_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += MacDockPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
