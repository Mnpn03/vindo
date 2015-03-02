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
}

- (void)dealloc {
    [statusItem release];
    
    [super dealloc];
}

- (IBAction)showPreferences: (id)sender {
    if (preferencesController == nil)
        preferencesController = [[NSWindowController alloc] initWithWindowNibName:@"Preferences"];
    [preferencesController showWindow:self];
}

- (IBAction)doNothing: (id)sender {
    NSAlert *alert = [NSAlert alertWithMessageText:@"That option does nothing" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"That's because this is a non-functioning prototype."];
    [alert runModal];
}

@end
