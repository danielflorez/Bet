//
//  MTEGroupViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/8/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEGroupViewController.h"
#import "MTETeamsTableViewController.h"
#import "MTEGroupMatchesTableViewController.h"


@interface MTEGroupViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;
@end

@implementation MTEGroupViewController

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
    self.bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView_.adUnitID = @"ca-app-pub-8260074602621393/7755568460";
    self.bannerView_.rootViewController = self;
    [self.bannerView_ loadRequest:[GADRequest request]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,17,25);
    [button setBackgroundImage:[UIImage imageNamed:@"Arrow_2.png"] forState:UIControlStateNormal];
    
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.tabBarController.navigationItem setLeftBarButtonItem:barButtonItem];
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.jpg"]];
    [self.tableView setBackgroundView:bg];
    self.teams = [[MTEBetStore sharedStore] teams];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    [self reloadGroups];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.event.teamID isEqualToString:@"0"]) {
        return [_groups count];
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 44);
    MTEGroup *gr = [[MTEGroup alloc] init];
    if ([self.event.teamID isEqualToString:@"0"]) {
        gr = [self.groups objectAtIndex:indexPath.row];
    }else{
        for (MTEGroup *group in self.groups) {
            for (MTETeam *team in group.teams) {
                if ([team.teamID isEqualToString:self.event.teamID]) {
                    gr = group;
                    self.selectedGroup = gr;
                }
            }
        }
    }
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(40, (cell.frame.size.height/2)-15, 100, 30)];
    lblName.textColor =[UIColor whiteColor];
    lblName.backgroundColor = [UIColor clearColor];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        if (indexPath.row == 0) {
            [lblName setText:@"Group A"];
        } else if(indexPath.row == 1) {
            [lblName setText:@"Group B"];
        }else if(indexPath.row == 2) {
            [lblName setText:@"Group C"];
        }else if(indexPath.row == 3) {
            [lblName setText:@"Group D"];
        }else if(indexPath.row == 4) {
            [lblName setText:@"Group E"];
        }else if(indexPath.row == 5) {
            [lblName setText:@"Group F"];
        }else if(indexPath.row == 6) {
            [lblName setText:@"Group G"];
        }else if(indexPath.row == 7) {
            [lblName setText:@"Group H"];
        }
    }
    else {
        [lblName setText:[gr name]];
    }
    UIImage *bgI = [UIImage imageNamed:@"List_Field"];
    UIGraphicsBeginImageContextWithOptions(cell.frame.size, NO, 0.f);
    [bgI drawInRect:CGRectMake(0.f, 0.f, cell.frame.size.width, cell.frame.size.height-8)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    bg.backgroundColor = [UIColor colorWithPatternImage:resultImage];
    [cell.contentView addSubview:bg];
    [cell addSubview:lblName];
    if (indexPath.row == [self.groups count]-1) {
        UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-2, cell.frame.size.width, 2)];
        separatorLineView1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"List_line.png"]];
        [cell.contentView addSubview:separatorLineView1];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 91)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section
{
    return 91.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [cell addSubview:self.bannerView_];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Get the new view controller using [segue destinationViewController].
    MTEGroup *group = [[MTEGroup alloc] init];
    if ([self.event.teamID isEqualToString:@"0"]) {
        group = [_groups objectAtIndex:indexPath.row];
    }else{
        group = self.selectedGroup;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
 
    UITabBarController *tbc = [storyboard instantiateViewControllerWithIdentifier:@"matchesTabBar"];
    UITabBarItem *tabBarItem =[[tbc.viewControllers objectAtIndex:1] tabBarItem];
    tabBarItem.image = [[UIImage imageNamed:@"Match_Icon1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabBarItem1 =[[tbc.viewControllers objectAtIndex:0] tabBarItem];
    tabBarItem1.image = [[UIImage imageNamed:@"Team_Icon1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    tabBarItem.selectedImage =[[UIImage imageNamed:@"Match_Icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"Team_Icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    MTETeamsTableViewController *ttvc = [tbc.viewControllers objectAtIndex:0];
    ttvc.selectedGroup = group;
    ttvc.event = self.event;
    MTEGroupMatchesTableViewController *gmvc = [tbc.viewControllers objectAtIndex:1];
    MTETeam *team1 = [group.teams objectAtIndex:0];
    MTETeam *team2 = [group.teams objectAtIndex:1];
    MTETeam *team3 = [group.teams objectAtIndex:2];
    MTETeam *team4 = [group.teams objectAtIndex:3];
    NSMutableArray *mt = [[NSMutableArray alloc] init];
    if([self.event.teamID isEqualToString:@"0"])
    {
        for (MTEMatch *match in self.event.matches)
        {
            if ([match.team1.name isEqualToString:team1.name] || [match.team1.name isEqualToString:team2.name] || [match.team1.name isEqualToString:team3.name] || [match.team1.name isEqualToString:team4.name])
            {
                if ([match.roundID isEqualToString:@"1"])
                {
                    [mt addObject:match];
                }
            }
        }
    }else{
        for (MTEMatch *match in self.event.matches)
        {
            if ([match.team1.teamID isEqualToString:self.event.teamID]||[match.team2.teamID isEqualToString:self.event.teamID])
            {
                if ([match.roundID isEqualToString:@"1"])
                {
                    [mt addObject:match];
                }
            }
        }
    }
    gmvc.matches = mt;
    gmvc.event = self.event;
    [self.navigationController pushViewController:tbc
                                         animated:YES];
}

- (void)reloadGroups
{
    self.groups = [[NSMutableArray alloc] init];
    [self fetchGroups];
}

- (void)fetchGroups
{
    self.tableView.allowsSelection = NO;
    [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:FALSE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:FALSE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:FALSE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:FALSE];
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = NO;
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    if (!self.groups) {
        self.groups = [[NSMutableArray alloc] init];
    }
    NSString *requestString = @"http://www.mangostatecnologia.com/secureLogin/test/groups.php";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
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
    NSDictionary *groups= [NSJSONSerialization JSONObjectWithData:self.dataRecieved
                                                           options:0
                                                             error:nil];
    for (NSDictionary *item in [groups objectForKey:@"Groups"]) {
        MTEGroup *g = [[MTEGroup alloc] init];
        g.name = item[@"Group"];
        g.groupid = item[@"idGroup"];
        for (NSDictionary *team in [item objectForKey:@"Teams"]) {
            NSNumber *t = [NSNumber numberWithInteger:[team[@"Teamid"] integerValue]];
            MTETeam *team1 = [self.teams objectAtIndex:[t intValue]-1];
            team1.points = team[@"Points"];
            team1.goalDif = team[@"Goaldif"];
            team1.gc = team[@"gc"];
            team1.gf = team[@"gf"];
            team1.gamesLost = team[@"pp"];
            team1.gamesTied = team[@"pe"];
            team1.gamesWon = team[@"pg"];
            team1.gamesPlayed = team[@"pj"];
            [g.teams addObject:team1];
        }
        [self.groups addObject:g];
    }
    [self.spinner stopAnimating];
    self.tableView.allowsSelection = YES;
    [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:TRUE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:TRUE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:TRUE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:TRUE];
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = YES;
    [self.tableView reloadData];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    
}


@end
