//
//  ScreenCaptureX11.h
//  SmallScreenshot
//
//  X11-based screen capture (Linux). Uses libX11 for root window capture.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

/// X11 screen capture: captures root window or a region and converts to NSImage.
@interface ScreenCaptureX11 : NSObject

/// Capture full root window. Caller must release returned NSImage.
- (NSImage * _Nullable)captureFullScreen;

/// Capture region (x, y, width, height) in X11/screen coordinates (origin top-left).
- (NSImage * _Nullable)captureRegionX:(int)x y:(int)y width:(int)width height:(int)height;

/// Capture region given in AppKit coordinates (origin bottom-left). Converts to X11 and captures.
- (NSImage * _Nullable)captureRegionRect:(NSRect)rect;

@end

NS_ASSUME_NONNULL_END
