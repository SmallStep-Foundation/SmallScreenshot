//
//  AppDelegate.m
//  SmallScreenshot
//

#import "AppDelegate.h"
#import "MainWindow.h"
#import "SmallStep.h"
#import "SSMainMenu.h"
#import "SSHostApplication.h"

#if !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#endif

@implementation AppDelegate

@synthesize mainWindow = _mainWindow;

- (void)applicationWillFinishLaunching {
    [self buildMenu];
}

- (void)applicationDidFinishLaunching {
    self.mainWindow = [[MainWindow alloc] initWithAppDelegate:self];
    [self.mainWindow makeKeyAndOrderFront:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(id)sender {
    (void)sender;
    return YES;
}

- (void)buildMenu {
#if !TARGET_OS_IPHONE
    SSMainMenu *menuBuilder = [[SSMainMenu alloc] init];
    menuBuilder.appName = @"SmallScreenshot";
    menuBuilder.aboutAppName = @"SmallScreenshot";
    menuBuilder.aboutVersion = @"1.0";
    menuBuilder.aboutTarget = self;
    NSArray *items = [NSArray arrayWithObjects:
        [SSMainMenuItem itemWithTitle:@"Capture Full Screen" action:@selector(captureFullScreen:) keyEquivalent:@"1" modifierMask:NSCommandKeyMask target:self],
        [SSMainMenuItem itemWithTitle:@"Capture Region…" action:@selector(captureRegion:) keyEquivalent:@"2" modifierMask:NSCommandKeyMask target:self],
        [SSMainMenuItem itemWithTitle:@"Save Screenshot…" action:@selector(saveScreenshot:) keyEquivalent:@"s" modifierMask:NSCommandKeyMask target:self],
        nil];
    [menuBuilder buildMenuWithItems:items quitTitle:@"Quit SmallScreenshot" quitKeyEquivalent:@"q"];
    [menuBuilder install];
    [menuBuilder release];
#endif
}

- (void)captureFullScreen:(id)sender {
    (void)sender;
    [self.mainWindow captureFullScreen];
}

- (void)captureRegion:(id)sender {
    (void)sender;
    [self.mainWindow startRegionCapture];
}

- (void)saveScreenshot:(id)sender {
    (void)sender;
    [self.mainWindow saveScreenshot];
}

- (void)showAbout:(id)sender {
    (void)sender;
    [SSAboutPanel showWithAppName:@"SmallScreenshot" version:@"1.0"];
}

- (void)dealloc {
    [_mainWindow release];
    [super dealloc];
}

@end
