# GNUmakefile for SmallScreenshot (Linux/GNUStep)
#
# Screenshot tool: full screen and region capture, save as PNG.
# Uses SmallStepLib for app lifecycle and FOSS: libX11 for capture.
#
# Build SmallStepLib first: cd ../SmallStepLib && make
# Then: make

include $(GNUSTEP_MAKEFILES)/common.make

# Guard: always build the app by default. An explicit .DEFAULT_GOAL makes
# plain 'make' immune to reordering of rules below (e.g. a before-all::
# block before the application.make include would otherwise become the
# default goal and silently skip the app build).
.DEFAULT_GOAL := all

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

# X11 for screen capture (Linux)
X11_CFLAGS := $(shell pkg-config --cflags x11 2>/dev/null)
X11_LIBS   := $(shell pkg-config --libs x11 2>/dev/null)
ifeq ($(X11_CFLAGS),)
  ifneq ($(wildcard /usr/include/X11/Xlib.h),)
    X11_CFLAGS := -I/usr/include
    X11_LIBS   := -lX11
  endif
endif

SmallScreenshot_INCLUDE_DIRS = \
	-I. \
	-Iapp \
	-Icore \
	-Iui \
	$(SMALLSTEP_INCLUDE_DIRS) \
	$(X11_CFLAGS)

# SmallStep framework (shared discovery - SmallStepLib/GNUmakefile.include)
-include ../SmallStepLib/GNUmakefile.include

SmallScreenshot_LIBRARIES_DEPEND_UPON = -lobjc -lgnustep-gui -lgnustep-base
SmallScreenshot_LDFLAGS = $(SMALLSTEP_LIB_PATH) $(SMALLSTEP_LDFLAGS) -Wl,--allow-shlib-undefined
SmallScreenshot_ADDITIONAL_LDFLAGS = $(SMALLSTEP_LIB_PATH) $(SMALLSTEP_LDFLAGS) -lSmallStep $(X11_LIBS)
SmallScreenshot_TOOL_LIBS = -lSmallStep -lobjc $(X11_LIBS)

SmallScreenshot_RESOURCE_FILES = \
	Resources/SmallScreenshot.png \
	Resources/logo.png
# Application icon (bare filename; copied into the bundle Resources dir)
SmallScreenshot_APPLICATION_ICON = SmallScreenshot.png

include $(GNUSTEP_MAKEFILES)/application.make

# Copy the shared logo into Resources before the build (defined after
# the application.make include so it is not the makefile default goal)
before-all::
	mkdir -p Resources && cp -f ../SmallStepLib/Resources/logo.png Resources/logo.png 2>/dev/null || true
