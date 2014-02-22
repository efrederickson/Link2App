THEOS_DEVICE_IP=192.168.7.146
ARCHS=armv7 armv7s arm64

include theos/makefiles/common.mk

TWEAK_NAME = Link2App
Link2App_FILES = \
	lua/lapi.c lua/lcode.c lua/lctype.c lua/ldebug.c lua/ldo.c lua/ldump.c \
	lua/lfunc.c lua/lgc.c lua/llex.c lua/lmem.c lua/lobject.c lua/lopcodes.c lua/lparser.c \
	lua/lstate.c lua/lstring.c lua/ltable.c lua/ltm.c lua/lundump.c lua/lvm.c lua/lzio.c \
	lua/lauxlib.c lua/lbaselib.c lua/lbitlib.c lua/lcorolib.c lua/ldblib.c lua/liolib.c \
	lua/lmathlib.c lua/loslib.c lua/lstrlib.c lua/ltablib.c lua/loadlib.c lua/linit.c lua/lfs.c L2ALuaBinding.m Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += l2asettings
include $(THEOS_MAKE_PATH)/aggregate.mk
