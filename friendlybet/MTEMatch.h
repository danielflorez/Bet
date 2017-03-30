//
//  MTEMatch.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 3/25/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTETeam.h"

@interface MTEMatch : NSObject
@property (nonatomic, strong) NSString *matchID;
@property (nonatomic, strong) NSString *roundID;
@property (nonatomic, strong) NSString *order;
@property (nonatomic, strong) MTETeam *team1;
@property (nonatomic, strong) MTETeam *team2;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *score1;
@property (nonatomic, strong) NSString *score2;
@property (nonatomic, strong) NSString *started;

@end
