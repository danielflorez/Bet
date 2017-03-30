//
//  MTEEvent.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/6/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEEvent.h"

@implementation MTEEvent
- (id)init
{
    self = [super init];
    if (self) {
        _matches = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
