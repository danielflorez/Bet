//
//  MTEMember.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/20/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTEMember : NSObject
@property (nonatomic, strong) NSString  *memberID;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *email;
@property (nonatomic, strong) NSString  *exactScore;
@property (nonatomic, strong) NSString  *teamScore;
@property (nonatomic, strong) NSString  *winner;
@property (nonatomic, strong) NSString  *pointsActualEvent;
@property (nonatomic, strong) NSString  *facebook_id;

@end
