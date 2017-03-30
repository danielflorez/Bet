//
//  MTEIpadRegisterViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/21/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEIpadLoginViewController.h"

@interface MTEIpadRegisterViewController : UIViewController <UITextFieldDelegate,NSURLConnectionDataDelegate>
@property (nonatomic, strong) MTEIpadLoginViewController *lvc;
@property (nonatomic) BOOL checked;
@property (weak, nonatomic) IBOutlet UIButton *checkBT;

- (void)checkAction;

@end
