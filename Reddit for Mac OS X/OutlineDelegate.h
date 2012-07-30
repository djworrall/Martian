//
//  outlineDelegate.h
//  Alien Blue
//
//  Created by evan schoffstall on 7/28/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutlineDelegate : NSObject <NSOutlineViewDelegate, NSOutlineViewDataSource>
{
@private
    NSTableCellView * rowToRemove;
}

@property (strong) NSMutableArray * data;
@property (strong) NSMutableArray * subscriptions;
@property (assign) IBOutlet NSOutlineView * aOutlineView;

- (NSTableCellView*)rowForIndex:(NSInteger)index;

- (void)textDidEndEditing:(NSNotification *)notification;

- (NSMenu*)defaultMenuForRow:(NSString*)stringRow;
- (void)addSubreddit:(id)sender;
- (void)removeSubreddit:(id)sender;

@end