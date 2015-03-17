//
//  WineCfgViewController.m
//  Vindo
//
//  Created by Theodore Dubois on 3/4/15.
//  Copyright (c) 2015 Theodore Dubois. All rights reserved.
//

#import "WineCfgViewController.h"
#import "PrefixesController.h"

@implementation WineCfgViewController

- (instancetype)init {
    return [super initWithNibName:@"WineCfgPreferences" bundle:nil];
}

- (IBAction)runWinecfg:(id)sender {
    [[PrefixesController defaultPrefix] run:@"winecfg"];
}

- (NSString *)identifier {
    return self.className;
}

- (NSString *)toolbarItemLabel {
    return @"WineCfg";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:@"winecfg"];
}

@end