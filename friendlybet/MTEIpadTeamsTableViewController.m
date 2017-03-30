//
//  MTEIpadTeamsTableViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/26/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEIpadTeamsTableViewController.h"
#import "MTEBetRound.h"

@interface MTEIpadTeamsTableViewController ()
@property (nonatomic, strong) NSMutableData *dataRecieved;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic) BOOL saving;

@end

@implementation MTEIpadTeamsTableViewController

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
    if (!self.selectedTeams) {
        self.selectedTeams = [[NSMutableArray alloc] init];
    }
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    UINib *nib1 = [UINib nibWithNibName:@"MTEGroupTitleTableViewCell"
                                 bundle:nil];
    [[self tableView] registerNib:nib1
           forCellReuseIdentifier:@"title"];
    UIEdgeInsets inset = UIEdgeInsetsMake(80, 0, 0, 0);
    self.tableView.contentInset = inset;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 44);
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
    [cell addSubview:flag];
    UILabel *teamNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, (cell.frame.size.height/2)-13, (cell.frame.size.width/2)-44,26)];
    teamNameLabel.text =[team name];
    teamNameLabel.textColor = [UIColor whiteColor];
    [cell addSubview:teamNameLabel];
    UILabel *pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width-26),(cell.frame.size.height/2)-13, 26, 26)];
    pointsLabel.text = [team points];
    pointsLabel.textColor = [UIColor whiteColor];
    pointsLabel.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:pointsLabel];
    UILabel *gdLabel = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width-52),(cell.frame.size.height/2)-13, 26, 26)];
    gdLabel.text = [team goalDif];
    gdLabel.textColor = [UIColor whiteColor];
    gdLabel.textAlignment = NSTextAlignmentCenter;
    UILabel *gc = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width-78),(cell.frame.size.height/2)-13, 26, 26)];
    gc.text = [team gc];
    gc.textColor = [UIColor whiteColor];
    gc.textAlignment = NSTextAlignmentCenter;
    UILabel *gf = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width-104),(cell.frame.size.height/2)-13, 26, 26)];
    gf.text = [team gf];
    gf.textColor = [UIColor whiteColor];
    gf.textAlignment = NSTextAlignmentCenter;
    UILabel *pp = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width-130),(cell.frame.size.height/2)-13, 26, 26)];
    pp.text = [team gamesLost];
    pp.textColor = [UIColor whiteColor];
    pp.textAlignment = NSTextAlignmentCenter;
    UILabel *pe = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width-156),(cell.frame.size.height/2)-13, 26, 26)];
    pe.text = [team gamesTied];
    pe.textColor = [UIColor whiteColor];
    pe.textAlignment = NSTextAlignmentCenter;
    UILabel *pg = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width-182),(cell.frame.size.height/2)-13, 26, 26)];
    pg.text = [team gamesWon];
    pg.textColor = [UIColor whiteColor];
    pg.textAlignment = NSTextAlignmentCenter;
    UILabel *pj = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width-208),(cell.frame.size.height/2)-13, 26, 26)];
    pj.text = [team gamesPlayed];
    pj.textColor = [UIColor whiteColor];
    pj.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:posButton];
    [cell addSubview:gdLabel];
    [cell addSubview:gc];
    [cell addSubview:gf];
    [cell addSubview:pp];
    [cell addSubview:pe];
    [cell addSubview:pg];
    [cell addSubview:pj];
    cell.backgroundColor = [UIColor clearColor];
    if ([self.selectedTeams containsObject:team]) {
        teamNameLabel.textColor = [UIColor greenColor];
        posButton.textColor = [UIColor greenColor];
        pointsLabel.textColor = [UIColor greenColor];
        pj.textColor = [UIColor greenColor];
        gdLabel.textColor = [UIColor greenColor];
        pe.textColor = [UIColor greenColor];
        pp.textColor = [UIColor greenColor];
        pg.textColor = [UIColor greenColor];
        gf.textColor = [UIColor greenColor];
        gc.textColor = [UIColor greenColor];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 44);
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *te;
    NSString *pjT;
    NSString *pgT;
    NSString *peT;
    NSString *ppT;
    NSString *gcT;
    if([language isEqualToString:@"en"])
    {
        te = @"Team";
        pjT = @"GP";
        pgT = @"GW";
        peT = @"GT";
        ppT = @"GL";
        gcT = @"GA";
    }
    else {
        te = @"Equipo";
        pjT = @"PJ";
        pgT = @"PG";
        peT = @"PE";
        ppT = @"PP";
        gcT = @"GC";
    }
    UILabel *pos = [[UILabel alloc] initWithFrame:CGRectMake(6, (cell.frame.size.height/2)-12, 38, 24)];
    pos.text = @"Pos";
    pos.textColor = [UIColor whiteColor];
    UILabel *team = [[UILabel alloc] initWithFrame:CGRectMake(44, (cell.frame.size.height/2)-12, 69, 24)];
    team.textColor = [UIColor whiteColor];
    team.text = te;
    
    UILabel *points = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width-26),(cell.frame.size.height/2)-13, 26, 26)];
    points.text =@"PT";
    points.textColor = [UIColor whiteColor];
    points.textAlignment = NSTextAlignmentCenter;
    UILabel *gd = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width-52),(cell.frame.size.height/2)-13, 26, 26)];
    gd.text = @"GD";
    gd.textColor = [UIColor whiteColor];
    gd.textAlignment = NSTextAlignmentCenter;
    UILabel *gc = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width-78),(cell.frame.size.height/2)-13, 26, 26)];
    gc.text = gcT;
    gc.textColor = [UIColor whiteColor];
    gc.textAlignment = NSTextAlignmentCenter;
    UILabel *gf = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width-104),(cell.frame.size.height/2)-13, 26, 26)];
    gf.text = @"GF";
    gf.textColor = [UIColor whiteColor];
    gf.textAlignment = NSTextAlignmentCenter;
    UILabel *pp = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width-130),(cell.frame.size.height/2)-13, 26, 26)];
    pp.text =ppT;
    pp.textColor = [UIColor whiteColor];
    pp.textAlignment = NSTextAlignmentCenter;
    UILabel *pe = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width-156),(cell.frame.size.height/2)-13, 26, 26)];
    pe.text = peT;
    pe.textColor = [UIColor whiteColor];
    pe.textAlignment = NSTextAlignmentCenter;
    UILabel *pg = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width-184),(cell.frame.size.height/2)-13, 29, 26)];
    pg.text = pgT;
    pg.textColor = [UIColor whiteColor];
    pg.textAlignment = NSTextAlignmentCenter;
    UILabel *pj = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width-210),(cell.frame.size.height/2)-13, 26, 26)];
    pj.text = pjT;
    pj.textColor = [UIColor whiteColor];
    pj.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:points];
    [cell addSubview:gd];
    [cell addSubview:gc];
    [cell addSubview:gf];
    [cell addSubview:pp];
    [cell addSubview:pe];
    [cell addSubview:pg];
    [cell addSubview:pj];
    [cell addSubview:team];
    [cell addSubview:pos];
    cell.backgroundColor = [UIColor clearColor];
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
    cell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 100);
    cell.backgroundColor = [UIColor clearColor];
    if (self.event.pointsXQualified) {
        UITextView *info = [[UITextView alloc ]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
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
        info.font = [UIFont boldSystemFontOfSize:16];
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
    return 100.0;
}

- (void)rlData
{
    [self reloadBets];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.event.pointsXQualified)
    {
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
    self.navigationItem.leftBarButtonItem.enabled = NO;
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    if (!self.spinner.isAnimating) {
        [self.spinner startAnimating];
    }
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
    [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:NO];
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = NO;
    if (!self.spinner.isAnimating) {
        [self.spinner startAnimating];
    }
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
            
        }else if([dat isEqualToString:@"ERROR_ROUND_STARTED"])
        {
            
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
        [self.tableView clearsContextBeforeDrawing];
        [self.tableView reloadData];
        [self.spinner stopAnimating];
    }
    
    if (self.event.pointsXQualified) {
        self.tableView.allowsSelection = YES;
    }
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = YES;
}

- (void)reloadBets
{
    self.selectedTeams = [[NSMutableArray alloc] init];
    self.bets = [[NSMutableArray alloc] init];
    [self fetchBets];
}

@end
