//
//  MTETeamsTableViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/8/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEGroup.h"
#import "MTETeam.h"
#import "MTEEvent.h"
#import "GADBannerView.h"

@interface MTETeamsTableViewController : UITableViewController <NSURLConnectionDataDelegate>
@property (nonatomic, strong) MTEGroup *selectedGroup;
@property (nonatomic, strong) NSMutableArray *selectedTeams;
@property (nonatomic, strong) MTEEvent *event;
@property (nonatomic, strong) NSMutableArray *bets;
@property (nonatomic, strong) GADBannerView *bannerView_;

@end
