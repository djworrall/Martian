//
//  AppDelegate.m
//  Martian
//
//  Created by evan schoffstall on 7/28/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize mainSelectionController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    // Okay, so I hate doing operations up on termination, but this will be a temporary thing.
    
    NSMutableDictionary * data = [AppDelegate dataPlist];
    
    if ([[data objectForKey:@"firstLaunch"] isEqualTo:@"YES"])
        [data setObject:@"NO" forKey:@"firstLaunch"];
        
    if ([mainSelectionController data])
        [data setObject:[mainSelectionController data] forKey:@"outlineData"];
    
    NSMutableArray * expandedItems = [NSMutableArray new];
    
    for (id item in [mainSelectionController data])
    {
        if ([[mainSelectionController mainSelectionOutline] isItemExpanded:item])
            [expandedItems addObject:[[item allKeys] objectAtIndex:0]];
    }
    
    [data setObject:expandedItems forKey:@"expandedItems"];
    
    [data writeToFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Data.plist"] atomically:YES];
}

+ (NSMutableDictionary*)dataPlist
{
    return [NSMutableDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Data.plist"]];
}

@end
