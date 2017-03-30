//
//  MTEIpadGroupMatchesFinalTableViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 5/6/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEMatch.h"
#import "MTEEvent.h"
#import "MTEIpadBettingViewController.h"
#import "GADBannerView.h"
#import <FacebookSDK/FacebookSDK.h>

@interface MTEIpadGroupMatchesFinalTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *matches;
@property (nonatomic, strong) MTEEvent *event;
@property (nonatomic, strong) NSMutableArray *bets;
@property (nonatomic, strong) MTEIpadBettingViewController *ipvc;
@property (nonatomic, strong) NSMutableArray *teams;
@property (nonatomic, strong) GADBannerView *bannerView_;

- (void)reloadBets;

@end
