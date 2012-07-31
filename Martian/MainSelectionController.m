//
//  mainSelectionController.m
//  Martian
//
//  Created by evan schoffstall on 7/28/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "MainSelectionController.h"
#import "AppDelegate.h"

@implementation MainSelectionController
@synthesize data, mainSelectionOutline, redditController, treeController;

- (void)awakeFromNib
{
    
}

- (id)init
{
    if (self == [super self])
    {
        redditController = [RedditController new];
        
        if (![[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"])
        {
            NSMutableDictionary * dataPlist = [NSMutableDictionary new];
            
            [dataPlist setObject:@"YES" forKey:@"firstLaunch"];
            
            [self setData:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableArray arrayWithObjects:@"Front page",@"Messages",nil],@"Dashboard",[NSMutableArray arrayWithObjects:@"Technology",@"Science",@"Apple",nil],@"Subscriptions",nil]];
            
            [dataPlist writeToFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Data.plist"] atomically:YES];
        }
        else
        {
            NSMutableDictionary * dataPlist = [AppDelegate dataPlist];
            
            [self setData:[dataPlist objectForKey:@"outlineData"]];
        }
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:@"NSControlTextDidEndEditingNotification" object:nil];
    }
    
    return self;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (!item)
    {
        // Root node, so we return the key for which index it requires
        return [[[data allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:index];
    }
    else
    {
        return [[data objectForKey:item] objectAtIndex:index];
    }
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (!item)
    {
        // Root node
        return [[data allKeys] count];
    }
    else
    {
        if ([item isKindOfClass:[NSArray class]])
            return [item count];
        else
            return [[data objectForKey:item] count];
    }
}

- (NSView*)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    if (item == @"")
    {
        NSTableCellView * aView = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
        [[aView textField] setSelectable:NO]; // Broken; need a way to set the selectablity of the cell, not just the textField.
        [[aView textField] setStringValue:item];
        
        return aView;
    }
    
    if ([[data objectForKey:item] isKindOfClass:[NSArray class]])
    {
        // Then we are dealing with headers, e.g Subscription or Main.
        NSTableCellView * aView = [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
        [[aView textField] setStringValue:item];
        return aView;

    }
    
    if ([item isKindOfClass:[NSString class]])
    {
        NSTableCellView * aView = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
        [[aView textField] setStringValue:item];
        return aView;
    }
    
    return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    return [self outlineView:outlineView isItemExpandable:item];
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
    else if ([[self subscriptions] containsObject:[[aRow textField] stringValue]])
    {
        [self selectRow:row];
        
        [theMenu insertItemWithTitle:@"Remove" action:@selector(removeSubreddit:) keyEquivalent:@"" atIndex:0];
        
        rowToRemove = aRow;
    }
    
    return theMenu;
}

- (NSTableCellView*)rowForIndex:(NSInteger)index
{
    return [[[[mainSelectionOutline outlineTableColumn] tableView] rowViewAtRow:index makeIfNecessary:YES] viewAtColumn:0];
}

- (void)selectRow:(NSInteger)row
{
    [mainSelectionOutline selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
}

- (void)editRow:(NSInteger)row
{
    [mainSelectionOutline editColumn:0 row:row withEvent:[NSApp currentEvent] select:YES];
}

- (void)removeSubreddit:(id)sender
{
    [[self subscriptions] removeObject:[[rowToRemove textField] stringValue]];
    [mainSelectionOutline reloadData];
}

- (void)addSubreddit:(id)sender
{
    NSInteger row = [[self subscriptions] count]+[data count];
    
    [[self subscriptions] addObject:@"untitled"];
    [mainSelectionOutline reloadData];
    [[[self rowForIndex:row] textField] setEditable:YES];
    [mainSelectionOutline reloadData];
    [self selectRow:row];
    [self editRow:row];
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    NSInteger row = [[self subscriptions] count]+[data count]-1;
    [[[self rowForIndex:row] textField] setEditable:NO];
    [mainSelectionOutline reloadData];
    [self selectRow:row];
}

- (NSMutableArray*)subscriptions
{
    return [data objectForKey:@"Subscriptions"];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([self outlineView:outlineView numberOfChildrenOfItem:item] > 0)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    return YES;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    NSArray * execptions = [NSArray arrayWithObjects:@"Main",@"Subscriptions",@"",nil];
    
    if ([execptions containsObject:item])
        return NO;
    
    [NSThread detachNewThreadSelector:@selector(willDisplayViewForItem:) toTarget:redditController withObject:item];
    
    return YES;
}

- (void)outlineView:(NSOutlineView *)outlineView mouseDownInHeaderOfTableColumn:(NSTableColumn *)tableColumn
{
    return;
}


@end
