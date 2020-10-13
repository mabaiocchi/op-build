################################################################################
#
#  sb-signing-utils
#
################################################################################


SB_SIGNING_UTILS_SITE ?= $(call github,open-power,sb-signing-utils,$(SB_SIGNING_UTILS_VERSION))

SB_SIGNING_UTILS_LICENSE = Apache-2.0
SB_SIGNING_UTILS_LICENSE_FILES = LICENSE

# MAB can either use the direct commit or v0.9 if this commit gets marked with that
SB_SIGNING_UTILS_VERSION ?= 591c8f53482243626901e1cc8a4ae321f314040d

HOST_SB_SIGNING_UTILS_DEPENDENCIES = host-openssl

ifeq ($(BR2_OPENPOWER_SECUREBOOT_SIGN_MODE),production)
HOST_SB_SIGNING_UTILS_DEPENDENCIES += host-sb-signing-framework
else ifeq ($(BR2_OPENPOWER_SECUREBOOT_KEY_TRANSITION_TO_PROD),y)
HOST_SB_SIGNING_UTILS_DEPENDENCIES += host-sb-signing-framework
endif

HOST_SB_SIGNING_UTILS_AUTORECONF = YES
HOST_SB_SIGNING_UTILS_AUTORECONF_OPTS = -i

define HOST_SB_SIGNING_UTILS_COPY_FILES
	$(INSTALL) -m 0755 $(@D)/crtSignedContainer.sh $(HOST_DIR)/usr/bin/
endef

SB_SIGNING_UTILS_KEY_SRC_PATH=$(BR2_EXTERNAL)/package/sb-signing-utils/keys
SB_SIGNING_UTILS_KEY_DST_PATH=$(HOST_DIR)/etc/keys

define HOST_SB_SIGNING_UTILS_COPY_KEYS
	$(INSTALL) -d -m 0755 $(SB_SIGNING_UTILS_KEY_DST_PATH)
	$(INSTALL) -m 0755 $(SB_SIGNING_UTILS_KEY_SRC_PATH)/* \
		$(SB_SIGNING_UTILS_KEY_DST_PATH)
endef

HOST_SB_SIGNING_UTILS_POST_INSTALL_HOOKS += HOST_SB_SIGNING_UTILS_COPY_FILES
HOST_SB_SIGNING_UTILS_POST_INSTALL_HOOKS += HOST_SB_SIGNING_UTILS_COPY_KEYS

$(eval $(host-autotools-package))
