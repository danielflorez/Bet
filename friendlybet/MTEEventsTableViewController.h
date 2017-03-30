//
//  MTEEventsTableViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/8/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEBetStore.h"
#import "MTEEvent.h"
#import "MTEButtonEventViewController.h"
#import "GADBannerView.h"

@interface MTEEventsTableViewController : UITableViewController <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) NSMutableArray *matches;
@property (nonatomic, strong) NSMutableArray *teams;
@property (nonatomic, strong) MTEButtonEventViewController *bevc;
@property (nonatomic, strong) GADBannerView *bannerView_;


- (void)reloadEvents;

@end
