//
//  MTEGroupMatchesTableViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/9/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEMatch.h"
#import "MTEEvent.h"
#import <FacebookSDK/FacebookSDK.h>
#import "GADBannerView.h"

@interface MTEGroupMatchesTableViewController : UITableViewController <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSMutableArray *matches;
@property (nonatomic, strong) MTEEvent *event;
@property (nonatomic, strong) NSMutableArray *bets;
@property (nonatomic, strong) GADBannerView *bannerView_;

- (void)reloadBets;

@end
