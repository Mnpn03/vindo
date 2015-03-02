

//
//  AppDelegate.h
//  Vindo
//
//  Created by Theodore Dubois on 2/27/15.
//  Copyright (c) 2015 Theodore Dubois. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSStatusItem *statusItem;
    NSWindowController *preferencesController;
}

@property (assign) IBOutlet NSMenu *statusBarMenu;

- (IBAction)showPreferences:(id)sender;
- (IBAction)doNothing: (id)sender;

@end

