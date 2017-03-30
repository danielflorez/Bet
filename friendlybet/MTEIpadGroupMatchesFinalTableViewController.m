//
//  MTEIpadGroupMatchesFinalTableViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 5/6/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEIpadGroupMatchesFinalTableViewController.h"
#import "MTEBet.h"
#import "MTEIpadBetFinalViewController.h"
#import "MTEBetStore.h"

@interface MTEIpadGroupMatchesFinalTableViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;
@property (nonatomic) int match;

@end

@implementation MTEIpadGroupMatchesFinalTableViewController

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
    [self.bannerView_ loadRequest:[GADRequest request]];
    if (!_matches) {
        _matches = [[NSMutableArray alloc] init];
    }
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.jpg"]];
    [self.tableView setBackgroundView:bg];
    self.teams = [[MTEBetStore sharedStore] teams];
    UIEdgeInsets inset = UIEdgeInsetsMake(69, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.bets = [[NSMutableArray alloc] init];
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.center = CGPointMake(self.tableView.frame.size.width/2, self.tableView.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *title;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        title = @"Matches";
    }
    else {
        title = @"Partidos";
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
    return [self.matches count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [cell setFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 108)];
    MTEMatch *match = [self.matches objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, (cell.frame.size.height)-2, cell.frame.size.width, 2)];
    separatorLineView2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Line.png"]];
    [cell.contentView addSubview:separatorLineView2];
    UIImageView *flag1 = [[UIImageView alloc] initWithFrame:CGRectMake((cell.frame.size.width/2) - 76, 1, 32, 32)];
    UILabel *team1 = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width/2) - 231, 4, 150, 26)];
    [team1 setTextColor:[UIColor whiteColor]];
    [team1 setText:[[match team1] name]];
    [team1 setTextAlignment:NSTextAlignmentRight];
    [flag1 setImage:[UIImage imageNamed:[[match team1] flag]]];
    UILabel *score1 = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width/2) - 36, 4, 26, 26)];
    [cell addSubview:flag1];
    [cell addSubview:team1];
    UIImage *img = [UIImage imageNamed:@"Match_Circle_1.png"];
    CGSize imgSize = score1.frame.size;
    UIGraphicsBeginImageContext( imgSize );
    [img drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    score1.backgroundColor = [UIColor colorWithPatternImage:newImage];
    [score1 setTextAlignment:NSTextAlignmentCenter];
    score1.textColor = [UIColor whiteColor];
    UIImageView *flag2 =[[UIImageView alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)+44,1, 32, 32)];
    UILabel *team2 = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)+81, 4, 150, 26)];
    [team2 setTextColor:[UIColor whiteColor]];
    [team2 setText:[[match team2] name]];
    [flag2 setImage:[UIImage imageNamed:[[match team2] flag]]];
    UILabel *score2 = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width/2) + 10, 4, 26, 26)];
    UIImage *img1 = [UIImage imageNamed:@"Match_Circle_1.png"];
    CGSize imgSize1 = score2.frame.size;
    UIGraphicsBeginImageContext(imgSize1);
    [img1 drawInRect:CGRectMake(0,0,imgSize1.width,imgSize1.height)];
    UIImage *newImage1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    score2.backgroundColor = [UIColor colorWithPatternImage:newImage1];
    [score2 setTextAlignment:NSTextAlignmentCenter];
    score2.textColor = [UIColor whiteColor];
    [cell addSubview:flag2];
    [cell addSubview:team2];
    UILabel *result1 = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width/2) - 36, 76, 26, 26)];
    [result1 setTextColor:[UIColor whiteColor]];
    UIImage *img2 = [UIImage imageNamed:@"Match_Circle_2.png"];
    CGSize imgSize2 = result1.frame.size;
    UIGraphicsBeginImageContext(imgSize2);
    [img2 drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage *newImage2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    result1.backgroundColor = [UIColor colorWithPatternImage:newImage2];
    [result1 setTextAlignment:NSTextAlignmentCenter];
    result1.textColor = [UIColor whiteColor];
    UILabel *result2 = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width/2) + 10, 76, 26, 26)];
    [result2 setTextColor:[UIColor whiteColor]];
    UIImage *img3 = [UIImage imageNamed:@"Match_Circle_2.png"];
    CGSize imgSize3 = result2.frame.size;
    UIGraphicsBeginImageContext(imgSize3);
    [img3 drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage *newImage3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    result2.backgroundColor = [UIColor colorWithPatternImage:newImage3];
    [result2 setTextAlignment:NSTextAlignmentCenter];
    result2.textColor = [UIColor whiteColor];
    if (![match.score1 isKindOfClass:[NSNull class]]&&![match.score2 isKindOfClass:[NSNull class]])
    {
        [result1 setText:match.score1];
        [result2 setText:match.score2];
    }
    [cell addSubview:result1];
    [cell addSubview:result2];
    if (self.event.facebookLogin)
    {
        UIButton *share = [[UIButton alloc] init];
        share.frame = CGRectMake((cell.frame.size.width/2)+88, 38, 69, 26);
        [share setBackgroundImage:[UIImage imageNamed:@"fbshare.png"]
                         forState:UIControlStateNormal];
        [share addTarget:self action:@selector(fbShareAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:share];
    }
    UITextField *date = [[UITextField alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)-100, 30, 100, 30)];
    UITextField *hour = [[UITextField alloc] initWithFrame:CGRectMake((cell.frame.size.width/2), 30, 100, 30)];
    UIImageView *div = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, 10, 10)];
    div.image = [UIImage imageNamed:@"Date_icon.png"];
    UIImageView *hiv = [[UIImageView alloc] initWithFrame:CGRectMake(2, 5, 10, 10)];
    hiv.image = [UIImage imageNamed:@"Time_icon.png"];
    hour.leftView = hiv;
    hour.leftViewMode = UITextFieldViewModeAlways;
    date.leftView = div;
    date.leftViewMode = UITextFieldViewModeAlways;
    NSDateFormatter *dateFormatter  =   [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM-dd"];
    [date setText:[dateFormatter stringFromDate:[match date]]];
    NSDateFormatter *dateFormatter1  =   [[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"HH:mm"];
    [date setText:[dateFormatter stringFromDate:[match date]]];
    [hour setText:[dateFormatter1 stringFromDate:[match date]]];
    hour.textColor = [UIColor whiteColor];
    date.textColor = [UIColor whiteColor];
    date.enabled = NO;
    hour.enabled = NO;
    [cell addSubview:date];
    [cell addSubview:hour];
    for (MTEBet *bet in self.bets)
    {
        if ([bet.matchID isEqualToString:match.matchID]) {
            [score1 setText:bet.score1];
            [score2 setText:bet.score2];
        }
    }
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)-2, 7, 3, 20)];
    separatorLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Match_divider_1.png"]];
    
    UIView* separatorLineView3 = [[UIView alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)-2, 80, 3, 20)];
    separatorLineView3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Match_divider_2.png"]];
    
    if (![match.score1 isKindOfClass:[NSNull class]]&&![match.score2 isKindOfClass:[NSNull class]])
    {
        [result1 setText:match.score1];
        [result2 setText:match.score2];
    }
    [cell addSubview:score1];
    [cell addSubview:score2];
    [cell addSubview:separatorLineView];
    [cell addSubview:separatorLineView3];
    UILabel *resultTitle = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)-50, 50, 100, 26)];
    resultTitle.backgroundColor = [UIColor clearColor];
    [resultTitle setTextColor:[UIColor whiteColor]];
    [resultTitle setTextAlignment:NSTextAlignmentCenter];
    if (indexPath.row == 0)
    {
        UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 2)];
        separatorLineView1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Line.png"]];
        [cell.contentView addSubview:separatorLineView1];
    }
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *title;
    if([language isEqualToString:@"en"])
    {
        title = @"Result";
    }
    else {
        title = @"Resultado";
    }
    resultTitle.text = title;
    [cell addSubview:resultTitle];
    //    UIImageView *backG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Row.png"]];
    //    cell.backgroundView = backG;
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTEIpadBetFinalViewController *bvc = [[MTEIpadBetFinalViewController alloc] init];
    bvc.match = [self.matches objectAtIndex:indexPath.row];
    bvc.event = self.event;
    bvc.gmvc = self;
    [self.navigationController pushViewController:bvc
                                         animated:YES];
    //[self.ipvc betMatch:[self.matches objectAtIndex:indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108.0f;
}

- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [cell setFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90)];
    [cell addSubview:self.bannerView_];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90.0;
}

- (void)fetchBets
{
    self.match = 0;
    self.tableView.allowsSelection = NO;
    [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:FALSE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:FALSE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:FALSE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:FALSE];
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = NO;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    if (!self.dataRecieved)
    {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSString *post = [NSString stringWithFormat:@"&id_member=%@&id_private_event=%@",self.event.memberID,self.event.eventID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/test/bet.php"]]];
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
    if (self.match == 0)
    {
        NSDictionary *bets= [NSJSONSerialization JSONObjectWithData:self.dataRecieved
                                                            options:0
                                                              error:nil];
        for (NSDictionary *item in [bets objectForKey:@"Bets"])
        {
            MTEBet *bet = [[MTEBet alloc] init];
            bet.matchID = item[@"IDMatch"];
            bet.score1 = item[@"SCORE1"];
            bet.score2 = item[@"SCORE2"];
            bet.checked = item[@"checked"];
            bet.points = item[@"POINTS"];
            [self.bets addObject:bet];
        }
        [_spinner stopAnimating];
        [self fetchMatches];
    }
    if (self.match == 1)
    {
        NSMutableArray *tempMatches = self.matches;
        self.matches = [[NSMutableArray alloc] init];
        NSDictionary *matches= [NSJSONSerialization JSONObjectWithData:self.dataRecieved
                                                               options:0
                                                                 error:nil];
        for (NSDictionary *match in [matches objectForKey:@"Match"])
        {
            MTEMatch *m = [[MTEMatch alloc] init];
            m.matchID = match[@"Matchid"];
            m.roundID = match[@"Round"];
            m.order = match[@"Order"];
            m.score1 = match[@"score_team1"];
            m.score2 = match[@"score_team2"];
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
            for (MTEMatch *m1 in tempMatches)
            {
                if ([m.matchID isEqualToString:m1.matchID])
                {
                    [self.matches addObject:m];
                }
            }
        }
        self.matches = tempMatches;
        [self.tableView reloadData];
        
    }
    self.tableView.allowsSelection = YES;
    [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:TRUE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:TRUE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:TRUE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:4]setEnabled:TRUE];
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = YES;
}

- (void)reloadBets
{
    self.bets = [[NSMutableArray alloc] init];
    [self fetchBets];
}

- (void)fetchMatches
{
    self.match = 1;
    if (!self.dataRecieved)
    {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSString *requestString = @"http://www.mangostatecnologia.com/secureLogin/test/matches.php";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:req delegate:self];
    [connection start];
}

- (void)fbShareAction:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        MTEMatch *match = [self.matches objectAtIndex:indexPath.row];
        NSString *score1;
        NSString *score2;
        for (MTEBet *bet in self.bets) {
            if ([bet.matchID isEqualToString:match.matchID]) {
                score1 = bet.score1;
                score2 = bet.score2;
            }
        }
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"bet ";
        }
        else {
            title = @"aposto ";
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@",self.event.fbname,title,match.team1.name,score1,match.team2.name,score2], @"name",
                                       @"http://mangostatecnologia.com/friendlybet", @"link",
                                       @"http://mangostatecnologia.com/pollamundial/wp-content/uploads/2014/05/Login_Logo1.png", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

@end
