//
//  MTEEvent.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/6/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTEEvent : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *eventID;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) NSString *teamID;
@property (nonatomic, strong) NSString *firstPrize;
@property (nonatomic, strong) NSString *secondPrize;
@property (nonatomic, strong) NSString *thirdPrize;
@property (nonatomic, strong) NSString *eventTotalPrize;
@property (nonatomic, strong) NSString *entryFee;
@property (nonatomic, strong) NSMutableArray *matches;
@property (nonatomic) BOOL groupphase;
@property (nonatomic) BOOL roundsixteen;
@property (nonatomic) BOOL quarter;
@property (nonatomic) BOOL semifinal;
@property (nonatomic) BOOL final;
@property (nonatomic) BOOL pointsXQualified;
@property (nonatomic) BOOL facebookLogin;
@property (nonatomic, strong) NSString *fbname;

@end