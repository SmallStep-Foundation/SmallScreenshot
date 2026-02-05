//
//  AppDelegate.h
//  SmallScreenshot
//
//  Application delegate (SSAppDelegate): lifecycle and main menu.
//

#import <Foundation/Foundation.h>
#import "SSAppDelegate.h"

#if defined(GNUSTEP)
#  define SS_ASSUME_NONNULL_BEGIN
#  define SS_ASSUME_NONNULL_END
#else
#  define SS_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#  define SS_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
#endif

@class MainWindow;

SS_ASSUME_NONNULL_BEGIN

@interface AppDelegate : NSObject <SSAppDelegate> {
    MainWindow *_mainWindow;
}
@property (nonatomic, retain) MainWindow *mainWindow;

- (void)captureFullScreen:(id)sender;
- (void)captureRegion:(id)sender;
- (void)saveScreenshot:(id)sender;

@end

SS_ASSUME_NONNULL_END
