//
//  CaptureOverlayWindow.h
//  SmallScreenshot
//
//  Fullscreen overlay for region selection: user drags a rectangle.
//

#import <AppKit/AppKit.h>

#if defined(GNUSTEP)
#  define SS_ASSUME_NONNULL_BEGIN
#  define SS_ASSUME_NONNULL_END
#else
#  define SS_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#  define SS_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
#endif

@class MainWindow;

SS_ASSUME_NONNULL_BEGIN

@interface CaptureOverlayWindow : NSWindow {
    MainWindow *_mainWindow;
    NSRect _selectionRect;
}

@property (nonatomic, assign) MainWindow *mainWindow;

- (id)initWithMainWindow:(MainWindow *)mainWindow;
- (void)showOverlay;

@end

SS_ASSUME_NONNULL_END
