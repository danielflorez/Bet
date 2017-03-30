//
//  MTEGroupViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/8/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEBetStore.h"
#import "MTEGroup.h"
#import "MTEEvent.h"
#import "GADBannerView.h"

@interface MTEGroupViewController : UITableViewController <NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) MTEEvent *event;
@property (nonatomic, strong) MTEGroup *selectedGroup;
@property (nonatomic, strong) NSMutableArray *teams;
@property (nonatomic, strong) GADBannerView *bannerView_;

- (void)reloadGroups;
@end
