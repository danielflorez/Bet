//
//  MTEIpadEventPositionsTableViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/28/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEMember.h"
#import "MTEEvent.h"
#import "GADBannerView.h"

@interface MTEIpadEventPositionsTableViewController : UITableViewController <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSMutableArray *members;
@property (nonatomic, strong) MTEEvent *event;
@property (nonatomic, strong) GADBannerView *bannerView_;

@end
