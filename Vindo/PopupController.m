//
//  PopupController.m
//  Vindo
//
//  Created by Dubois, Theodore Alexander on 11/17/15.
//  Copyright © 2015 Theodore Dubois. All rights reserved.
//

#import "PopupController.h"
#import "StatusBarView.h"

@implementation PopupController

- (void)awakeFromNib {
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    self.statusItem = [statusBar statusItemWithLength:NSSquareStatusItemLength];
    self.statusItem.highlightMode = YES;

    NSImage *statusBarImage = [NSImage imageNamed:@"statusbar"];
    statusBarImage.template = YES;
    
    StatusBarView *statusBarView = [[StatusBarView alloc] initWithImage:statusBarImage statusItem:self.statusItem];
    
    statusBarView.target = self;
    statusBarView.action = @selector(togglePopover:);

    self.statusItem.view = statusBarView;
    
    self.popover = [[RBLPopover alloc] initWithContentViewController:self.popupViewController];
    self.popover.behavior = RBLPopoverBehaviorSemiTransient;
    
    self.popover.willShowBlock = ^(RBLPopover *_) {
        statusBarView.highlighted = YES;
    };
    self.popover.didCloseBlock = ^(RBLPopover *_) {
        statusBarView.highlighted = NO;
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reshowPopup:)
                                                 name:@"ReshowPopup"
                                               object:nil];
}

- (void)togglePopover:(id)sender {
    if (self.popover.shown)
        [self hidePopover];
    else
        [self showPopover];
}

- (void)showPopover {
    [self.popover showRelativeToRect:self.statusItem.view.bounds
                              ofView:self.statusItem.view
                       preferredEdge:NSMaxYEdge];
    self.popover.behavior = RBLPopoverBehaviorTransient;
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)hidePopover {
    [self.popover performClose:self];
}

- (void)reshowPopup:(NSNotification *)notification {
    self.popover.contentSize = self.popupViewController.view.frame.size;
    
    NSDisableScreenUpdates();
    self.popover.animates = NO;
    [self hidePopover];
    [self showPopover];
    self.popover.animates = YES;
    
    NSEnableScreenUpdates();
}

@end
