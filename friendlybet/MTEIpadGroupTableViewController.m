//
//  MTEIpadGroupTableViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/25/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEIpadGroupTableViewController.h"


@interface MTEIpadGroupTableViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;

@end

@implementation MTEIpadGroupTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UITableView *view = [[UITableView alloc] init];
        self.tableView = view;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadGroups];
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    [self.tableView reloadData];
    UIEdgeInsets inset = UIEdgeInsetsMake(2, 0, 0, 0);
    self.tableView.contentInset = inset;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.teams = [[MTEBetStore sharedStore] teams];
    [self reloadGroups];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (self.groups.count > 1) {
        if ([self.event.teamID isEqualToString:@"0"]) {
            return [_groups count];
        }else{
            return 1;
        }
    }else{
        return 0;
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
        gr = self.selectedGroup;
    }
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(30, (cell.frame.size.height/2)-15, 100, 30)];
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
    cell.backgroundColor = [UIColor clearColor];
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
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor clearColor];
    cell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 80);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.ibvc.selectedGroup = [self.groups objectAtIndex:indexPath.row];
    MTEGroup *group = [[MTEGroup alloc] init];
    if ([self.event.teamID isEqualToString:@"0"]) {
        group = [_groups objectAtIndex:indexPath.row];
        self.ibvc.selectedGroup = group;
    }else{
        group = self.selectedGroup;
        self.ibvc.selectedGroup = group;
    }
    self.igmvc.matches = [self getMatchesForGroup:group];
    
    [self.ibvc reloadTeams];
}

- (NSMutableArray *)getMatchesForGroup:(MTEGroup *)g
{
    MTETeam *team1 = [g.teams objectAtIndex:0];
    MTETeam *team2 = [g.teams objectAtIndex:1];
    MTETeam *team3 = [g.teams objectAtIndex:2];
    MTETeam *team4 = [g.teams objectAtIndex:3];
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
    return mt;
}

- (void)fetchGroups
{
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.center = CGPointMake(self.tableView.frame.size.width/2, self.tableView.frame.size.height/2);
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
    if (![self.event.teamID isEqualToString:@"0"])
    {
        for (MTEGroup *group in self.groups)
        {
            for (MTETeam *team in group.teams)
            {
                if ([team.teamID isEqualToString:self.event.teamID])
                {
                    self.selectedGroup = group;
                }
            }
        }
    }
    [self.spinner stopAnimating];
    [self.tableView reloadData];
    if ([self.event.teamID isEqualToString:@"0"]) {
        self.ibvc.selectedGroup = [self.groups objectAtIndex:0];
    }else
    {
        self.ibvc.selectedGroup = self.selectedGroup;
    }
    self.igmvc.matches = [self getMatchesForGroup:[self.groups objectAtIndex:0]];
    [self.ibvc reloadTeams];
}

- (void)reloadGroups
{
    self.groups = [[NSMutableArray alloc] init];
    [self fetchGroups];
}
@end
