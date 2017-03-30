//
//  MTEBetViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/15/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTETeam.h"
#import "MTEMatch.h"
#import "MTEEvent.h"
#import "MTEGroupMatchesTableViewController.h"

@interface MTEBetViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDataDelegate>
@property (nonatomic, strong) MTEMatch *match;
@property (nonatomic, strong) MTEEvent *event;
@property (nonatomic, strong) MTEGroupMatchesTableViewController *gmvc;
@property (nonatomic, strong) NSMutableArray *bets;
@property (weak, nonatomic) IBOutlet UIImageView *flag1;
@property (weak, nonatomic) IBOutlet UIImageView *flag2;
@property (weak, nonatomic) IBOutlet UILabel *team1;
@property (weak, nonatomic) IBOutlet UILabel *team2;
@property (weak, nonatomic) IBOutlet UITextField *score1;
@property (weak, nonatomic) IBOutlet UITextField *score2;
@end
