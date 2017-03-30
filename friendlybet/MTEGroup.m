//
//  MTEGroup.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/6/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEGroup.h"

@implementation MTEGroup
- (id)init
{
    self = [super init];
    if (self) {
        _teams = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
