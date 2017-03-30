//
//  MTESelectTeamViewController.h
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/18/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTETeam.h"
#import "MTECreateEventViewController.h"

@interface MTESelectTeamViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) NSMutableArray *teams;
@property (nonatomic, strong) MTECreateEventViewController *cevc;
@property (nonatomic, strong) MTETeam *selectedTeam;
@property (weak, nonatomic) IBOutlet UIPickerView *teamPicker;
@property (nonatomic) NSInteger selectedRow;

@end
