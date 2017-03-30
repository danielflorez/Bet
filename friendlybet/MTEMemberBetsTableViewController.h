//
//  MTEMemberBetsTableViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 6/6/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEEvent.h"
#import "GADBannerView.h"
#import "MTEMatch.h"

@interface MTEMemberBetsTableViewController : UITableViewController <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSMutableArray *bets;
@property (nonatomic, strong) MTEEvent *event;
@property (nonatomic, strong) GADBannerView *bannerView_;
@property (nonatomic, strong) MTEMatch *match;

@end
