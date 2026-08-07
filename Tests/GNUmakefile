#
# SmallScreenshot unit tests
# Build from SmallScreenshot: make -f Tests/GNUmakefile
# Run: ./Tests/obj/test_SmallScreenshot
#

include $(GNUSTEP_MAKEFILES)/common.make

# SmallStep framework (shared discovery - SmallStepLib/GNUmakefile.include)
-include ../../SmallStepLib/GNUmakefile.include

X11_CFLAGS := $(shell pkg-config --cflags x11 2>/dev/null)
X11_LIBS   := $(shell pkg-config --libs x11 2>/dev/null)

TOOL_NAME = test_SmallScreenshot
test_SmallScreenshot_OBJC_FILES = SmallScreenshotTests.m ../app/AppDelegate.m ../core/ScreenCapture.m ../core/ScreenCaptureX11.m ../ui/MainWindow.m ../ui/CaptureOverlayWindow.m
test_SmallScreenshot_INCLUDE_DIRS = -I.. -I../app -I../core -I../ui
test_SmallScreenshot_INCLUDE_DIRS += $(SMALLSTEP_INCLUDE_DIRS) -I../../SmallStepLib/Tests $(X11_CFLAGS)
test_SmallScreenshot_TOOL_LIBS = -lSmallStep -lgnustep-gui -lgnustep-base -lobjc $(X11_LIBS)
test_SmallScreenshot_LDFLAGS = $(SMALLSTEP_LIB_PATH) $(SMALLSTEP_LDFLAGS) -Wl,--allow-shlib-undefined

before-all::
	$(MAKE) -C ../../SmallStepLib
	$(MAKE) -C ..

include $(GNUSTEP_MAKEFILES)/tool.make
