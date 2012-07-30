//
//  RedditController.m
//  Martian
//
//  Created by evan schoffstall on 7/30/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "RedditController.h"

@implementation RedditController
@synthesize requests, requestTimer;

- (id)init
{
    if (self == [super self])
    {
        // We need to conform to Reddit's standards
        requestTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(resetRequests:) userInfo:nil repeats:YES];
        [requestTimer fire];
    }
    return self;
}

- (void)willDisplayViewForItem:(NSString*)item
{
    // Conforming to reddit's standards
    if (requests >= 1)
    {
        NSLog(@"Sorry, but you need to keep requests down to one per two seconds");
        return;
    }
    
    NSArray * nonSubreddits = [NSArray arrayWithObjects:@"Messages",@"Front page",@"Subscriptions",nil];
    
    if (![nonSubreddits containsObject:item])
    {
        // We can assume that the section in question are subreddits.
    }
    else if ([item isEqualToString:@"Front page"])
    {
        NSMutableDictionary * redditFrontPage = [self dictionaryFromRequest:@"http://api.reddit.com/"];
        
        for (NSDictionary * post in [[redditFrontPage objectForKey:@"data"] objectForKey:@"children"])
        {
            NSDictionary * postData = [post objectForKey:@"data"];
            NSLog(@"Title: %@",[postData objectForKey:@"title"]);
            NSLog(@"Author: %@",[postData objectForKey:@"author"]);
            NSLog(@"Link: %@/n",[postData objectForKey:@"url"]);
        }
        
        //NSLog(@"%@",[[[[redditFrontPage objectForKey:@"data"] objectForKey:@"children"] objectAtIndex:0] objectForKey:@"data"]);
    }
    
    ++requests;
}

- (void)resetRequests:(NSTimer*)timer
{
    requests = 0;
}

- (NSMutableDictionary*)dictionaryFromRequest:(NSString*)requestString
{
    // Create new SBJSON parser object
    SBJsonParser *parser = [SBJsonParser new];
    
    // Prepare URL request to download from
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    
    //Conform to reddit's standards
    [request setValue:@"(JSON) Martian Reddit Client by anleaves" forHTTPHeaderField:@"User-Agent"];
    
    // Perform request and get JSON back as a NSData object
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Get JSON as a NSString from NSData response
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    // parse the JSON response into an object
    // Here we're using NSArray since we're parsing an array of JSON objects
    return [parser objectWithString:json_string error:nil];
}

@end
