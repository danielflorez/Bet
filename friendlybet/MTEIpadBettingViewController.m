//
//  MTEIpadBettingViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/25/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEIpadBettingViewController.h"
#import "MTEIpadGroupTableViewController.h"
#import "MTEBetStore.h"
#import "MTEIpadTeamsTableViewController.h"
#import "MTEIpadGroupMatchesTableViewController.h"
#import "MTEIpadBetViewController.h"


@interface MTEIpadBettingViewController ()
@property (nonatomic, strong) MTEIpadGroupTableViewController *groupTVC;
@property (nonatomic, strong) MTEIpadTeamsTableViewController *teamTVC;
@property (nonatomic, strong) MTEIpadGroupMatchesTableViewController *gMatchesTVC;

@end

@implementation MTEIpadBettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView_.adUnitID = @"ca-app-pub-8260074602621393/7755568460";
    self.bannerView_.rootViewController = self;
    self.bannerView_.frame = CGRectMake(0, 69, self.view.frame.size.width, 90);
    [self.view addSubview:self.bannerView_];
    [self.bannerView_ loadRequest:[GADRequest request]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,17,25);
    [button setBackgroundImage:[UIImage imageNamed:@"Arrow_2.png"] forState:UIControlStateNormal];
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.tabBarController.navigationItem setLeftBarButtonItem:barButtonItem];
    UIImage *bg = [UIImage imageNamed:@"Background.jpg"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    self.groupTVC = [storyboard instantiateViewControllerWithIdentifier:@"groupIpad"];
    self.groupTVC.event = self.event;
    self.groupTVC.teams = [[MTEBetStore sharedStore] teams];
    NSString *teamName = [[self.groupTVC.teams objectAtIndex:0] name];
    if ([teamName isEqualToString:@"Seleccionar"]||[teamName isEqualToString:@"Select"])
    {
        [self.groupTVC.teams removeObjectAtIndex:0];
    }
    self.groupTVC.groups = self.groups;
    self.groupTVC.tableView.frame = CGRectMake(0, 88, self.view.frame.size.width/4, self.view.frame.size.height-88);
    self.groupTVC.ibvc = self;
    self.groupTVC.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.groupTVC.tableView];
    
    UIStoryboard *storyboardIpad = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    self.teamTVC = [storyboardIpad instantiateViewControllerWithIdentifier:@"ipadTeams"];
    self.teamTVC.selectedGroup = [self.groups objectAtIndex:0];
    self.teamTVC.tableView.frame = CGRectMake(self.view.frame.size.width/4, 88,  3*(self.view.frame.size.width/4), 3*(self.view.frame.size.height/8));
    self.teamTVC.tableView.backgroundColor = [UIColor clearColor];
    self.teamTVC.event = self.event;
    [self.view addSubview:self.teamTVC.tableView];
    
    self.gMatchesTVC = [storyboardIpad instantiateViewControllerWithIdentifier:@"ipadGMatches"];
    self.gMatchesTVC.tableView.frame = CGRectMake(self.view.frame.size.width/4, 3*(self.view.frame.size.height/8)+88, 3*(self.view.frame.size.width/4), (5*(self.view.frame.size.height/8)-88));
    self.gMatchesTVC.event = self.event;
    self.gMatchesTVC.ipvc = self;
    [self.view addSubview:self.gMatchesTVC.tableView];
    self.gMatchesTVC.tableView.backgroundColor = [UIColor clearColor];
    self.groupTVC.igmvc = self.gMatchesTVC;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *title;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        title = @"Groups";
    }
    else {
        title = @"Grupos";
    }
    self.tabBarController.navigationItem.title = title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void) reloadTeams
{
    self.teamTVC.selectedGroup = self.selectedGroup;
    [self.teamTVC rlData];
    [self.gMatchesTVC reloadBets];
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
