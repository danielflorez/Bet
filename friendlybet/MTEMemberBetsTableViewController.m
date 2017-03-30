//
//  MTEMemberBetsTableViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 6/6/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEMemberBetsTableViewController.h"
#import "MTEBet.h"

@interface MTEMemberBetsTableViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;

@end

@implementation MTEMemberBetsTableViewController

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
    if (!self.bets) {
        self.bets = [[NSMutableArray alloc] init];
    }
    self.bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    self.bannerView_.adUnitID = @"ca-app-pub-8260074602621393/7755568460";
    self.bannerView_.rootViewController = self;
    [self.bannerView_ loadRequest:[GADRequest request]];
    NSString *title;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        title = @"Bets";
    }
    else {
        title = @"Apuestas";
    }
    self.navigationItem.title = title;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,17,25);
    [button setBackgroundImage:[UIImage imageNamed:@"Arrow_2.png"] forState:UIControlStateNormal];
    
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.jpg"]];
    [self.tableView setBackgroundView:bg];
    self.tableView.allowsSelection = NO;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    MTEBet *bet = [self.bets objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, (cell.frame.size.height)-30, 100, 30)];
    UILabel *score1 = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 200, (cell.frame.size.height)-30, 100, 30)];
    UILabel *score2 = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 100, (cell.frame.size.height)-30, 100, 30)];
    name.textColor = [UIColor whiteColor];
    score1.textColor = [UIColor whiteColor];
    score2.textColor = [UIColor whiteColor];
    name.text = bet.userName;
    score1.text = bet.score1;
    score2.text = bet.score2;
    [score1 setTextAlignment:NSTextAlignmentCenter];
    [score2 setTextAlignment:NSTextAlignmentCenter];
    [cell addSubview:name];
    [cell addSubview:score1];
    [cell addSubview:score2];
    if (indexPath.row == 0) {
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 2)];
        separatorLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Line.png"]];
        [cell.contentView addSubview:separatorLineView];
    }
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height, cell.frame.size.width, 2)];
    separatorLineView1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Line.png"]];
    [cell.contentView addSubview:separatorLineView1];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.frame = CGRectMake(0, 0,self.tableView.frame.size.width, 80);
    [cell addSubview:self.bannerView_];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, (cell.frame.size.height)-30, 100, 30)];
    UILabel *team1 = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 200, (cell.frame.size.height)-30, 100, 30)];
    UILabel *team2 = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 100, (cell.frame.size.height)-30, 100, 30)];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *nameT;
    if([language isEqualToString:@"en"])
    {
        nameT = @"Name";
    }
    else {
        nameT = @"Nombre";
    }
    name.text = nameT;
    name.textColor = [UIColor whiteColor];
    team1.textColor = [UIColor whiteColor];
    team2.textColor = [UIColor whiteColor];
    team1.text = self.match.team1.name;
    team2.text = self.match.team2.name;
    [team1 setTextAlignment:NSTextAlignmentCenter];
    [team2 setTextAlignment:NSTextAlignmentCenter];
    cell.backgroundColor = [UIColor clearColor];
    [cell addSubview:name];
    [cell addSubview:team1];
    [cell addSubview:team2];
    UIImageView *av = [[UIImageView alloc] initWithFrame:cell.frame];
    av.backgroundColor = [UIColor clearColor];
    av.opaque = NO;
    av.image = [UIImage imageNamed:@"Table_Background.png"];
    cell.backgroundView = av;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

- (void) reloadBets
{
    self.bets = [[NSMutableArray alloc] init];
    [self fetchBets];
}

- (void)fetchBets
{
    self.navigationItem.leftBarButtonItem.enabled = NO;
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSString *post = [NSString stringWithFormat:@"&id_match=%@&id_private_event=%@",self.match.matchID,self.event.eventID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/test/bet_all_members.php"]]];
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
        bet.userName = item[@"NAME"];
        bet.score1 = item[@"SCORE1"];
        bet.score2 = item[@"SCORE2"];
        bet.checked = item[@"checked"];
        bet.points = item[@"POINTS"];
        [self.bets addObject:bet];
    }
    [self.spinner stopAnimating];
    [self.tableView reloadData];
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

@end
