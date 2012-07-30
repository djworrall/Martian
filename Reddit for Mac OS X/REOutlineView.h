//
//  REOutlineView.h
//  Reddit
//
//  Created by evan schoffstall on 7/28/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface REOutlineView : NSOutlineView

- (NSMenu*)defaultMenuForRow:(int)row;

@end
