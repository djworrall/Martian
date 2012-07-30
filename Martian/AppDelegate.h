//
//  AppDelegate.h
//  Alien Blue
//
//  Created by evan schoffstall on 7/28/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainSelectionController.h"
#import "REOutlineView.h"
#import "RedditController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow * window;
@property (assign) IBOutlet MainSelectionController * mainSelectionController;

+ (NSMutableDictionary*)dataPlist;

@end
