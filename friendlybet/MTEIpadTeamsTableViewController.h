//
//  MTEIpadTeamsTableViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/26/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEGroup.h"
#import "MTETeam.h"
#import "MTEEvent.h"

@interface MTEIpadTeamsTableViewController : UITableViewController <NSURLConnectionDataDelegate>
@property (nonatomic, strong) MTEGroup *selectedGroup;
@property (nonatomic, strong) NSMutableArray *selectedTeams;
@property (nonatomic, strong) MTEEvent *event;
@property (nonatomic, strong) NSMutableArray *bets;

- (void)rlData;

@end
