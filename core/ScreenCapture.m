//
//  ScreenCapture.m
//  SmallScreenshot
//
//  Wraps platform-specific capture (X11 on Linux) and PNG save.
//

#import "ScreenCapture.h"
#if defined(GNUSTEP) || defined(__linux__)
#import "ScreenCaptureX11.h"
#endif

@implementation ScreenCapture

#if defined(GNUSTEP) || defined(__linux__)

- (NSImage *)captureFullScreen {
    ScreenCaptureX11 *x11 = [[ScreenCaptureX11 alloc] init];
    NSImage *img = [x11 captureFullScreen];
    [x11 release];
    return img;
}

- (NSImage *)captureRegion:(NSRect)rect {
    ScreenCaptureX11 *x11 = [[ScreenCaptureX11 alloc] init];
    NSImage *img = [x11 captureRegionRect:rect];
    [x11 release];
    return img;
}

#else

- (NSImage *)captureFullScreen { return nil; }
- (NSImage *)captureRegion:(NSRect)rect { (void)rect; return nil; }

#endif

- (BOOL)saveImage:(NSImage *)image asPNGToPath:(NSString *)path error:(NSError **)error {
    if (!image || !path) {
        if (error) *error = [NSError errorWithDomain:@"ScreenCapture" code:1 userInfo:@{ NSLocalizedDescriptionKey: @"Missing image or path" }];
        return NO;
    }
    NSBitmapImageRep *rep = nil;
    NSArray *reps = [image representations];
    for (NSImageRep *r in reps) {
        if ([r isKindOfClass:[NSBitmapImageRep class]]) {
            rep = (NSBitmapImageRep *)r;
            break;
        }
    }
    if (!rep) {
        NSInteger w = (NSInteger)[image size].width;
        NSInteger h = (NSInteger)[image size].height;
        if (w <= 0 || h <= 0) {
            if (error) *error = [NSError errorWithDomain:@"ScreenCapture" code:2 userInfo:@{ NSLocalizedDescriptionKey: @"Invalid image size" }];
            return NO;
        }
        rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                                                     pixelsWide:w pixelsHigh:h
                                                  bitsPerSample:8 samplesPerPixel:4
                                                         hasAlpha:YES isPlanar:NO
                                                   colorSpaceName:NSDeviceRGBColorSpace
                                                      bytesPerRow:w * 4 bitsPerPixel:32];
        if (!rep) {
            if (error) *error = [NSError errorWithDomain:@"ScreenCapture" code:3 userInfo:@{ NSLocalizedDescriptionKey: @"Could not create bitmap" }];
            return NO;
        }
        [rep setAlpha:YES];
        NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep:rep];
        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext:ctx];
        [image drawInRect:NSMakeRect(0, 0, (CGFloat)w, (CGFloat)h) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        [NSGraphicsContext restoreGraphicsState];
        [rep autorelease];
    }
    NSData *pngData = [rep representationUsingType:NSPNGFileType properties:[NSDictionary dictionary]];
    if (!pngData) {
        if (error) *error = [NSError errorWithDomain:@"ScreenCapture" code:4 userInfo:@{ NSLocalizedDescriptionKey: @"Could not create PNG data" }];
        return NO;
    }
    BOOL ok = [pngData writeToFile:path atomically:YES];
    if (!ok && error) {
        *error = [NSError errorWithDomain:@"ScreenCapture" code:5 userInfo:@{ NSLocalizedDescriptionKey: @"Could not write file" }];
    }
    return ok;
}

@end
