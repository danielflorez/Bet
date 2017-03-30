//
//  MTEIpadEventsTableViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/21/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEIpadButtonEventViewController.h"
#import "GADBannerView.h"

@interface MTEIpadEventsTableViewController : UITableViewController <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) NSMutableArray *matches;
@property (nonatomic, strong) NSMutableArray *teams;
@property (nonatomic, strong) MTEIpadButtonEventViewController *bevc;
@property (nonatomic, strong) GADBannerView *bannerView_;

- (void)reloadEvents;
@end
