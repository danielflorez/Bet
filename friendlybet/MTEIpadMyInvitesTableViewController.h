//
//  MTEIpadMyInvitesTableViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/21/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEIpadEventsTableViewController.h"
#import "GADBannerView.h"

@interface MTEIpadMyInvitesTableViewController : UITableViewController <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSMutableArray *invites;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) MTEIpadEventsTableViewController *etvc;
@property (nonatomic, strong) GADBannerView *bannerView_;

- (void)reloadInvites;
@end
