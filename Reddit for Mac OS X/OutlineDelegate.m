//
//  outlineDelegate.m
//  Alien Blue
//
//  Created by evan schoffstall on 7/28/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "OutlineDelegate.h"

@implementation OutlineDelegate
@synthesize data, aOutlineView;

- (id)init
{
    if (self == [super self])
    {
        NSMutableArray * subreddits = [NSMutableArray arrayWithObjects:@"Technology",@"Science",@"Apple",nil];
        
        data = [NSMutableDictionary new];
        
        [data setValue:@"" forKey:@"Front page"];
        [data setValue:@"" forKey:@"Messages"];
        [data setValue:subreddits forKey:@"Subscriptions"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:@"NSControlTextDidEndEditingNotification" object:nil];
        
        [aOutlineView reloadData];
        [aOutlineView expandItem:@"Subscriptions"];
        [aOutlineView reloadData];
    }
    
    return self;
}

- (NSView*)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSTableCellView * aView = [outlineView makeViewWithIdentifier:[tableColumn identifier] owner:self];
    [[aView textField] setStringValue:item];
    
    /*
    if ([[data objectForKey:@"Subscriptions"] containsObject:item])
    {
        [[aView textField] setEditable:YES];
    }
    */
    
    return aView;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil)
    {
        return [[data allKeys] count];
    }
    else if ([[data objectForKey:item] respondsToSelector:@selector(count)])
    {
        return [[data objectForKey:item] count];
    }
    else
    {
        return 0;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([self outlineView:outlineView numberOfChildrenOfItem:item] > 0)
    {
        return YES;
    }
    else
    {
        
        return NO;
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    return YES;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil)
    {
        return [[data allKeys] objectAtIndex:index];
    }
    else if ([[data objectForKey:item] respondsToSelector:@selector(count)])
    {
        return [[data objectForKey:item] objectAtIndex:index];
    }
    else
    {
        return nil;
    }
}

- (NSMenu*)defaultMenuForRow:(NSString*)stringRow
{
    int row = [stringRow intValue];
    
    if (row < 0) return nil;
    
    NSTableCellView * aRow = [self rowForIndex:row];
    
    NSMenu *theMenu = [NSMenu new];
    
    if ([[[aRow textField] stringValue] isEqualToString:@"Subscriptions"])
    {
        [self selectRow:row];
        
        [theMenu insertItemWithTitle:@"Add" action:@selector(addSubreddit:) keyEquivalent:@"" atIndex:0];
        
        return theMenu;
    }
    else if ([[data objectForKey:@"Subscriptions"] containsObject:[[aRow textField] stringValue]])
    {
        [self selectRow:row];
        
        [theMenu insertItemWithTitle:@"Remove" action:@selector(removeSubreddit:) keyEquivalent:@"" atIndex:0];
        
        rowToRemove = aRow;
    }
    
    return theMenu;
}

- (NSTableCellView*)rowForIndex:(NSInteger)index
{
    return [[[[aOutlineView outlineTableColumn] tableView] rowViewAtRow:index makeIfNecessary:YES] viewAtColumn:0];
}

- (void)selectRow:(NSInteger)row
{
    [aOutlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
}

- (void)editRow:(NSInteger)row
{
    [aOutlineView editColumn:0 row:row withEvent:[NSApp currentEvent] select:YES];
}

- (void)removeSubreddit:(id)sender
{
    [[data objectForKey:@"Subscriptions"] removeObject:[[rowToRemove textField] stringValue]];
    [aOutlineView reloadData];
}

- (void)addSubreddit:(id)sender
{
    NSInteger row = [[data objectForKey:@"Subscriptions"] count]+[[data allKeys] count];
    
    [[data objectForKey:@"Subscriptions"] addObject:@"untitled"];
    [aOutlineView reloadData];
    [[[self rowForIndex:row] textField] setEditable:YES];
    [aOutlineView reloadData];
    [self selectRow:row];
    [self editRow:row];
    
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    NSInteger row = [[data objectForKey:@"Subscriptions"] count]+[[data allKeys] count]-1;
    [[[self rowForIndex:row] textField] setEditable:NO];
    [aOutlineView reloadData];
    [self selectRow:row];
}

@end
