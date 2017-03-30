//
//  MTEIpadGroupTableViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/25/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEBetStore.h"
#import "MTEGroup.h"
#import "MTEEvent.h"
#import "MTEIpadBettingViewController.h"
#import "MTEIpadGroupMatchesTableViewController.h"

@interface MTEIpadGroupTableViewController : UITableViewController <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) MTEEvent *event;
@property (nonatomic, strong) MTEGroup *selectedGroup;
@property (nonatomic, strong) NSMutableArray *teams;
@property (nonatomic, strong) MTEIpadBettingViewController *ibvc;
@property (nonatomic, strong) MTEIpadGroupMatchesTableViewController *igmvc;

@end
