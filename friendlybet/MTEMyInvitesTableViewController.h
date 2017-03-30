//
//  MTEMyInvitesTableViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/17/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEEventsTableViewController.h"
#import "GADBannerView.h"

@interface MTEMyInvitesTableViewController : UITableViewController<NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSMutableArray *invites;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) MTEEventsTableViewController *etvc;
@property (nonatomic, strong) GADBannerView *bannerView_;

- (void)reloadInvites;

@end
