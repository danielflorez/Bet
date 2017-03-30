//
//  MTEIpadButtonEventViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 5/5/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEEvent.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MTEIpadLoginViewController.h"
#import "GADInterstitial.h"

@interface MTEIpadButtonEventViewController : UIViewController
@property (nonatomic, strong) NSString *email;
@property (nonatomic) BOOL canInvite;
@property (nonatomic, strong) UIBarButtonItem *bbi;
@property (nonatomic, strong) FBLoginView *loginView;
@property (nonatomic) BOOL facebookLogin;
@property (nonatomic, strong) NSString *fbname;
@property (nonatomic, strong) NSMutableArray *invites;
@property (nonatomic, strong) MTEIpadLoginViewController *lvc;
@property (nonatomic, strong) GADInterstitial *interstitial_;

- (void)selectEvent:(MTEEvent *) event;

@end
