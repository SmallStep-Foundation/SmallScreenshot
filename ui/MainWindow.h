//
//  MainWindow.h
//  SmallScreenshot
//
//  Main window: preview area, Capture full/region, Save.
//

#import <AppKit/AppKit.h>

#if defined(GNUSTEP)
#  define SS_ASSUME_NONNULL_BEGIN
#  define SS_ASSUME_NONNULL_END
#else
#  define SS_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#  define SS_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
#endif

@class AppDelegate;
@class ScreenCapture;
@class CaptureOverlayWindow;

SS_ASSUME_NONNULL_BEGIN

@interface MainWindow : NSWindow {
    AppDelegate *_appDelegate;
    NSButton *_captureFullButton;
    NSButton *_captureRegionButton;
    NSButton *_saveButton;
    NSImageView *_imageView;
    NSScrollView *_scrollView;
    NSImage *_currentImage;
    ScreenCapture *_capture;
    CaptureOverlayWindow *_overlayWindow;
}

@property (nonatomic, assign) AppDelegate *appDelegate;
@property (nonatomic, retain) NSImage *currentImage;

- (id)initWithAppDelegate:(AppDelegate *)appDelegate;

- (void)captureFullScreen;
- (void)startRegionCapture;
- (void)regionCaptureDidFinishWithRect:(NSRect)rect;
- (void)saveScreenshot;

@end

SS_ASSUME_NONNULL_END
