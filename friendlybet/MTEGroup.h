//
//  MTEGroup.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/6/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTEGroup : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *groupid;
@property (nonatomic, strong) NSMutableArray *teams;

@end
