//
//  MTESelectTeamViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/18/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTESelectTeamViewController.h"
#import "MTEBetStore.h"

@interface MTESelectTeamViewController ()

@end

@implementation MTESelectTeamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self selectRow:self.selectedRow];
}

- (void)selectRow:(NSInteger)row
{
    [self.teamPicker selectRow:row inComponent:0 animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    NSString *title;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        title = @"Select Team";
    }
    else {
        title = @"Seleccionar Equipo";
    }
    self.navigationItem.title = title;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,17,25);
    [button setBackgroundImage:[UIImage imageNamed:@"Arrow_2.png"] forState:UIControlStateNormal];
    
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    self.teams = [[MTEBetStore sharedStore] teams];
    UIImage *bg = [UIImage imageNamed:@"Background.jpg"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bg]];
    self.selectedTeam = [self.teams objectAtIndex:0];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.teams count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    MTETeam *t = [self.teams objectAtIndex:row];
    CGRect viewFrame = CGRectMake(0, 0, 320, 44);
    UIView *cell = [[UIView alloc] initWithFrame:viewFrame];
    UIImageView *imView = [[UIImageView alloc] initWithFrame:CGRectMake(42, 2, 40, 40)];
    imView.image = [UIImage imageNamed:[t flag]];
    [cell addSubview:imView];
    UILabel *teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, 11, 160, 21)];
    teamLabel.textColor = [UIColor whiteColor];
    teamLabel.text =[t name];
    [cell addSubview:teamLabel];
    cell.backgroundColor = [UIColor clearColor];
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 2)];
    separatorLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Line.png"]];
    [cell addSubview:separatorLineView];
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height, cell.frame.size.width, 2)];
    separatorLineView1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Line.png"]];
    [cell addSubview:separatorLineView1];
    return cell;
}

- (void)pickerView:(UIPickerView *)thePickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    self.selectedTeam = [self.teams objectAtIndex:row];
    self.selectedRow = row;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    return 320.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView
rowHeightForComponent:(NSInteger)component
{
    return 44.0;
}

- (IBAction)saveAction:(id)sender
{
    self.cevc.selectedRow = self.selectedRow;
    self.cevc.selectedTeam = self.selectedTeam;
    self.cevc.teamTextField.text = self.selectedTeam.name;
    [self.cevc.groupPhaseSwitch setOn:NO];
    self.cevc.groupPhaseSwitch.enabled = NO;
    [self.cevc.round16Switch setOn:NO];
    self.cevc.round16Switch.enabled = NO;
    [self.cevc.round8Switch setOn:NO];
    self.cevc.round8Switch.enabled = NO;
    [self.cevc.semiFinalSwitch setOn:NO];
    self.cevc.semiFinalSwitch.enabled = NO;
    [self.cevc.finalSwitch setOn:NO];
    self.cevc.finalSwitch.enabled = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteTeamAction:(id)sender {
    self.cevc.selectedRow = 0;
    self.cevc.selectedTeam = nil;
    self.cevc.teamTextField.text =@"";
    self.cevc.groupPhaseSwitch.enabled = YES;
    self.cevc.round16Switch.enabled = YES;
    self.cevc.round8Switch.enabled = YES;
    self.cevc.semiFinalSwitch.enabled = YES;
    self.cevc.finalSwitch.enabled = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
