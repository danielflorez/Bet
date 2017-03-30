//
//  MTEInviteViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/17/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEEvent.h"
#import <FacebookSDK/FacebookSDK.h>

@interface MTEInviteViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate,NSURLConnectionDataDelegate,FBFriendPickerDelegate>
@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, strong) MTEEvent *selectedEvent;
@property (nonatomic, strong) NSMutableArray *emails;
@property (nonatomic, strong) NSMutableArray *facebookmMembers;

@end
