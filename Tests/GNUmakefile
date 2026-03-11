#
# SmallScreenshot unit tests
# Build from SmallScreenshot: make -f Tests/GNUmakefile
# Run: ./Tests/obj/test_SmallScreenshot
#

include $(GNUSTEP_MAKEFILES)/common.make

SMALLSTEP_FRAMEWORK := $(shell find ../../SmallStepLib -name "SmallStep.framework" -type d 2>/dev/null | head -1)
ifneq ($(SMALLSTEP_FRAMEWORK),)
  SMALLSTEP_LIB_DIR := $(shell cd $(SMALLSTEP_FRAMEWORK)/Versions/0 2>/dev/null && pwd)
  SMALLSTEP_LIB_PATH := -L$(SMALLSTEP_LIB_DIR)
  SMALLSTEP_LDFLAGS := -Wl,-rpath,$(SMALLSTEP_LIB_DIR)
else
  SMALLSTEP_LIB_PATH :=
  SMALLSTEP_LDFLAGS :=
endif

X11_CFLAGS := $(shell pkg-config --cflags x11 2>/dev/null)
X11_LIBS   := $(shell pkg-config --libs x11 2>/dev/null)

TOOL_NAME = test_SmallScreenshot
test_SmallScreenshot_OBJC_FILES = SmallScreenshotTests.m ../app/AppDelegate.m ../core/ScreenCapture.m ../core/ScreenCaptureX11.m ../ui/MainWindow.m ../ui/CaptureOverlayWindow.m
test_SmallScreenshot_INCLUDE_DIRS = -I.. -I../app -I../core -I../ui
test_SmallScreenshot_INCLUDE_DIRS += -I../../SmallStepLib/SmallStep/Core -I../../SmallStepLib/SmallStep/Platform/Linux -I../../SmallStepLib/Tests
test_SmallScreenshot_INCLUDE_DIRS += $(X11_CFLAGS)
test_SmallScreenshot_TOOL_LIBS = -lSmallStep -lgnustep-gui -lgnustep-base -lobjc $(X11_LIBS)
test_SmallScreenshot_LDFLAGS = $(SMALLSTEP_LIB_PATH) $(SMALLSTEP_LDFLAGS) -Wl,--allow-shlib-undefined

before-all::
	$(MAKE) -C ../../SmallStepLib
	$(MAKE) -C ..

include $(GNUSTEP_MAKEFILES)/tool.make
