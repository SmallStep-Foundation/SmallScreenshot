//
//  ScreenCapture.h
//  SmallScreenshot
//
//  Cross-platform screen capture. On Linux/GNUStep uses X11 (libX11).
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Captures screen or region and returns NSImage; supports saving as PNG.
@interface ScreenCapture : NSObject

/// Capture the full screen. Returns nil on failure.
- (NSImage * _Nullable)captureFullScreen;

/// Capture a region of the screen (x, y, width, height in screen coordinates).
/// Returns nil on failure.
- (NSImage * _Nullable)captureRegion:(NSRect)rect;

/// Save image as PNG to the given path. Returns YES on success.
- (BOOL)saveImage:(NSImage *)image asPNGToPath:(NSString *)path error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
