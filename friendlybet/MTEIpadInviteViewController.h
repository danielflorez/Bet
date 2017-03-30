//
//  MTEIpadInviteViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/21/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEEvent.h"
#import <FacebookSDK/FacebookSDK.h>
#import "GADBannerView.h"

@interface MTEIpadInviteViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate,NSURLConnectionDataDelegate,FBFriendPickerDelegate>
@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, strong) MTEEvent *selectedEvent;
@property (nonatomic, strong) NSMutableArray *emails;
@property (nonatomic, strong) NSMutableArray *facebookmMembers;
@property (nonatomic, strong) GADBannerView *bannerView_;

@end
