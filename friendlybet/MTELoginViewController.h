//
//  MTELoginViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 3/27/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEMatch.h"
#import <FacebookSDK/FacebookSDK.h>

@interface MTELoginViewController : UIViewController <UITextFieldDelegate,NSURLConnectionDataDelegate,FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passTextField;

@end
