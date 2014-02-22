include theos/makefiles/common.mk

ARCHS = armv7 armv7s arm64

BUNDLE_NAME = L2ASettings
L2ASettings_FILES = L2ASettings.mm L2AScriptController.m L2ATableViewCell.m L2AScript.m
L2ASettings_INSTALL_PATH = /Library/PreferenceBundles
L2ASettings_FRAMEWORKS = UIKit Foundation QuartzCore
L2ASettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/L2ASettings.plist$(ECHO_END)
