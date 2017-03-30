//
//  MTETeam.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 3/25/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTETeam : NSObject
@property (nonatomic, strong) NSString *teamID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *points;
@property (nonatomic, strong) NSString *goalDif;
@property (nonatomic, strong) NSString *gamesPlayed;
@property (nonatomic, strong) NSString *gamesWon;
@property (nonatomic, strong) NSString *gamesLost;
@property (nonatomic, strong) NSString *gamesTied;
@property (nonatomic, strong) NSString *gc;
@property (nonatomic, strong) NSString *gf;

@end
