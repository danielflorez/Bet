//
//  MTEBetStore.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/4/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEBetStore.h"
@import JavaScriptCore;

@implementation MTEBetStore

+ (MTEBetStore *)sharedStore
{
    static MTEBetStore *feedStore = nil;
    if (!feedStore) {
        feedStore = [[MTEBetStore alloc] init];
    }
    return feedStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadData
{
    if (!_teams) {
        _teams = [[NSMutableArray alloc] init];
    }
    [self fetchTeams];
}

- (void)fetchTeams
{
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *dataPath;
    if([language isEqualToString:@"en"])
    {
        dataPath = [[NSBundle mainBundle] pathForResource:@"teamsjson_en" ofType:@"txt"];
    }
    else {
        dataPath = [[NSBundle mainBundle] pathForResource:@"teamsjson" ofType:@"txt"];
    }
    NSData *d = [NSData dataWithContentsOfFile:dataPath];
    NSDictionary *teams= [NSJSONSerialization JSONObjectWithData:d
                                                         options:0
                                                           error:nil];
    for (NSDictionary *team in [teams objectForKey:@"Teams"])
    {
        MTETeam *t = [[MTETeam alloc] init];
        t.name = team[@"Name"];
        t.flag = team[@"Image"];
        t.teamID = team[@"Id"];
        [self.teams addObject:t];
    }
}
@end