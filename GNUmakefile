# GNUmakefile for SmallScreenshot (Linux/GNUStep)
#
# Screenshot tool: full screen and region capture, save as PNG.
# Uses SmallStepLib for app lifecycle and FOSS: libX11 for capture.
#

include $(GNUSTEP_MAKEFILES)/common.make

APP_NAME = SmallScreenshot

SmallScreenshot_OBJC_FILES = \
	main.m \
	app/AppDelegate.m \
	core/ScreenCapture.m \
	core/ScreenCaptureX11.m \
	ui/MainWindow.m \
	ui/CaptureOverlayWindow.m

SmallScreenshot_HEADER_FILES = \
	app/AppDelegate.h \
	core/ScreenCapture.h \
	core/ScreenCaptureX11.h \
	ui/MainWindow.h \
	ui/CaptureOverlayWindow.h

SmallScreenshot_INCLUDE_DIRS = \
	-I. \
	-Iapp \
	-Icore \
	-Iui \
	-I../SmallStepLib/SmallStep/Core \
	-I../SmallStepLib/SmallStep/Platform/Linux

# X11 for screen capture (Linux)
X11_CFLAGS := $(shell pkg-config --cflags x11 2>/dev/null)
X11_LIBS   := $(shell pkg-config --libs x11 2>/dev/null)
ifeq ($(X11_CFLAGS),)
  ifneq ($(wildcard /usr/include/X11/Xlib.h),)
    X11_CFLAGS := -I/usr/include
    X11_LIBS   := -lX11
  endif
endif

SmallScreenshot_INCLUDE_DIRS += $(X11_CFLAGS)

# SmallStep framework/library
SMALLSTEP_FRAMEWORK := $(shell find ../SmallStepLib -name "SmallStep.framework" -type d 2>/dev/null | head -1)
ifneq ($(SMALLSTEP_FRAMEWORK),)
  SMALLSTEP_LIB_DIR := $(shell cd $(SMALLSTEP_FRAMEWORK)/Versions/0 2>/dev/null && pwd)
  SMALLSTEP_LIB_PATH := -L$(SMALLSTEP_LIB_DIR)
  SMALLSTEP_LDFLAGS := -Wl,-rpath,$(SMALLSTEP_LIB_DIR)
else
  SMALLSTEP_LIB_PATH :=
  SMALLSTEP_LDFLAGS :=
endif

SmallScreenshot_LIBRARIES_DEPEND_UPON = -lobjc -lgnustep-gui -lgnustep-base
SmallScreenshot_LDFLAGS = $(SMALLSTEP_LIB_PATH) $(SMALLSTEP_LDFLAGS) -Wl,--allow-shlib-undefined
SmallScreenshot_ADDITIONAL_LDFLAGS = $(SMALLSTEP_LIB_PATH) $(SMALLSTEP_LDFLAGS) -lSmallStep $(X11_LIBS)
SmallScreenshot_TOOL_LIBS = -lSmallStep $(X11_LIBS) -lobjc

include $(GNUSTEP_MAKEFILES)/application.make
