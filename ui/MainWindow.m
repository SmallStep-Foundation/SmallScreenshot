//
//  MainWindow.m
//  SmallScreenshot
//

#import "MainWindow.h"
#import "AppDelegate.h"
#import "ScreenCapture.h"
#import "CaptureOverlayWindow.h"
#import "SmallStep.h"

#if defined(GNUSTEP)
#  define NSWindowStyleMaskTitled       NSTitledWindowMask
#  define NSWindowStyleMaskClosable    NSClosableWindowMask
#  define NSWindowStyleMaskMiniaturizable NSMiniaturizableWindowMask
#  define NSWindowStyleMaskResizable   NSResizableWindowMask
#  define NSBackingStoreBuffered       NSBackingStoreBuffered
#  define NSModalResponseOK            NSOKButton
#  define NSFileHandlingPanelOKButton  NSOKButton
#endif

@implementation MainWindow

@synthesize appDelegate = _appDelegate;
@synthesize currentImage = _currentImage;

- (id)initWithAppDelegate:(AppDelegate *)delegate {
    NSUInteger style = [SSWindowStyle standardWindowMask];
    NSRect contentRect = NSMakeRect(100, 100, 700, 550);
    self = [super initWithContentRect:contentRect
                             styleMask:style
                               backing:NSBackingStoreBuffered
                                 defer:NO];
    if (self) {
        _appDelegate = delegate;
        _capture = [[ScreenCapture alloc] init];
        _currentImage = nil;
        _overlayWindow = nil;

        [self setTitle:@"SmallScreenshot"];
        [self setReleasedWhenClosed:NO];

        NSView *contentView = [self contentView];
        NSRect bounds = [contentView bounds];

        CGFloat btnY = bounds.size.height - 36;
        CGFloat margin = 12;

        _captureFullButton = [[NSButton alloc] initWithFrame:NSMakeRect(margin, btnY, 160, 28)];
        [_captureFullButton setTitle:@"Capture Full Screen"];
        [_captureFullButton setButtonType:NSMomentaryPushButton];
        [_captureFullButton setBezelStyle:NSRoundedBezelStyle];
        [_captureFullButton setTarget:self];
        [_captureFullButton setAction:@selector(captureFullScreen)];
        [contentView addSubview:_captureFullButton];

        _captureRegionButton = [[NSButton alloc] initWithFrame:NSMakeRect(margin + 170, btnY, 140, 28)];
        [_captureRegionButton setTitle:@"Capture Region…"];
        [_captureRegionButton setButtonType:NSMomentaryPushButton];
        [_captureRegionButton setBezelStyle:NSRoundedBezelStyle];
        [_captureRegionButton setTarget:self];
        [_captureRegionButton setAction:@selector(startRegionCapture)];
        [contentView addSubview:_captureRegionButton];

        _saveButton = [[NSButton alloc] initWithFrame:NSMakeRect(bounds.size.width - margin - 120, btnY, 120, 28)];
        [_saveButton setTitle:@"Save…"];
        [_saveButton setButtonType:NSMomentaryPushButton];
        [_saveButton setBezelStyle:NSRoundedBezelStyle];
        [_saveButton setTarget:self];
        [_saveButton setAction:@selector(saveScreenshot)];
        [_saveButton setEnabled:NO];
        [contentView addSubview:_saveButton];

        NSRect scrollFrame = NSMakeRect(margin, margin, bounds.size.width - 2 * margin, btnY - 2 * margin);
        _scrollView = [[NSScrollView alloc] initWithFrame:scrollFrame];
        [_scrollView setHasVerticalScroller:YES];
        [_scrollView setHasHorizontalScroller:YES];
        [_scrollView setBorderType:NSBezelBorder];
        [_scrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];

        _imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, scrollFrame.size.width - 24, scrollFrame.size.height - 24)];
        [_imageView setImageScaling:NSImageScaleProportionallyDown];
        [_imageView setImageFrameStyle:NSImageFrameNone];
        [_scrollView setDocumentView:_imageView];
        [_imageView release];

        [contentView addSubview:_scrollView];
        [_scrollView release];
    }
    return self;
}

- (void)dealloc {
    [_captureFullButton release];
    [_captureRegionButton release];
    [_saveButton release];
    [_imageView release];
    [_scrollView release];
    [_currentImage release];
    [_capture release];
    [_overlayWindow release];
    [super dealloc];
}

- (void)setCurrentImage:(NSImage *)img {
    if (_currentImage != img) {
        [_currentImage release];
        _currentImage = [img retain];
    }
    [_imageView setImage:_currentImage];
    [_saveButton setEnabled:(_currentImage != nil)];
}

- (void)captureFullScreen {
    [_captureFullButton setEnabled:NO];
    [self performSelectorInBackground:@selector(captureFullScreenInBackground) withObject:nil];
}

- (void)captureFullScreenInBackground {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSImage *img = [_capture captureFullScreen];
    [SSConcurrency performSelectorOnMainThread:@selector(captureFullScreenDone:) onTarget:self withObject:img waitUntilDone:YES];
    [pool drain];
}

- (void)captureFullScreenDone:(NSImage *)img {
    [_captureFullButton setEnabled:YES];
    if (img) {
        [self setCurrentImage:img];
    }
}

- (void)startRegionCapture {
    _overlayWindow = [[CaptureOverlayWindow alloc] initWithMainWindow:self];
    [_overlayWindow showOverlay];
    [self orderOut:nil];
}

- (void)regionCaptureDidFinishWithRect:(NSRect)rect {
    [self makeKeyAndOrderFront:nil];
    [_overlayWindow release];
    _overlayWindow = nil;

    if (rect.size.width > 0 && rect.size.height > 0) {
        [SSConcurrency performSelectorInBackground:@selector(captureRegionInBackground:) onTarget:self withObject:[NSValue valueWithRect:rect]];
    }
}

- (void)captureRegionInBackground:(NSValue *)rectValue {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSRect r = [rectValue rectValue];
    NSImage *img = [_capture captureRegion:r];
    [SSConcurrency performSelectorOnMainThread:@selector(captureFullScreenDone:) onTarget:self withObject:img waitUntilDone:YES];
    [pool drain];
}

- (void)saveScreenshot {
    if (!_currentImage) return;

    SSFileDialog *dialog = [SSFileDialog saveDialog];
    [dialog setAllowedFileTypes:[NSArray arrayWithObject:@"png"]];
    NSArray *urls = [dialog showModal];
    if (urls && [urls count] > 0) {
        NSString *path = [[urls objectAtIndex:0] path];
        if ([path pathExtension].length == 0) {
            path = [path stringByAppendingPathExtension:@"png"];
        }
        NSError *err = nil;
        if ([_capture saveImage:_currentImage asPNGToPath:path error:&err]) {
            /* success */
        } else {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:@"Could not save file"];
            [alert setInformativeText:[err localizedDescription] ?: @"Unknown error"];
            [alert runModal];
            [alert release];
        }
    }
}

@end
