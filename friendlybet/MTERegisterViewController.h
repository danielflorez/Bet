//
//  MTERegisterViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/11/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTELoginViewController.h"

@interface MTERegisterViewController : UIViewController <UITextFieldDelegate,NSURLConnectionDataDelegate>
@property (nonatomic, strong) MTELoginViewController *lvc;
@property (weak, nonatomic) IBOutlet UIButton *checkBT;
@property (nonatomic) BOOL checked;

- (void)checkAction;

@end
