//
//  MTEBetStore.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/4/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTEMatch.h"
#import "MTEGroup.h"
#import "MTETeam.h"
#import "MTEEvent.h"


@interface MTEBetStore : NSObject <NSURLConnectionDelegate>
@property (nonatomic, strong) NSMutableArray *teams;
@property (nonatomic) BOOL match;
+ (MTEBetStore *)sharedStore;
- (void)loadData;

@end
