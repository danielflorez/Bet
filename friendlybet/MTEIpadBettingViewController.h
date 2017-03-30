//
//  MTEIpadBettingViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/25/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEEvent.h"
#import "MTEGroup.h"
#import "MTEMatch.h"
#import "GADBannerView.h"

@interface MTEIpadBettingViewController : UIViewController
@property (nonatomic, strong) UITableView *mainview;
@property (nonatomic, strong) UIImageView *iv;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) MTEEvent *event;
@property (nonatomic, strong) MTEGroup *selectedGroup;
@property (nonatomic, strong) GADBannerView *bannerView_;

- (void) reloadTeams;

@end
