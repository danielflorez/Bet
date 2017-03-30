//
//  MTECreateEventViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/11/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEEventsTableViewController.h"
#import "MTETeam.h"

@interface MTECreateEventViewController : UIViewController <UITextFieldDelegate,NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) MTEEventsTableViewController *eventTVC;
@property (weak, nonatomic) IBOutlet UIButton *selectTeamButton;
@property (nonatomic, strong) MTETeam *selectedTeam;
@property (nonatomic) NSInteger selectedRow;
@property (weak, nonatomic) IBOutlet UISwitch *groupPhaseSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *round16Switch;
@property (weak, nonatomic) IBOutlet UISwitch *round8Switch;
@property (weak, nonatomic) IBOutlet UISwitch *semiFinalSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *finalSwitch;
@property (weak, nonatomic) IBOutlet UITextField *teamTextField;
@end
