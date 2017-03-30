//
//  MTEIpadCreateEventViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/29/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTETeam.h"
#import "MTEIpadEventsTableViewController.h"

@interface MTEIpadCreateEventViewController : UIViewController <UITextFieldDelegate,NSURLConnectionDataDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) MTEIpadEventsTableViewController *eventTVC;
@property (weak, nonatomic) IBOutlet UIButton *selectTeamButton;
@property (nonatomic, strong) MTETeam *selectedTeam;
@property (nonatomic) NSInteger selectedRow;
@property (weak, nonatomic) IBOutlet UISwitch *groupPhaseSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *round16Switch;
@property (weak, nonatomic) IBOutlet UISwitch *round8Switch;
@property (weak, nonatomic) IBOutlet UISwitch *semiFinalSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *finalSwitch;
@property (nonatomic, strong) NSMutableArray *teams;
@property (weak, nonatomic) IBOutlet UIPickerView *teamPicker;

@end
