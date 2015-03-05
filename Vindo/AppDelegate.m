//
//  AppDelegate.m
//  Vindo
//
//  Created by Theodore Dubois on 2/27/15.
//  Copyright (c) 2015 Theodore Dubois. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize statusBarMenu;

- (void)applicationDidFinishLaunching: (NSNotification *)aNotification {
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    statusItem = [statusBar statusItemWithLength:NSSquareStatusItemLength];
    [statusItem retain];
    statusItem.highlightMode = YES;
    statusItem.image = [NSImage imageNamed:@"Icon16"];
    statusItem.menu = statusBarMenu;
    
    // workaround bug in RHPreferences
    [[NSUserDefaults standardUserDefaults] registerDefaults:
        [NSDictionary dictionaryWithObject:@"GeneralPreferencesViewController"
                                    forKey:@"RHPreferencesWindowControllerSelectedItemIdentifier"]];
    
    [[WineServer new] makeDefaultServer];
}

- (void)dealloc {
    [statusItem release];
    [server release];
    
    [super dealloc];
}

- (IBAction)showPreferences: (id)sender {
    if (prefs == nil) {
        prefs = [[RHPreferencesWindowController alloc] initWithViewControllers:
                                 [NSArray arrayWithObjects:
                                  [RHPreferencesWindowController flexibleSpacePlaceholderController],
                                  [[GeneralPreferencesViewController new] autorelease],
                                  [[WineCfgViewController new] autorelease],
                                  [RHPreferencesWindowController flexibleSpacePlaceholderController],
                                  nil]];
        // workaround for missing behavior in RHPreferences
        prefs.window.collectionBehavior =
            NSWindowCollectionBehaviorMoveToActiveSpace |
            NSWindowCollectionBehaviorFullScreenAuxiliary;
    }
    [prefs showWindow:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)doNothing: (id)sender {
    [[WineServer defaultServer] runExe:@"ignored"];
}

@end
