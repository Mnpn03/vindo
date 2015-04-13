//
//  BrowserController.m
//  Vindo
//
//  Created by Theodore Dubois on 3/29/15.
//  Copyright (c) 2015 Theodore Dubois. All rights reserved.
//

#import "BrowserController.h"
#import "FileItem.h"
#import "ItemBrowserCell.h"

static NSMutableArray *browsers;

@interface BrowserController ()

@property IBOutlet NSTabView *tabView;
@property IBOutlet NSBrowser *browser;

@end

@implementation BrowserController

- (id)init {
    if (self = [super initWithWindowNibName:@"Browser"]) {
        [browsers addObject:self]; // to have a strong reference
        self.window.delegate = self;
        self.rootItem = [[FileItem alloc] initWithURL:[NSURL fileURLWithPath:NSHomeDirectory()]];
    }
    return self;
}

- (void)awakeFromNib {
    self.browser.cellClass = [ItemBrowserCell class];
    self.browser.columnResizingType = NSBrowserUserColumnResizing;
}

- (IBAction)switchView:(NSSegmentedControl *)sender {
    [self.tabView selectTabViewItemAtIndex:sender.selectedSegment];
}

- (void)windowWillClose:(NSNotification *)notification {
    [browsers removeObject:self]; // get rid of the strong reference
}

+ (void)initialize {
    browsers = [NSMutableArray new];
}

@end