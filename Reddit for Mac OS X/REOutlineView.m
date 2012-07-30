//
//  REOutlineView.m
//  Reddit
//
//  Created by evan schoffstall on 7/28/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "REOutlineView.h"

@implementation REOutlineView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
}

- (void)addSubreddit:(id)sender
{
    [[self delegate] performSelector:@selector(addSubreddit:) withObject:sender];
}

- (void)removeSubreddit:(id)sender
{
    [[self delegate] performSelector:@selector(removeSubreddit:) withObject:sender];
}

- (NSMenu*)defaultMenuForRow:(int)row
{
    return [[self delegate] performSelector:@selector(defaultMenuForRow:) withObject:[NSString stringWithFormat:@"%i",row]];
}

- (NSMenu*)menuForEvent:(NSEvent *)event
{
    return [self defaultMenuForRow:(int)[self rowAtPoint:[self convertPoint:[event locationInWindow] fromView:nil]]];
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    
}

- (void)controlTextDidEndEditing:(NSNotification *)notification
{
    [[self delegate] performSelector:@selector(textDidEndEditing:) withObject:notification];
}

@end
