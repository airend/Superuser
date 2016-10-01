# Root AOSP source makefile
# su is built here, and 

my_path := $(call my-dir)

LOCAL_PATH := $(my_path)
include $(CLEAR_VARS)

LOCAL_MODULE := su
LOCAL_CLANG := false
LOCAL_MODULE_TAGS := eng debug optional
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_STATIC_LIBRARIES := libc libcutils libselinux
LOCAL_C_INCLUDES := external/sqlite/dist
LOCAL_SRC_FILES := Superuser/jni/su/su.c Superuser/jni/su/daemon.c Superuser/jni/su/activity.c Superuser/jni/su/db.c Superuser/jni/su/utils.c Superuser/jni/su/pts.c Superuser/jni/sqlite3/sqlite3.c Superuser/jni/su/hacks.c Superuser/jni/su/binds.c
LOCAL_CFLAGS := -DSQLITE_OMIT_LOAD_EXTENSION -DREQUESTOR=\"$(SUPERUSER_PACKAGE)\"

ifdef SUPERUSER_PACKAGE_PREFIX
  LOCAL_CFLAGS += -DREQUESTOR_PREFIX=\"$(SUPERUSER_PACKAGE_PREFIX)\"
endif

ifdef SUPERUSER_EMBEDDED
  LOCAL_CFLAGS += -DSUPERUSER_EMBEDDED
endif

LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT_SBIN)
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

ifdef SUPERUSER_EMBEDDED

SUPERUSER_MARKER := $(TARGET_OUT_ETC)/.has_su_daemon
$(SUPERUSER_MARKER): $(LOCAL_INSTALLED_MODULE)
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) touch $@

ALL_MODULES.$(LOCAL_MODULE).INSTALLED := \
    $(ALL_MODULES.$(LOCAL_MODULE).INSTALLED) $(SUPERUSER_RC) $(SUPERUSER_MARKER)

endif

LOCAL_PATH := $(my_path)/Superuser
include $(CLEAR_VARS)

#SUPERUSER_PACKAGE := com.koushikdutta.superuser

#LOCAL_STATIC_JAVA_LIBRARIES := android-support-v4
#LOCAL_STATIC_JAVA_LIBRARIES += libarity

LOCAL_PACKAGE_NAME := Superuser

LOCAL_SRC_FILES := $(call all-java-files-under,src) $(call all-java-files-under,../Widgets/src)

LOCAL_AAPT_INCLUDE_ALL_RESOURCES := true
LOCAL_AAPT_FLAGS := --extra-packages com.koushikdutta.widgets -S $(LOCAL_PATH)/../Widgets/Widgets/res --auto-add-overlay --rename-manifest-package $(SUPERUSER_PACKAGE)

include $(BUILD_PACKAGE)
