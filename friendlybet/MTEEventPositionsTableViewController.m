//
//  MTEEventPositionsTableViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/20/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEEventPositionsTableViewController.h"

@interface MTEEventPositionsTableViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;

@end

@implementation MTEEventPositionsTableViewController

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
    NSString *title;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        title = @"Standings";
    }
    else {
        title = @"Tabla de Posiciones";
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
    [self reloadMembers];
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
    return [self.members count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    MTEMember *m = [self.members objectAtIndex:indexPath.row];
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
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, (cell.frame.size.height/2)-19, 150, 38)];
    nameLabel.text = m.name;
    UILabel *pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 140, (cell.frame.size.height/2)-12, 60, 24)];
    pointsLabel.text =  m.pointsActualEvent;
    [pointsLabel setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *prizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 80, (cell.frame.size.height/2)-12, 80, 24)];
    
    if (indexPath.row < 3) {
        float prize = [self.event.eventTotalPrize intValue];
        float perFirst = [self.event.firstPrize intValue];
        float perSecond = [self.event.secondPrize intValue];
        float perThird = [self.event.thirdPrize intValue];
        float prizePerPlace = 0;
        if (indexPath.row == 0)
        {
            prizePerPlace = prize * (perFirst/100);
        } else if(indexPath.row == 1)
        {
            prizePerPlace = prize * (perSecond/100);
        }else if(indexPath.row == 2)
        {
            prizePerPlace = prize * (perThird/100);
        }
        prizeLabel.text = [NSString stringWithFormat:@"%ld",(long)prizePerPlace];
    }
    
    prizeLabel.textColor = [UIColor whiteColor];
    prizeLabel.textAlignment = NSTextAlignmentCenter;
    
    nameLabel.textColor = [UIColor whiteColor];
    pointsLabel.textColor = [UIColor whiteColor];
    [cell addSubview:pointsLabel];
    [cell addSubview:posButton];
    [cell addSubview:nameLabel];
    [cell addSubview:prizeLabel];
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
    [cell addSubview:self.bannerView_];
    cell.frame = CGRectMake(0, 0,self.tableView.frame.size.width, 80);
    UILabel *pos = [[UILabel alloc] initWithFrame:CGRectMake(6, (cell.frame.size.height)-30, 30, 30)];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(44, (cell.frame.size.height)-30, 150, 30)];
    UILabel *points = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 140, (cell.frame.size.height)-30, 60, 30)];
    UILabel *prize = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width - 80, (cell.frame.size.height)-30, 80, 30)];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *nameT;
    NSString *pointsT;
    NSString *prizet;
    if([language isEqualToString:@"en"])
    {
        nameT = @"Name";
        pointsT = @"Points";
        prizet = @"Prize";
    }
    else {
        nameT = @"Nombre";
        pointsT = @"Puntos";
        prizet = @"Premio";
    }
    pos.text = @"Pos";
    name.text = nameT;
    points.text = pointsT;
    prize.text = prizet;
    pos.textColor = [UIColor whiteColor];
    name.textColor = [UIColor whiteColor];
    points.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    prize.textColor = [UIColor whiteColor];
    prize.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:points];
    [cell addSubview:name];
    [cell addSubview:pos];
    [cell addSubview:prize];
    UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 277, 58)];
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

- (void) reloadMembers
{
    self.members = [[NSMutableArray alloc] init];
    [self fetchMembers:self.event.eventID];
}

- (void)fetchMembers:(NSString *)pevent
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
    NSString *post = [NSString stringWithFormat:@"&pevent=%@",pevent];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/test/eventPosition.php"]]];
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
    NSDictionary *memb= [NSJSONSerialization JSONObjectWithData:self.dataRecieved
                                                        options:0
                                                          error:nil];
    for (NSDictionary *item in [memb objectForKey:@"Members"]) {
        MTEMember *m = [[MTEMember alloc] init];
        m.memberID = item[@"IdMember"];
        m.exactScore = item[@"exact_score"];
        m.teamScore = item[@"team_score"];
        m.winner = item[@"winner"];
        m.pointsActualEvent = item[@"PE_SCORE"];
        m.name = item[@"userName"];
        m.email = item[@"email"];
        [self.members addObject:m];
    }
    [self.spinner stopAnimating];
    [self.tableView reloadData];
    self.navigationItem.leftBarButtonItem.enabled = YES;
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
