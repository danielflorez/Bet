//
//  MTEGroupMatchesTableViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/9/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEGroupMatchesTableViewController.h"
#import "MTEBetViewController.h"
#import "MTEBet.h"


@interface MTEGroupMatchesTableViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;
@end

@implementation MTEGroupMatchesTableViewController

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
    if (!_matches) {
        _matches = [[NSMutableArray alloc] init];
    }
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.jpg"]];
    [self.tableView setBackgroundView:bg];
    UIEdgeInsets inset = UIEdgeInsetsMake(69, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.bets = [[NSMutableArray alloc] init];
    [self fetchBets];
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                    action:@selector(didTapAnywhere:)];
//    [self.view addGestureRecognizer:tapRecognizer];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    [self.tableView reloadData];
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
    NSString *result;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        result = @"Result";
    }
    else
    {
        result = @"Resultado";
    }
    MTEMatch *match = [self.matches objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 91)];
    cell.backgroundColor = [UIColor clearColor];
    
    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 91, cell.frame.size.width, 2)];
    separatorLineView2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Line.png"]];
    [cell.contentView addSubview:separatorLineView2];
    
    UILabel *score1 = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)-26,7, 20, 20)];
    UIImage *img = [UIImage imageNamed:@"Match_circle_1.png"];
    CGSize imgSize = score1.frame.size;
    UIGraphicsBeginImageContext( imgSize );
    [img drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    score1.backgroundColor = [UIColor colorWithPatternImage:newImage];
    [score1 setTextAlignment:NSTextAlignmentCenter];
    score1.textColor = [UIColor whiteColor];
    
    UILabel *score2 = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)+4,7, 20, 20)];
    UIImage *img1 = [UIImage imageNamed:@"Match_circle_1.png"];
    CGSize imgSize1 = score2.frame.size;
    UIGraphicsBeginImageContext(imgSize1);
    [img1 drawInRect:CGRectMake(0,0,imgSize1.width,imgSize1.height)];
    UIImage *newImage1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    score2.backgroundColor = [UIColor colorWithPatternImage:newImage1];
    [score2 setTextAlignment:NSTextAlignmentCenter];
    score2.textColor = [UIColor whiteColor];
    [score1 setFont:[UIFont systemFontOfSize:13]];
    [score2 setFont:[UIFont systemFontOfSize:13]];
    
    UIImageView *flag1 = [[UIImageView alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)-57, 3, 28, 28)];
    flag1.image = [UIImage imageNamed:[[match team1] flag]];
    
    
    UIImageView *flag2 = [[UIImageView alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)+26, 3, 28, 28)];
    flag2.image = [UIImage imageNamed:[[match team2] flag]];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)-2, 10, 2, 14)];
    separatorLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Match_divider_1.png"]];
    
    for (MTEBet *bet in self.bets) {
        if ([bet.matchID isEqualToString:match.matchID]) {
            [score1 setText:bet.score1];
            [score2 setText:bet.score2];
        }
    }
    
    UILabel *team1 = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)-157, 5, 96, 24)];
    UILabel *team2 = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)+56, 5, 96, 24)];
    
    [team1 setTextColor:[UIColor whiteColor]];
    [team2 setTextColor:[UIColor whiteColor]];
    [team1 setText:[[match team1] name]];
    [team2 setText:[[match team2] name]];
    [team1 setFont:[UIFont systemFontOfSize:13]];
    [team2 setFont:[UIFont systemFontOfSize:13]];
    [team1 setTextAlignment:NSTextAlignmentRight];
    
    UITextField *date = [[UITextField alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)-60, 33, 60, 20)];
    UITextField *hour = [[UITextField alloc] initWithFrame:CGRectMake((cell.frame.size.width/2), 33, 60, 20)];
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
    hour.font = [UIFont systemFontOfSize:13];
    date.textColor = [UIColor whiteColor];
    date.font = [UIFont systemFontOfSize:13];
    date.enabled = NO;
    hour.enabled = NO;
    if (self.event.facebookLogin)
    {
        UIButton *share = [[UIButton alloc] init];
        share.frame = CGRectMake((cell.frame.size.width/2)+69, 38, 69, 26);
        [share setBackgroundImage:[UIImage imageNamed:@"fbshare.png"]
                            forState:UIControlStateNormal];
        [share addTarget:self action:@selector(fbShareAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:share];
    }
    UILabel *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)-35, 50, 70, 20)];
    resultLabel.text = result;
    resultLabel.textAlignment = NSTextAlignmentCenter;
    resultLabel.textColor = [UIColor whiteColor];
    resultLabel.font = [UIFont systemFontOfSize:13];
    
    UILabel *result1 = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)-26,68, 20, 20)];
    UIImage *img2 = [UIImage imageNamed:@"Match_Circle_2.png"];
    CGSize imgSize2 = result1.frame.size;
    UIGraphicsBeginImageContext(imgSize2);
    [img2 drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage *newImage2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    result1.backgroundColor = [UIColor colorWithPatternImage:newImage2];
    [result1 setTextAlignment:NSTextAlignmentCenter];
    result1.textColor = [UIColor whiteColor];
    
    UILabel *result2 = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)+4,68, 20, 20)];
    UIImage *img3 = [UIImage imageNamed:@"Match_Circle_2.png"];
    CGSize imgSize3 = result2.frame.size;
    UIGraphicsBeginImageContext(imgSize3);
    [img3 drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage *newImage3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    result2.backgroundColor = [UIColor colorWithPatternImage:newImage3];
    [result2 setTextAlignment:NSTextAlignmentCenter];
    result2.textColor = [UIColor whiteColor];
    [result1 setFont:[UIFont systemFontOfSize:13]];
    [result2 setFont:[UIFont systemFontOfSize:13]];
    UIView* separatorLineView3 = [[UIView alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)-2, 71, 2, 14)];
    separatorLineView3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Match_divider_2.png"]];
    if (![match.score1 isKindOfClass:[NSNull class]]&&![match.score2 isKindOfClass:[NSNull class]])
    {
        [result1 setText:match.score1];
        [result2 setText:match.score2];
    }
    
    [cell addSubview:score1];
    [cell addSubview:score2];
    [cell addSubview:flag1];
    [cell addSubview:flag2];
    [cell addSubview:separatorLineView];
    [cell addSubview:team1];
    [cell addSubview:team2];
    [cell addSubview:date];
    [cell addSubview:hour];
    [cell addSubview:resultLabel];
    [cell addSubview:result1];
    [cell addSubview:result2];
    [cell addSubview:separatorLineView3];
    
    if (indexPath.row == 0)
    {
        UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 2)];
        separatorLineView1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Line.png"]];
        [cell.contentView addSubview:separatorLineView1];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTEBetViewController *bvc = [[MTEBetViewController alloc] init];
    bvc.match = [self.matches objectAtIndex:indexPath.row];
    bvc.event = self.event;
    bvc.gmvc = self;
    [self.navigationController pushViewController:bvc
                                         animated:YES];
//    [self.navigationController presentViewController:bvc
//                                            animated:YES
//                                          completion:nil];
}

- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 91.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 91.0f;
}

- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 91)];
    return cell;
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
- (void)fetchBets
{
    self.tableView.allowsSelection = NO;
    [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:NO];
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = NO;
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    if (!self.dataRecieved) {
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
    [self.spinner stopAnimating];
    self.tableView.allowsSelection = YES;
    [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:YES];
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = YES;
    [self.tableView reloadData];
}

- (void)reloadBets
{
    self.bets = [[NSMutableArray alloc] init];
    [self fetchBets];
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
