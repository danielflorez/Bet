//
//  MTEAcceptInvitesViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/19/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEMyInvitesTableViewController.h"
#import "MTEInvite.h"

@interface MTEAcceptInvitesViewController : UIViewController <NSURLConnectionDataDelegate>
@property (nonatomic, strong) MTEMyInvitesTableViewController *mivc;
@property (nonatomic,strong) MTEInvite *invite;

@end
