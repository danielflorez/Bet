//
//  MTEIpadAcceptInvitesViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/22/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEInvite.h"
#import "MTEIpadMyInvitesTableViewController.h"

@interface MTEIpadAcceptInvitesViewController : UIViewController <NSURLConnectionDataDelegate>
@property (nonatomic, strong) MTEIpadMyInvitesTableViewController *mivc;
@property (nonatomic,strong) MTEInvite *invite;

@end
