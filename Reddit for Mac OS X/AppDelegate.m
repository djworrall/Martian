//
//  AppDelegate.m
//  Alien Blue
//
//  Created by evan schoffstall on 7/28/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize outlineDelegate;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[outlineDelegate aOutlineView] expandItem:@"Subscriptions"];
    [[outlineDelegate aOutlineView] reloadData];
}

@end
