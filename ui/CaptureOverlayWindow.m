//
//  CaptureOverlayWindow.m
//  SmallScreenshot
//
//  Fullscreen overlay for region selection. User drags to draw a rectangle.
//

#import "CaptureOverlayWindow.h"
#import "MainWindow.h"
#import "SmallStep.h"

#if defined(GNUSTEP)
#  define NSWindowStyleMaskBorderless NSBorderlessWindowMask
#  define NSBackingStoreBuffered      NSBackingStoreBuffered
#endif

@interface CaptureOverlayView : NSView {
    CaptureOverlayWindow *_overlayWindow;
}
@property (nonatomic, assign) CaptureOverlayWindow *overlayWindow;
@end

@implementation CaptureOverlayView
@synthesize overlayWindow = _overlayWindow;

- (void)drawRect:(NSRect)dirtyRect {
    (void)dirtyRect;
    NSRect sel = [_overlayWindow selectionRect];
    if (sel.size.width > 0 && sel.size.height > 0) {
        [[NSColor colorWithCalibratedWhite:1.0 alpha:0.3] set];
        NSRectFill(sel);
        [[NSColor whiteColor] set];
        NSFrameRectWithWidth(sel, 2.0);
    }
}

- (BOOL)acceptsFirstResponder { return YES; }
- (BOOL)acceptsFirstMouse:(NSEvent *)event { (void)event; return YES; }
@end

@interface CaptureOverlayWindow ()
- (NSRect)selectionRect;
- (void)setSelectionRect:(NSRect)r;
- (void)finishCapture;
@end

@implementation CaptureOverlayWindow

@synthesize mainWindow = _mainWindow;

- (id)initWithMainWindow:(MainWindow *)mainWindow {
    _mainWindow = mainWindow;
    NSRect frame = [[NSScreen mainScreen] frame];
    self = [super initWithContentRect:frame
                             styleMask:NSWindowStyleMaskBorderless
                               backing:NSBackingStoreBuffered
                                 defer:NO];
    if (self) {
        [self setBackgroundColor:[NSColor colorWithCalibratedWhite:0.0 alpha:0.3]];
        [self setOpaque:NO];
        [self setIgnoresMouseEvents:NO];
        [self setLevel:NSScreenSaverWindowLevel];
        [self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];

        CaptureOverlayView *view = [[CaptureOverlayView alloc] initWithFrame:frame];
        [view setOverlayWindow:self];
        [view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [self setContentView:view];
        [view release];

        _selectionRect = NSZeroRect;
    }
    return self;
}

- (NSRect)selectionRect { return _selectionRect; }
- (void)setSelectionRect:(NSRect)r { _selectionRect = r; }

- (void)showOverlay {
    [self setFrame:[[NSScreen mainScreen] frame] display:YES];
    [self orderFrontRegardless];
    [self makeFirstResponder:[self contentView]];
}

- (void)cancelCapture {
    [self orderOut:nil];
    [_mainWindow regionCaptureDidFinishWithRect:NSZeroRect];
}

- (void)finishCapture {
    NSRect r = _selectionRect;
    [self orderOut:nil];
    if (_mainWindow) {
        [_mainWindow regionCaptureDidFinishWithRect:r];
    }
}

@end
