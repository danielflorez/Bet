//
//  MTEEventsTableViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/8/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEEventsTableViewController.h"
#import "MTEBetEventTableViewController.h"
#import "MTECreateEventViewController.h"
#import "MTEMyInvitesTableViewController.h"
#import "MTEInviteViewController.h"



@interface MTEEventsTableViewController ()
@property (nonatomic, strong) NSMutableData *dataRecieved;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic) int match;

@end

@implementation MTEEventsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
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
    if (!self.matches) {
        self.matches = [[NSMutableArray alloc] init];
    }
    //self.canDisplayBannerAds = YES;
    self.events = [[NSMutableArray alloc] init];
    self.teams = [[MTEBetStore sharedStore] teams];
    self.bevc.canInvite = NO;
    UIEdgeInsets inset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.contentInset = inset;
    self.navigationItem.hidesBackButton = YES;
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    //[self reloadEvents];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    MTEEvent *ev = [self.events objectAtIndex:indexPath.row];
    UILabel *lblName = (UILabel *)[cell viewWithTag:100];
    UIButton *shareButton = (UIButton *)[cell viewWithTag:200];
    [shareButton addTarget:self action:@selector(fbShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [lblName setText:[ev name]];
    cell.backgroundColor = [UIColor clearColor];
    UIImage *bg = [[UIImage alloc] init];
    if (self.bevc.facebookLogin)
    {
        bg = [UIImage imageNamed:@"List_Field1"];
        shareButton.hidden = NO;
    }else
    {
        bg = [UIImage imageNamed:@"List_Field"];
        shareButton.hidden = YES;
    }
    UIGraphicsBeginImageContextWithOptions(cell.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, cell.frame.size.width, cell.frame.size.height-10)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.image = resultImage;
    lblName.textColor = [UIColor whiteColor];
    if (indexPath.row == [self.events count]-1) {
        UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, cell.frame.size.height-2, cell.frame.size.width, 2)];
        separatorLineView1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"List_line.png"]];
        [cell.contentView addSubview:separatorLineView1];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTEEvent *event = [_events objectAtIndex:indexPath.row];
    [self.bevc selectEvent:event];
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

-  (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 140);
    if ([self.events count] == 0) {
        UITextView *te = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        NSString *textLabel;
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        if([language isEqualToString:@"en"])
        {
            textLabel = @"Welcome to friendlybet, to start betting create a new event by clicking in the create button that is bellow or in the + button in the top right corner, or if you have pending invites click the invitation button to go to the window where you can accept them. To invite your facebook friends to join friendlybet click on the blue facebook button that is in the bottom";
        }
        else {
            textLabel = @"Bienvenido a friendlybet, para comenzar apostar crea un nuevo evento haciendo click en el boton de crear que se encuentra en la parte de abajo o en el boton + en la esquina superior derecha, o si tienes invitaciones pendientes haz click en el boton invitaciones para ir a la ventana donde puedes aceptarlas. Para invitar tus amigos de facebook a que se unan a friendly bet haz click en el boton azul de facebook que se encuentra en la parte de abajo.";
        }
        te.text = textLabel;
        te.backgroundColor = [UIColor clearColor];
        te.textColor = [UIColor whiteColor];
        [cell addSubview:te];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 140.0;
}

- (void)reloadEvents
{
    self.events = [[NSMutableArray alloc] init];
    self.matches = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    [self fetchEvents:self.email];
}


- (void)fetchEvents:(NSString *)email
{
    self.bevc.bbi.enabled = NO;
    self.bevc.canInvite = NO;
    self.match = 2;
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSString *post = [NSString stringWithFormat:@"&email=%@",email];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/test/events.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

- (void)fetchMember:(NSString *)email
{
    self.match = 3;
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSString *post = [NSString stringWithFormat:@"&email=%@",email];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/test/member.php"]]];
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
    if(self.match == 2)
    {
        NSDictionary *events = [NSJSONSerialization JSONObjectWithData:self.dataRecieved
                                                               options:0
                                                                 error:nil];
        [self readFromJSONObjectEvents:events];
    }else if(self.match ==3)
    {
        NSDictionary *member= [NSJSONSerialization JSONObjectWithData:self.dataRecieved
                                                               options:0
                                                                 error:nil];
        for (NSDictionary *match in [member objectForKey:@"Events"]) {
            self.memberID = match[@"ID"];
        }
    }
    self.bevc.bbi.enabled = YES;
    self.bevc.canInvite = YES;
}

- (void)readFromJSONObjectEvents:(NSDictionary *)jsonObject
{
    
    for (NSDictionary *item in [jsonObject objectForKey:@"Events"]) {
        MTEEvent *e = [[MTEEvent alloc] init];
        e.eventID = item[@"EventID"];
        e.name = item[@"Event"];
        e.memberID = item[@"Memberid"];
        self.memberID = item[@"Memberid"];
        e.teamID = item[@"TeamID"];
        NSString *pq = item[@"Pointsxqualified"];
        if ([pq isEqualToString:@"0"]) {
            e.pointsXQualified = NO;
        }else{
            e.pointsXQualified = YES;
        }
        NSString *gr = item[@"Groupphase"];
        if ([gr isEqualToString:@"1"]) {
            e.groupphase = YES;
        } else{
            e.groupphase = NO;
        }
        NSString *sixteen = item[@"Round16"];
        if ([sixteen isEqualToString:@"1"]) {
            e.roundsixteen = YES;
        } else{
            e.roundsixteen = NO;
        }
        NSString *quarter = item[@"Quarterfinals"];
        if ([quarter isEqualToString:@"1"]) {
            e.quarter = YES;
        } else{
            e.quarter = NO;
        }
        NSString *semi = item[@"Semifinals"];
        if ([semi isEqualToString:@"1"]) {
            e.semifinal = YES;
        } else{
            e.semifinal = NO;
        }
        NSString *final = item[@"Finals"];
        if ([final isEqualToString:@"1"]) {
            e.final = YES;
        } else{
            e.final = NO;
        }
        e.firstPrize = item[@"Firstprize"];
        e.secondPrize = item[@"Secondprize"];
        e.thirdPrize = item[@"Thirdprize"];
        e.eventTotalPrize = item[@"pozo"];
        e.entryFee = item[@"Entry_fee"];
        e.facebookLogin = self.bevc.facebookLogin;
        e.fbname = self.bevc.fbname;
        [self.events addObject:e];
    }
    [self fetchMember:self.email];
    [self.tableView reloadData];
    [self.spinner stopAnimating];
}

- (void)fbShareAction:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"is betting in the event";
        }
        else {
            title = @"esta participando en la polla";
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"%@ %@ %@",self.bevc.fbname,title,[self.events[indexPath.row] name]], @"name",
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
