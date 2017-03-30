//
//  MTEIpadBetEventTableViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/25/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEIpadBetEventTableViewController.h"
#import "MTEIpadBettingViewController.h"
#import "MTETeam.h"
#import "MTEBetStore.h"
#import "MTEIpadEventPositionsTableViewController.h"
#import "MTEIpadGroupMatchesFinalTableViewController.h"

@interface MTEIpadBetEventTableViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;
@property (nonatomic, strong) UIButton *betButton;
@property (nonatomic, strong) UIButton *positionButton;

@end

@implementation MTEIpadBetEventTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    [self.view addSubview:self.bannerView_];
    [self.bannerView_ loadRequest:[GADRequest request]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,17,25);
    [button setBackgroundImage:[UIImage imageNamed:@"Arrow_2.png"] forState:UIControlStateNormal];
    
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.jpg"]];
    [self.tableView setBackgroundView:bg];
    self.teams = [[MTEBetStore sharedStore] teams];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 100);
    UIButton *cellButton = [[UIButton alloc] init];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if (indexPath.row == 0) {
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"Event positions";
        }
        else {
            title = @"Posiciones del evento";
        }
        [cellButton setTitle:title forState:UIControlStateNormal];
        [cellButton sizeToFit];
        [cellButton addTarget:self
                       action:@selector(eventPositionAction)
             forControlEvents:UIControlEventTouchUpInside];
        self.positionButton = cellButton;
    } else if(indexPath.row == 1)
    {
        NSString *title1;
        if([language isEqualToString:@"en"])
        {
            title1 = @"Bets";
        }
        else {
            title1 = @"Apuestas";
        }
        [cellButton setTitle:title1 forState:UIControlStateNormal];
        [cellButton sizeToFit];
        [cellButton addTarget:self
                       action:@selector(fetchMatches)
             forControlEvents:UIControlEventTouchUpInside];
        self.betButton = cellButton;
    }
    cellButton.frame = CGRectMake((cell.frame.size.width/2)-200,(cell.frame.size.height/2)-24,400,49);
    UIImage *bg = [UIImage imageNamed:@"Background_buttons.png"];
    UIGraphicsBeginImageContextWithOptions(cellButton.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, cellButton.frame.size.width, cellButton.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [cellButton setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];
    cell.backgroundColor = [UIColor clearColor];
    [cell addSubview:cellButton];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 200)];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200.0;
}

- (void)eventPositionAction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    MTEIpadEventPositionsTableViewController *eptvc = [storyboard instantiateViewControllerWithIdentifier:@"ipadEventPositions"];
    eptvc.event = self.event;
    [self.navigationController pushViewController:eptvc
                                         animated:YES];
}

- (void)fetchMatches
{
    self.positionButton.enabled = NO;
    self.betButton.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    self.matches= [[NSMutableArray alloc] init];
    NSString *post = @"";
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/test/matches.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.dataRecieved setLength:0];//Set your data to 0 to clear your buffer
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.dataRecieved appendData:data];//Append the download data..
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Use your downloaded data here
    NSDictionary *matches= [NSJSONSerialization JSONObjectWithData:self.dataRecieved
                                                           options:0
                                                             error:nil];
    for (NSDictionary *match in [matches objectForKey:@"Match"]) {
        MTEMatch *m = [[MTEMatch alloc] init];
        m.matchID = match[@"Matchid"];
        m.roundID = match[@"Round"];
        m.order = match[@"Order"];
        m.score1 = match[@"score_team1"];
        m.score2 = match[@"score_team2"];
        m.started = match[@"started"];
        NSString *teamName = [[self.teams objectAtIndex:0] name];
        if ([teamName isEqualToString:@"Seleccionar"]||[teamName isEqualToString:@"Select"])
        {
            [self.teams removeObjectAtIndex:0];
        }
        NSNumber *t = [NSNumber numberWithInteger:[match[@"Team1"] integerValue]];
        m.team1 = [self.teams objectAtIndex:[t intValue]-1];
        NSNumber *t2 = [NSNumber numberWithInteger:[match[@"Team2"] integerValue]];
        m.team2 = [self.teams objectAtIndex:[t2 intValue]-1];
        NSString *d = match[@"Date"];
        NSDateFormatter *dateFormatter  =   [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"BRT"]];
        NSDate *yourDate =  [dateFormatter dateFromString:d];
        m.date =  yourDate;
        [self.matches addObject:m];
    }
    self.event.matches = self.matches;
    [self.spinner stopAnimating];
    [self betAction];
}


- (void)betAction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    UITabBarController *tbc = [storyboard instantiateViewControllerWithIdentifier:@"ipadTabPhases"];
    UITabBarItem *tabBarItem0 =[[tbc.viewControllers objectAtIndex:0] tabBarItem];
    UITabBarItem *tabBarItem1 =[[tbc.viewControllers objectAtIndex:1] tabBarItem];
    UITabBarItem *tabBarItem2 =[[tbc.viewControllers objectAtIndex:2] tabBarItem];
    UITabBarItem *tabBarItem3 =[[tbc.viewControllers objectAtIndex:3] tabBarItem];
    UITabBarItem *tabBarItem4 =[[tbc.viewControllers objectAtIndex:4] tabBarItem];
    tabBarItem0.selectedImage =[[UIImage imageNamed:@"Group_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem0.image = [[UIImage imageNamed:@"Group_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.selectedImage =[[UIImage imageNamed:@"Round2_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.image = [[UIImage imageNamed:@"Round2_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.selectedImage =[[UIImage imageNamed:@"Round3_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.image = [[UIImage imageNamed:@"Round3_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.selectedImage =[[UIImage imageNamed:@"Semifinal_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.image = [[UIImage imageNamed:@"Semifinal_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem4.selectedImage =[[UIImage imageNamed:@"Final_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem4.image = [[UIImage imageNamed:@"Final_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    MTEIpadBettingViewController *ibvc = [tbc.viewControllers objectAtIndex:0];
    ibvc.event = self.event;
    MTEIpadGroupMatchesFinalTableViewController *roundSixteen = [tbc.viewControllers objectAtIndex:1];
    MTEIpadGroupMatchesFinalTableViewController  *roundEight = [tbc.viewControllers objectAtIndex:2];
    MTEIpadGroupMatchesFinalTableViewController  *semiFinal = [tbc.viewControllers objectAtIndex:3];
    MTEIpadGroupMatchesFinalTableViewController  *final = [tbc.viewControllers objectAtIndex:4];
    roundSixteen.event = self.event;
    roundEight.event = self.event;
    semiFinal.event = self.event;
    final.event = self.event;
    if (!self.event.groupphase) {
        [[[[tbc tabBar]items]objectAtIndex:0]setEnabled:FALSE];
    }
    if (!self.event.roundsixteen) {
        [[[[tbc tabBar]items]objectAtIndex:1]setEnabled:FALSE];
    }
    if (!self.event.quarter) {
        [[[[tbc tabBar]items]objectAtIndex:2]setEnabled:FALSE];
    }
    if (!self.event.semifinal) {
        [[[[tbc tabBar]items]objectAtIndex:3]setEnabled:FALSE];
    }
    if (!self.event.final) {
        [[[[tbc tabBar]items]objectAtIndex:4]setEnabled:FALSE];
    }
    if (![[[[tbc tabBar]items]objectAtIndex:0]isEnabled]) {
        [tbc setSelectedIndex:1];
    }
    if (![[[[tbc tabBar]items]objectAtIndex:1]isEnabled]&&![[[[tbc tabBar]items]objectAtIndex:0]isEnabled]) {
        [tbc setSelectedIndex:2];
    }
    if (![[[[tbc tabBar]items]objectAtIndex:2]isEnabled]&&![[[[tbc tabBar]items]objectAtIndex:1]isEnabled]&&![[[[tbc tabBar]items]objectAtIndex:0]isEnabled]) {
        [tbc setSelectedIndex:3];
    }
    if (![[[[tbc tabBar]items]objectAtIndex:3]isEnabled]&&![[[[tbc tabBar]items]objectAtIndex:2]isEnabled]&&![[[[tbc tabBar]items]objectAtIndex:1]isEnabled]&&![[[[tbc tabBar]items]objectAtIndex:0]isEnabled]) {
        [tbc setSelectedIndex:4];
    }
    NSMutableArray *RSMatches = [[NSMutableArray alloc] init];
    NSMutableArray *REMatches = [[NSMutableArray alloc] init];
    NSMutableArray *SFMatches = [[NSMutableArray alloc] init];
    NSMutableArray *FMatches = [[NSMutableArray alloc] init];
    for (MTEMatch *match in self.event.matches) {
        if ([match.order isEqualToString:@"2"]) {
            if ([self.event.teamID isEqualToString:@"0"]) {
                [RSMatches addObject:match];
            }else if([self.event.teamID isEqualToString:match.team1.teamID]||[self.event.teamID isEqualToString:match.team2.teamID]){
                [RSMatches addObject:match];
            }
        }else if ([match.order isEqualToString:@"3"]){
            if ([self.event.teamID isEqualToString:@"0"]) {
                [REMatches addObject:match];
            }else if([self.event.teamID isEqualToString:match.team1.teamID]||[self.event.teamID isEqualToString:match.team2.teamID]){
                [REMatches addObject:match];
            }
        }else if ([match.order isEqualToString:@"4"]){
            if ([self.event.teamID isEqualToString:@"0"]) {
                [SFMatches addObject:match];
            }else if([self.event.teamID isEqualToString:match.team1.teamID]||[self.event.teamID isEqualToString:match.team2.teamID]){
                [SFMatches addObject:match];
            }
        }else if ([match.order isEqualToString:@"5"]||[match.order isEqualToString:@"6"]){
            if ([self.event.teamID isEqualToString:@"0"]) {
                [FMatches addObject:match];
            }else if([self.event.teamID isEqualToString:match.team1.teamID]||[self.event.teamID isEqualToString:match.team2.teamID]){
                [FMatches addObject:match];
            }
        }
    }
    roundSixteen.matches = RSMatches;
    roundEight.matches = REMatches;
    semiFinal.matches = SFMatches;
    final.matches = FMatches;
    self.positionButton.enabled = YES;
    self.betButton.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [self.navigationController pushViewController:tbc animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
