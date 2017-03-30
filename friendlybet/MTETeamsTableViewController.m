//
//  MTETeamsTableViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/8/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTETeamsTableViewController.h"
#import "MTEBetRound.h"

@interface MTETeamsTableViewController ()
@property (nonatomic, strong) NSMutableData *dataRecieved;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic) BOOL saving;

@end

@implementation MTETeamsTableViewController

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
    self.bannerView_.frame = CGRectMake(0, self.view.frame.size.height - 166, 320, 50);
    [self.view addSubview:self.bannerView_];
    [self.bannerView_ loadRequest:[GADRequest request]];
    if (!self.selectedTeams) {
        self.selectedTeams = [[NSMutableArray alloc] init];
    }
    if (!self.bets) {
        self.bets = [[NSMutableArray alloc] init];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,17,25);
    [button setBackgroundImage:[UIImage imageNamed:@"Arrow_2.png"] forState:UIControlStateNormal];
    
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.tabBarController.navigationItem setLeftBarButtonItem:barButtonItem];
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.jpg"]];
    [self.tableView setBackgroundView:bg];
     // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *title;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        if ([self.selectedGroup.name isEqualToString:@"Grupo A"]) {
            title = @"Group A";
        } else if ([self.selectedGroup.name isEqualToString:@"Grupo B"]) {
            title = @"Group B";
        }else if ([self.selectedGroup.name isEqualToString:@"Grupo C"]) {
            title = @"Group C";
        }else if ([self.selectedGroup.name isEqualToString:@"Grupo D"]) {
            title = @"Group D";
        }else if ([self.selectedGroup.name isEqualToString:@"Grupo E"]) {
            title = @"Group E";
        }else if ([self.selectedGroup.name isEqualToString:@"Grupo F"]) {
            title = @"Group F";
        }else if ([self.selectedGroup.name isEqualToString:@"Grupo G"]) {
            title = @"Group G";
        }else if ([self.selectedGroup.name isEqualToString:@"Grupo H"]) {
            title = @"Group H";
        }
    }
    else {
        title = self.selectedGroup.name;
    }
    self.tabBarController.navigationItem.title = title;
    [self reloadBets];
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

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.selectedGroup.teams count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    MTETeam *team = [self.selectedGroup.teams objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    UILabel *posButton = [[UILabel alloc] initWithFrame:CGRectMake(6, (cell.frame.size.height/2)-15, 30, 30)];
    UIImage *img = [UIImage imageNamed:@"Match_Circle_2.png"];
    CGSize imgSize = posButton.frame.size;
    UIGraphicsBeginImageContext( imgSize );
    [img drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    posButton.backgroundColor = [UIColor colorWithPatternImage:newImage];
    posButton.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row +1];
    [posButton setTextAlignment:NSTextAlignmentCenter];
    posButton.textColor = [UIColor whiteColor];
    UIImageView *flag = [[UIImageView alloc] initWithFrame:CGRectMake(44, (cell.frame.size.height/2)-19, 38, 38)];
    flag.image = [UIImage imageNamed:[team flag]];
    UILabel *teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, (cell.frame.size.height/2)-12, 149, 24)];
    teamLabel.text =[team name];
    UILabel *pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 26, (cell.frame.size.height/2)-12, 24, 24)];
    pointsLabel.text = [team points];
    [pointsLabel setTextAlignment:NSTextAlignmentCenter];
    UILabel *gdLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 52,(cell.frame.size.height/2)-12, 24, 24)];
    gdLabel.text = [team goalDif];
    [gdLabel setTextAlignment:NSTextAlignmentCenter];
    teamLabel.textColor = [UIColor whiteColor];
    pointsLabel.textColor = [UIColor whiteColor];
    gdLabel.textColor = [UIColor whiteColor];
    UILabel *pj = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 78,(cell.frame.size.height/2)-12, 24, 24)];
    pj.text = [team gamesPlayed];
    [pj setTextAlignment:NSTextAlignmentCenter];
    pj.textColor = [UIColor whiteColor];
    [cell addSubview:posButton];
    [cell addSubview:flag];
    [cell addSubview:teamLabel];
    [cell addSubview:pointsLabel];
    [cell addSubview:gdLabel];
    [cell addSubview:pj];
    if (indexPath.row == 0) {
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 2)];
        separatorLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Line.png"]];
        [cell.contentView addSubview:separatorLineView];
    }
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height, cell.frame.size.width, 2)];
    separatorLineView1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Line.png"]];
    [cell.contentView addSubview:separatorLineView1];
    if ([self.selectedTeams containsObject:team]) {
        teamLabel.textColor = [UIColor greenColor];
        posButton.textColor = [UIColor greenColor];
        pointsLabel.textColor = [UIColor greenColor];
        pj.textColor = [UIColor greenColor];
        gdLabel.textColor = [UIColor greenColor];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    UILabel *pos = [[UILabel alloc] initWithFrame:CGRectMake(6, (cell.frame.size.height/2)-12, 38, 24)];
    pos.text = @"Pos";
    pos.textColor = [UIColor whiteColor];
    pos.font = [UIFont systemFontOfSize:14];
    UILabel *team = [[UILabel alloc] initWithFrame:CGRectMake(44, (cell.frame.size.height/2)-12, 69, 24)];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *te;
    NSString *pjT;
    if([language isEqualToString:@"en"])
    {
        te = @"Team";
        pjT = @"GP";
    }
    else {
        te = @"Equipo";
        pjT = @"PJ";
    }
    team.textColor = [UIColor whiteColor];
    team.text = te;
    team.font = [UIFont systemFontOfSize:14];
    UILabel *pj = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 78,(cell.frame.size.height/2)-12, 24, 24)];
    pj.textColor = [UIColor whiteColor];
    [pj setTextAlignment:NSTextAlignmentCenter];
    pj.text = pjT;
    pj.font = [UIFont systemFontOfSize:14];
    UILabel *gd = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 52,(cell.frame.size.height/2)-12, 24, 24)];
    gd.textColor = [UIColor whiteColor];
    gd.text = @"GD";
    gd.font = [UIFont systemFontOfSize:14];
    [pj setTextAlignment:NSTextAlignmentCenter];
    UILabel *pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 26, (cell.frame.size.height/2)-12, 24, 24)];
    [pointsLabel setTextAlignment:NSTextAlignmentCenter];
    pointsLabel.textColor = [UIColor whiteColor];
    pointsLabel.font = [UIFont systemFontOfSize:14];
    pointsLabel.text = @"Pts";
    [cell addSubview:pos];
    [cell addSubview:team];
    [cell addSubview:pj];
    [cell addSubview:gd];
    [cell addSubview:pointsLabel];
    UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 277, 58)];
    av.backgroundColor = [UIColor clearColor];
    av.opaque = NO;
    av.image = [UIImage imageNamed:@"Table_Background.png"];
    cell.backgroundView = av;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 180);
    if (self.event.pointsXQualified) {
        UITextView *info = [[UITextView alloc ]init];
        info.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        info.textColor = [UIColor whiteColor];
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"To bet on the teams that you think will pass to the next round click on them, you can select two. The selected teams letters will be green. You can change your selections until the day of the first match";
        }
        else {
            title = @"Para seleccionar que equipos cree que pasan a la siguiente ronda haga click sobre ellos, puede seleccionar maximo dos. Las letras de los equipos seleccionas se veran en verde. Puede cambiar su seleccion hasta el dia del primer partido.";
        }
        info.text = title;
        info.backgroundColor = [UIColor clearColor];
        [cell addSubview:info];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section
{
    return 180.0;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.event.pointsXQualified) {
        MTETeam *team1 = [self.selectedGroup.teams objectAtIndex:indexPath.row];
        if ([self.selectedTeams containsObject:team1]) {
            [self.selectedTeams removeObject:team1];
        }else{
            if (self.selectedTeams.count < 2) {
                [self.selectedTeams addObject:team1];
            } else
            {
                NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
                NSString *title;
                if([language isEqualToString:@"en"])
                {
                    title = @"You can only select two teams per group.";
                }
                else {
                    title = @"Solo se pueden escoger dos equipos por grupo.";
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:title
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
        }
        [self.tableView reloadData];
        if ([self.selectedTeams count] > 0) {
            [self saveRoundBet];
        }
    }
}

- (void) saveRoundBet
{
    self.tableView.allowsSelection = NO;
    self.saving = YES;
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = NO;
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    NSString *idteam1 = [[self.selectedTeams objectAtIndex:0] teamID];
    NSString *idteam2 = nil;
    if ([self.selectedTeams count]==2) {
        idteam2 = [[self.selectedTeams objectAtIndex:1] teamID];;
    }
    NSString *post = [NSString stringWithFormat:@"&id_member=%@&id_private_event=%@&group_id=%@&team1_id=%@&team2_id=%@&id_roundxevent=%@",self.event.memberID, self.event.eventID, self.selectedGroup.groupid,idteam1, idteam2,@"1"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/includes/register_roundbet_2.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

- (void)fetchBets
{
    self.saving = NO;
    self.tableView.allowsSelection = NO;
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:NO];
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = NO;
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSString *post = [NSString stringWithFormat:@"&id_member=%@&id_private_event=%@&id_group=%@",self.event.memberID,self.event.eventID,self.selectedGroup.groupid];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/test/bet_round.php"]]];
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
    if (self.saving) {
        NSString *dat = [[NSString alloc] initWithData:self.dataRecieved encoding:NSUTF8StringEncoding];
        if ([dat isEqualToString:@"OK"]) {
            
        }else if([dat isEqualToString:@"ERROR_ROUND_STARTED"]){
            NSString *regis;
            NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
            if([language isEqualToString:@"en"])
            {
                regis = @"The group stage has already began.";
            }
            else {
                regis = @"La fase de grupos ya comenzo.";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:regis
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.spinner stopAnimating];
            [self reloadBets];
        }
    }
    else
    {
        NSDictionary *bets= [NSJSONSerialization JSONObjectWithData:self.dataRecieved
                                                            options:0
                                                              error:nil];
        for (NSDictionary *item in [bets objectForKey:@"Bets"]) {
            MTEBetRound *bet = [[MTEBetRound alloc] init];
            bet.groupID = self.selectedGroup.groupid;
            bet.team1 = item[@"team1"];
            bet.team2= item[@"team2"];
            bet.checked = item[@"checked"];
            bet.points = item[@"POINTS"];
            [self.bets addObject:bet];
        }
        for (MTEBetRound *bet in self.bets) {
            for (MTETeam *team in self.selectedGroup.teams) {
                if ([bet.team1 isEqualToString:team.teamID]) {
                    [self.selectedTeams addObject:team];
                }
                if (![bet.team2 isMemberOfClass:[NSNull class]]) {
                    if ([bet.team2 isEqualToString:team.teamID]) {
                        [self.selectedTeams addObject:team];
                    }
                }
            }
        }
        [self.tableView reloadData];
    }
    [self.spinner stopAnimating];
    if (self.event.pointsXQualified) {
        self.tableView.allowsSelection = YES;
    }
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = YES;
    
}

- (void)reloadBets
{
    self.selectedTeams = [[NSMutableArray alloc] init];
    self.bets = [[NSMutableArray alloc] init];
    [self fetchBets];
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
