//
//  AppDelegate.h
//  Alien Blue
//
//  Created by evan schoffstall on 7/28/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OutlineDelegate.h"
#import "REOutlineView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow * window;
@property (assign) IBOutlet OutlineDelegate * outlineDelegate;

@end
