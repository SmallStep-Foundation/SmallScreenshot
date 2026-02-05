//
//  ScreenCaptureX11.m
//  SmallScreenshot
//
//  X11 screen capture using libX11. Converts XImage to NSImage (RGB).
//

#import "ScreenCaptureX11.h"
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <objc/runtime.h>

#if defined(__GNUSTEP__) || defined(__linux__)
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#endif

static const void *kPixelDataKey = "ScreenCaptureX11PixelData";

@implementation ScreenCaptureX11

#if defined(__GNUSTEP__) || defined(__linux__)

static int maskToShift(unsigned long mask) {
    int shift = 0;
    while (mask && !(mask & 1)) {
        shift++;
        mask >>= 1;
    }
    return shift;
}

- (NSImage *)captureFullScreen {
    Display *dpy = XOpenDisplay(NULL);
    if (!dpy) return nil;
    Window root = DefaultRootWindow(dpy);
    XWindowAttributes attrs;
    if (!XGetWindowAttributes(dpy, root, &attrs)) {
        XCloseDisplay(dpy);
        return nil;
    }
    NSImage *img = [self captureRegionX:0 y:0 width:attrs.width height:attrs.height withDisplay:dpy root:root];
    XCloseDisplay(dpy);
    return img;
}

- (NSImage *)captureRegionX:(int)x y:(int)y width:(int)width height:(int)height {
    Display *dpy = XOpenDisplay(NULL);
    if (!dpy) return nil;
    Window root = DefaultRootWindow(dpy);
    NSImage *img = [self captureRegionX:x y:y width:width height:height withDisplay:dpy root:root];
    XCloseDisplay(dpy);
    return img;
}

- (NSImage *)captureRegionRect:(NSRect)rect {
    Display *dpy = XOpenDisplay(NULL);
    if (!dpy) return nil;
    Window root = DefaultRootWindow(dpy);
    XWindowAttributes attrs;
    if (!XGetWindowAttributes(dpy, root, &attrs)) {
        XCloseDisplay(dpy);
        return nil;
    }
    /* AppKit: origin bottom-left. X11: origin top-left. */
    int x11_y = attrs.height - (int)(rect.origin.y + rect.size.height);
    if (x11_y < 0) x11_y = 0;
    NSImage *img = [self captureRegionX:(int)rect.origin.x y:x11_y width:(int)rect.size.width height:(int)rect.size.height withDisplay:dpy root:root];
    XCloseDisplay(dpy);
    return img;
}

- (NSImage *)captureRegionX:(int)x y:(int)y width:(int)width height:(int)height
                withDisplay:(Display *)dpy root:(Window)root {
    XImage *ximg = XGetImage(dpy, root, x, y, (unsigned int)width, (unsigned int)height, AllPlanes, ZPixmap);
    if (!ximg) return nil;

    int w = ximg->width;
    int h = ximg->height;
    unsigned long rm = ximg->red_mask;
    unsigned long gm = ximg->green_mask;
    unsigned long bm = ximg->blue_mask;
    int rs = maskToShift(rm);
    int gs = maskToShift(gm);
    int bs = maskToShift(bm);

    size_t rowBytes = (size_t)w * 3;
    unsigned char *rgb = (unsigned char *)malloc(rowBytes * (size_t)h);
    if (!rgb) {
        XDestroyImage(ximg);
        return nil;
    }

    int row, col;
    for (row = 0; row < h; row++) {
        for (col = 0; col < w; col++) {
            unsigned long pixel = XGetPixel(ximg, col, row);
            unsigned char r = (unsigned char)((pixel & rm) >> rs);
            unsigned char g = (unsigned char)((pixel & gm) >> gs);
            unsigned char b = (unsigned char)((pixel & bm) >> bs);
            size_t idx = (size_t)row * rowBytes + (size_t)col * 3;
            rgb[idx]     = r;
            rgb[idx + 1] = g;
            rgb[idx + 2] = b;
        }
    }
    XDestroyImage(ximg);

    /* Keep pixel buffer alive for the lifetime of the image (rep does not copy) */
    NSMutableData *data = [NSMutableData dataWithLength:rowBytes * (size_t)h];
    if (!data) {
        free(rgb);
        return nil;
    }
    memcpy([data mutableBytes], rgb, rowBytes * (size_t)h);
    free(rgb);

    unsigned char *planes[1] = { (unsigned char *)[data mutableBytes] };
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:planes
                                                                   pixelsWide:w
                                                                   pixelsHigh:h
                                                                bitsPerSample:8
                                                              samplesPerPixel:3
                                                                     hasAlpha:NO
                                                                     isPlanar:NO
                                                               colorSpaceName:NSDeviceRGBColorSpace
                                                                  bytesPerRow:(NSInteger)rowBytes
                                                                 bitsPerPixel:24];
    NSImage *image = nil;
    if (rep) {
        image = [[NSImage alloc] initWithSize:NSMakeSize((CGFloat)w, (CGFloat)h)];
        if (image) {
            [image addRepresentation:rep];
            objc_setAssociatedObject(image, kPixelDataKey, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [rep release];
    }
    return [image autorelease];
}

#else

- (NSImage *)captureFullScreen { (void)self; return nil; }
- (NSImage *)captureRegionX:(int)x y:(int)y width:(int)width height:(int)height {
    (void)self; (void)x; (void)y; (void)width; (void)height; return nil;
}
- (NSImage *)captureRegionRect:(NSRect)rect { (void)self; (void)rect; return nil; }

#endif

@end
