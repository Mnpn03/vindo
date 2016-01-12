//
//  Popup.m
//  Vindo
//
//  Created by Dubois, Theodore Alexander on 11/17/15.
//  Copyright © 2015 Theodore Dubois. All rights reserved.
//

#import "PopupViewController.h"
#import "FirstTimeSetupController.h"
#import "SetupViewController.h"
#import "StartMenuViewController.h"

@interface PopupViewController ()

@property BOOL firstTimeSetupHappening;

@property StartMenuViewController *defaultViewController;
@property SetupViewController *setupViewController;

@property (nonatomic) NSViewController *importantViewController;
@property IBOutlet NSView *placeholderView;
@property IBOutlet NSPopUpButton *actionButton;

@property (weak) IBOutlet NSMenu *popupMenu;
@property (weak) IBOutlet NSMenu *runMenu;
@property (weak) IBOutlet NSMenu *worldsMenu;

@end

@implementation PopupViewController

- (instancetype)init {
    return [super initWithNibName:@"Popup" bundle:nil];
}

- (void)awakeFromNib {
    self.defaultViewController = [StartMenuViewController new];
    self.setupViewController = [SetupViewController new];

    [self findMathConstants];
    
    if ([FirstTimeSetupController sharedInstance].happening) {
        self.importantViewController = self.setupViewController;
    } else {
        self.importantViewController = self.defaultViewController;
    }

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(firstTimeSetupStarted:)
                   name:FirstTimeSetupDidStartNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(firstTimeSetupEnded:)
                   name:FirstTimeSetupDidCompleteNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(menuItemWasClicked:)
                   name:NSMenuDidSendActionNotification
                 object:self.popupMenu];
    [center addObserver:self
               selector:@selector(menuItemWasClicked:)
                   name:NSMenuDidSendActionNotification
                 object:self.runMenu];
    [center addObserver:self
               selector:@selector(menuItemWasClicked:)
                   name:NSMenuDidSendActionNotification
                 object:self.worldsMenu];
}

- (void)firstTimeSetupStarted:(NSNotification *)notification {
    [self performSelectorOnMainThread:@selector(setImportantViewController:)
                           withObject:self.setupViewController
                        waitUntilDone:NO];
}

- (void)firstTimeSetupEnded:(NSNotification *)notification {
    [self performSelectorOnMainThread:@selector(setImportantViewController:)
                           withObject:self.defaultViewController
                        waitUntilDone:NO];
}

- (void)menuItemWasClicked:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EliminatePopup" object:self];
}

- (void)setImportantViewController:(NSViewController *)importantViewController {
    NSView *oldView;
    if (!_importantViewController)
        oldView = self.placeholderView;
    else
        oldView = _importantViewController.view;
    [self.view replaceSubview:oldView with:importantViewController.view];
    _importantViewController = importantViewController;
    [self doTheMath];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSViewBoundsDidChangeNotification
                                                  object:oldView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(importantViewResized:)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:importantViewController.view];
}

- (void)importantViewResized:(NSNotification *)notification {
    [self doTheMath];
}

static CGFloat bottomPadding;
static CGFloat actionY;
static CGFloat actionRightPadding;

- (void)findMathConstants {
    bottomPadding = self.placeholderView.frame.origin.y;
    actionY = self.actionButton.frame.origin.y;
    actionRightPadding = self.view.frame.size.width - self.actionButton.frame.origin.x;
}

- (void)doTheMath {
    NSSize popupSize;
    popupSize.width = self.importantViewController.view.frame.size.width;
    popupSize.height = self.importantViewController.view.frame.size.height + bottomPadding;
    NSRect popupFrame = self.view.frame;
    popupFrame.size = popupSize;
    self.view.frame = popupFrame;

    NSRect actionFrame;
    actionFrame.size = self.actionButton.frame.size;
    actionFrame.origin.y = actionY;
    actionFrame.origin.x = self.view.frame.size.width - actionRightPadding;
    self.actionButton.frame = actionFrame;

    NSRect importantRect;
    importantRect.size = self.importantViewController.view.frame.size;
    importantRect.origin.x = 0;
    importantRect.origin.y = bottomPadding;
    self.importantViewController.view.frame = importantRect;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReshowPopup" object:self];
}

@end
