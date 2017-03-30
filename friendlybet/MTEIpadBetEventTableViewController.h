//
//  MTEIpadBetEventTableViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/25/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEEvent.h"
#import "MTEIpadGroupTableViewController.h"
#import "GADBannerView.h"

@interface MTEIpadBetEventTableViewController : UITableViewController <NSURLConnectionDataDelegate>
@property (nonatomic, strong) MTEEvent *event;
@property (nonatomic, strong) NSMutableArray *matches;
@property (nonatomic, strong) NSMutableArray *teams;
@property (nonatomic, strong) GADBannerView *bannerView_;

@end
