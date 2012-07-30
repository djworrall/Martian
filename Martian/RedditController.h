//
//  RedditController.h
//  Martian
//
//  Created by evan schoffstall on 7/30/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SBJson/SBJson.h>

@interface RedditController : NSObject

@property (assign) NSInteger requests;
@property (strong) NSTimer * requestTimer;

- (void)willDisplayViewForItem:(NSString*)item;

@end
