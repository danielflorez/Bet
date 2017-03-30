//
//  MTETermsFacebookIpadViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 5/23/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MTETermsFacebookIpadViewController : UIViewController <UIWebViewDelegate,FBLoginViewDelegate,NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSString *fbemail;
@property (nonatomic, strong) FBLoginView *loginView;

@end
