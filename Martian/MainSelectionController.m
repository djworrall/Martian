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
@synthesize data, mainSelectionOutline, subscriptions, redditController;

- (void)awakeFromNib
{
    for (NSString * item in [[AppDelegate dataPlist] objectForKey:@"expandedItems"])
    {
        if ([item isEqualToString:@"Subscriptions"])
            [mainSelectionOutline expandItem:[mainSelectionOutline itemAtRow:2]];
        
        [mainSelectionOutline reloadData];
    }
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
            
            [self setSubscriptions:[NSMutableDictionary dictionaryWithObject:[NSMutableArray arrayWithObjects:@"Technology",@"Science",@"Apple",nil] forKey:@"Subscriptions"]];
            [self setData:[NSMutableArray arrayWithObjects:@"Front page",@"Messages",[NSDictionary dictionaryWithObject:subscriptions forKey:@"Subscriptions"], nil]];
            
            [dataPlist writeToFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Data.plist"] atomically:YES];
        }
        else
        {
            NSMutableDictionary * dataPlist = [AppDelegate dataPlist];
            
            [self setData:[dataPlist objectForKey:@"outlineData"]];
            
            for (int i = 0; i != [[dataPlist objectForKey:@"outlineData"] count]; ++i)
            {
                if ([[[dataPlist objectForKey:@"outlineData"] objectAtIndex:i] isKindOfClass:[NSMutableDictionary class]])
                    [self setSubscriptions:[[dataPlist objectForKey:@"outlineData"] objectAtIndex:i]];
            }
        }
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:@"NSControlTextDidEndEditingNotification" object:nil];
    }
    
    return self;
}

- (NSView*)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSTableCellView * aView = [outlineView makeViewWithIdentifier:[tableColumn identifier] owner:self];
    
    if ([item isKindOfClass:[NSDictionary class]])
        item = [[item allKeys] objectAtIndex:0];
    
    if (item == @"")
        [[aView textField] setSelectable:NO]; // Broken; need a way to set the selectablity of the cell, not just the textField.
        
    [[aView textField] setStringValue:item];
    return aView;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil)
    {
        return [data count];
    }
    else if ([item isKindOfClass:[NSDictionary class]])
    {
        return [[item objectForKey:[[item allKeys] objectAtIndex:0]] count];
    }
    
    return 0;
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

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil)
    {
        return [data objectAtIndex:index];
    }
    else if ([item isKindOfClass:[NSDictionary class]])
    {
        return [[item objectForKey:[[item allKeys] objectAtIndex:0]] objectAtIndex:index];
    }
    
    return nil;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    if (item == @"")
        return NO;
    
    [NSThread detachNewThreadSelector:@selector(willDisplayViewForItem:) toTarget:redditController withObject:item];
    //[redditController willDisplayViewForItem:item];
    
    return YES;
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
    else if ([[subscriptions objectForKey:@"Subscriptions"] containsObject:[[aRow textField] stringValue]])
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
    [[subscriptions objectForKey:@"Subscriptions"] removeObject:[[rowToRemove textField] stringValue]];
    [mainSelectionOutline reloadData];
}

- (void)addSubreddit:(id)sender
{
    NSInteger row = [[subscriptions objectForKey:@"Subscriptions"] count]+[data count];
    
    [[subscriptions objectForKey:@"Subscriptions"] addObject:@"untitled"];
    [mainSelectionOutline reloadData];
    [[[self rowForIndex:row] textField] setEditable:YES];
    [mainSelectionOutline reloadData];
    [self selectRow:row];
    [self editRow:row];
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    NSInteger row = [subscriptions count]+[data count]-1;
    [[[self rowForIndex:row] textField] setEditable:NO];
    [mainSelectionOutline reloadData];
    [self selectRow:row];
}

@end
