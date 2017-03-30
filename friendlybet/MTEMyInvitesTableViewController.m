//
//  MTEMyInvitesTableViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/17/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEMyInvitesTableViewController.h"
#import "MTEInvite.h"
#import "MTEAcceptInvitesViewController.h"


@interface MTEMyInvitesTableViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;
@end

@implementation MTEMyInvitesTableViewController

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
    if (!self.invites) {
        self.invites = [[NSMutableArray alloc] init];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadInvites];
    [super viewWillAppear:animated];
    NSString *title;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        title = @"Invitations";
    }
    else {
        title = @"Invitaciones";
    }
    self.tabBarController.navigationItem.title = title;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchInvites:(NSString *)email
{
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = NO;
    [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:FALSE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSString *post = [NSString stringWithFormat:@"&email=%@",email];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/test/invites.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    [conn start];
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
    NSDictionary *invites = [NSJSONSerialization JSONObjectWithData:self.dataRecieved
                                                           options:0
                                                             error:nil];
    for (NSDictionary *item in [invites objectForKey:@"Invites"]) {
        MTEInvite *invite = [[MTEInvite alloc] init];
        invite.peID = item[@"peID"];
        invite.peName = item[@"peName"];
        invite.memberName = item[@"memberName"];
        invite.memberEmail = item[@"memberEmail"];
        [self.invites addObject:invite];
    }
    [self.tableView reloadData];
    [self.spinner stopAnimating];
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = YES;
    [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:TRUE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
}

- (void)reloadInvites
{
    self.invites = [[NSMutableArray alloc] init];
    [self fetchInvites:self.email];
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
    return [self.invites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"invite"
                                                            forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    UILabel *lblName = (UILabel *)[cell viewWithTag:100];
    UIImage *bg = [UIImage imageNamed:@"List_Field"];
    UIGraphicsBeginImageContextWithOptions(cell.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, cell.frame.size.width, cell.frame.size.height-10)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.image = resultImage;
    
    [lblName setText:[[self.invites objectAtIndex:indexPath.row] peName]];
    lblName.textColor = [UIColor whiteColor];
    if (indexPath.row == [self.invites count]-1) {
        UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, cell.frame.size.height-2, cell.frame.size.width, 2)];
        separatorLineView1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"List_line.png"]];
        [cell.contentView addSubview:separatorLineView1];
    }
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
    UITableViewCell *cell = (UITableViewCell *) sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MTEAcceptInvitesViewController *aivc = [segue destinationViewController];
    aivc.invite = [self.invites objectAtIndex:indexPath.row];
    aivc.mivc = self;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
