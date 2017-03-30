//
//  MTEButtonEventViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 5/5/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEButtonEventViewController.h"
#import "MTEEventsTableViewController.h"
#import "MTEBetEventTableViewController.h"
#import "MTECreateEventViewController.h"
#import "MTEInviteViewController.h"
#import "MTEMyInvitesTableViewController.h"
#import "MTEInvite.h"
#import "MTETutorialViewController.h"

@interface MTEButtonEventViewController ()
@property (nonatomic, strong) MTEEventsTableViewController *etvc;
@property (nonatomic, strong) UIView *btView;
@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) UIButton *inviteButton;
@property (nonatomic, strong) UIButton *logoutButton;
@property (nonatomic, strong) UIButton *fbInviteButton;
@property (nonatomic, strong) UIBarButtonItem *tutorialButton;
@property (nonatomic, strong) NSString *inviteFacebook;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;
@property (nonatomic, strong) UILabel *badge;

@end

@implementation MTEButtonEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.interstitial_ = [[GADInterstitial alloc] init];
    self.interstitial_.adUnitID = @"ca-app-pub-8260074602621393/9232301662";
    [self.interstitial_ loadRequest:[GADRequest request]];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    if (!self.invites)
    {
        self.invites = [[NSMutableArray alloc] init];
    }
    UIImage *bg = [UIImage imageNamed:@"Background.jpg"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bg]];
    NSString *title;
    NSString *createTitle;
    NSString *inviteTitle;
    NSString *logoutTitle;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        title = @"List";
        createTitle = @"Create";
        inviteTitle = @"Invitations";
        logoutTitle = @"Logout";
        self.inviteFacebook = @"Invite your friends";
    }
    else {
        title = @"Listado";
        createTitle = @"Crear";
        inviteTitle = @"Invitaciones";
        logoutTitle = @"Salir";
        self.inviteFacebook = @"Invita a tus amigos";
    }
    self.navigationItem.title = title;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    self.etvc = [storyboard instantiateViewControllerWithIdentifier:@"events"];
    self.etvc.email = self.email;
    self.etvc.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width,4*(self.view.frame.size.height/5));
    self.etvc.tableView.backgroundColor = [UIColor clearColor];
    self.etvc.bevc = self;
    self.bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                             target:self
                                                             action:@selector(addNewEvent)];
    self.navigationItem.rightBarButtonItem = self.bbi;
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton = YES;
    [self.view addSubview:self.etvc.tableView];
    
    self.btView = [[UIView alloc] init];
    self.btView.frame = CGRectMake(0, 4*(self.view.frame.size.height/5), self.view.frame.size.width,(self.view.frame.size.height/5));
    self.createButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, 0, 200, 28)];
    [self.createButton setBackgroundImage:[UIImage imageNamed:@"Background_buttons.png"]
                                 forState:UIControlStateNormal];
    [self.createButton setTitle:createTitle
                       forState:UIControlStateNormal];
    [self.createButton addTarget:self
                          action:@selector(addNewEvent)
                forControlEvents:UIControlEventTouchUpInside];
    self.btView.backgroundColor = [UIColor clearColor];
    [self.btView addSubview:self.createButton];
    
    self.inviteButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, 29, 200, 28)];
    [self.inviteButton setBackgroundImage:[UIImage imageNamed:@"Background_buttons.png"]
                                 forState:UIControlStateNormal];
    [self.inviteButton setTitle:inviteTitle
                       forState:UIControlStateNormal];
    [self.inviteButton addTarget:self
                          action:@selector(inviteClick)
                forControlEvents:UIControlEventTouchUpInside];
    self.badge = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    UIImage *badgeBG = [UIImage imageNamed:@"badge.png"];
    UIGraphicsBeginImageContextWithOptions(self.badge.frame.size, NO, 0.f);
    [badgeBG drawInRect:CGRectMake(0.f, 0.f, self.badge.frame.size.width, self.badge.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.badge setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];
    self.badge.textColor = [UIColor whiteColor];
    self.badge.font = [UIFont boldSystemFontOfSize:11];
    self.badge.hidden = YES;
    self.badge.textAlignment = NSTextAlignmentCenter;
    [self.inviteButton addSubview:self.badge];
    [self.btView addSubview:self.inviteButton];
    if (self.facebookLogin)
    {
        self.loginView.frame = CGRectMake((self.view.frame.size.width/2)-100, 58, 140, 28);
        for (id obj in self.loginView.subviews)
        {
            if ([obj isKindOfClass:[UIButton class]])
            {
                UIButton * loginButton =  obj;
                
                UIImage *bg = [UIImage imageNamed:@"Background_button_2.png"];
                UIGraphicsBeginImageContextWithOptions(self.loginView.frame.size, NO, 0.f);
                [bg drawInRect:CGRectMake(0.f, 0.f, self.loginView.frame.size.width, self.loginView.frame.size.height)];
                UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                UIImage *loginImage = resultImage;
                [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
                [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
                [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
                [loginButton sizeToFit];
            }
            if ([obj isKindOfClass:[UILabel class]])
            {
                UILabel * loginLabel =  obj;
                loginLabel.text = logoutTitle;
                loginLabel.textAlignment = NSTextAlignmentCenter;
                loginLabel.frame = CGRectMake(0, 0, self.loginView.frame.size.width, self.loginView.frame.size.height);
            }
        }
        [self.btView addSubview:self.loginView];
    }else
    {
        self.logoutButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, 58, 140, 28)];
        [self.logoutButton setBackgroundImage:[UIImage imageNamed:@"Background_button_2.png"]
                                     forState:UIControlStateNormal];
        [self.logoutButton setTitle:logoutTitle
                           forState:UIControlStateNormal];
        [self.logoutButton addTarget:self
                              action:@selector(logout)
                    forControlEvents:UIControlEventTouchUpInside];
        [self.btView addSubview:self.logoutButton];
    }
    self.fbInviteButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)+40, 58, 60, 28)];
    [self.fbInviteButton setBackgroundImage:[UIImage imageNamed:@"fb.png"]
                                 forState:UIControlStateNormal];
    [self.fbInviteButton addTarget:self
                          action:@selector(fbInvite)
                forControlEvents:UIControlEventTouchUpInside];
    [self.btView addSubview:self.fbInviteButton];
    self.tutorialButton = [[UIBarButtonItem alloc] initWithTitle:@"Tutorial"
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(tutorialAction)];
    [self.navigationItem setLeftBarButtonItem:self.tutorialButton];
    [self.view addSubview:self.btView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadInvites];
    [self.etvc reloadEvents];
    [self.etvc.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNewEvent
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTECreateEventViewController *event = [storyboard instantiateViewControllerWithIdentifier:@"createEvent"];
    event.memberID = self.etvc.memberID;
    event.email = self.email;
    event.eventTVC = self.etvc;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    [self.navigationController pushViewController:event animated:YES];
}

- (void)inviteClick
{
    if (self.canInvite) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UITabBarController *invite = [storyboard instantiateViewControllerWithIdentifier:@"inviteTabbar"];
        UITabBarItem *tabBarItem =[[invite.viewControllers objectAtIndex:1] tabBarItem];
        tabBarItem.image = [[UIImage imageNamed:@"Invite_2_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *tabBarItem1 =[[invite.viewControllers objectAtIndex:0] tabBarItem];
        tabBarItem1.image = [[UIImage imageNamed:@"Invite_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        tabBarItem.selectedImage =[[UIImage imageNamed:@"Invite_1_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        tabBarItem1.selectedImage = [[UIImage imageNamed:@"Invite_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //event.email = self.emailTextField.text;
        MTEInviteViewController *ivc = [invite.viewControllers objectAtIndex:1];
        ivc.events = self.etvc.events;
        MTEMyInvitesTableViewController *mivc = [invite.viewControllers objectAtIndex:0];
        mivc.email = self.email;
        mivc.etvc = self.etvc;
        mivc.memberID = self.etvc.memberID;
        mivc.invites = self.invites;
        [self.navigationController pushViewController:invite
                                                        animated:YES];
    }
}

- (void)selectEvent:(MTEEvent *) event
{
    [self.interstitial_ presentFromRootViewController:self];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTEBetEventTableViewController *betvc = [storyboard instantiateViewControllerWithIdentifier:@"betEvent"];;
    betvc.event = event;
    [self.navigationController pushViewController:betvc animated:YES];
}

- (void)fetchInvites:(NSString *)email
{
    self.inviteButton.enabled = NO;
    self.createButton.enabled = NO;
    self.logoutButton.enabled = NO;
    self.tutorialButton.enabled = NO;
    self.bbi.enabled = NO;
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
    self.inviteButton.enabled = YES;
    self.createButton.enabled = YES;
    self.logoutButton.enabled = YES;
    self.tutorialButton.enabled = YES;
    self.bbi.enabled = YES;
    self.badge.text = [NSString stringWithFormat:@"%lu",(unsigned long)[self.invites count]];
    if ([self.invites count] > 0) {
        self.badge.hidden = NO;
    }else
    {
        self.badge.hidden = YES;
    }
}

- (void)reloadInvites
{
    self.invites = [[NSMutableArray alloc] init];
    [self fetchInvites:self.email];
}

- (void)logout
{
    self.lvc.passTextField.text = @"";
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fbInvite
{
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                  message:NSLocalizedString(@"FBinviteMessage", nil)
                                                    title:self.inviteFacebook
                                               parameters:nil
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {}
     ];

}

- (void)tutorialAction
{
    MTETutorialViewController *t = [[MTETutorialViewController alloc] init];
    [self.navigationController pushViewController:t animated:YES];
}

@end
