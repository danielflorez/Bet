//
//  MTEIpadAcceptInvitesViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/22/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEIpadAcceptInvitesViewController.h"

@interface MTEIpadAcceptInvitesViewController ()
@property (nonatomic) BOOL acceptInvite;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;
@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) UIButton *rejectButton;

@end

@implementation MTEIpadAcceptInvitesViewController

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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,17,25);
    [button setBackgroundImage:[UIImage imageNamed:@"Arrow_2.png"] forState:UIControlStateNormal];
    
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    UIImage *bg = [UIImage imageNamed:@"Background.jpg"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bg]];
    NSString *eventTitle;
    NSString *acceptTitle;
    NSString *rejectTitle;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        eventTitle = @"EVENT";
        acceptTitle = @"Accept";
        rejectTitle = @"Reject";
    }
    else {
        eventTitle = @"EVENTO";
        acceptTitle = @"Aceptar";
        rejectTitle = @"Rechazar";
    }
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, self.view.frame.size.height/6)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Invite_Mail_field.png"]];
    UILabel *eventTLabel = [[UILabel alloc] initWithFrame:CGRectMake((topView.frame.size.width/2)-50, (topView.frame.size.height/2)-40, 100, 30)];
    eventTLabel.text = eventTitle;
    eventTLabel.textColor = [UIColor whiteColor];
    eventTLabel.backgroundColor = [UIColor clearColor];
    eventTLabel.textAlignment = NSTextAlignmentCenter;
    eventTLabel.font = [UIFont systemFontOfSize:24];
    UIImageView *ball1 = [[UIImageView alloc] initWithFrame:CGRectMake((topView.frame.size.width/2)-100, (topView.frame.size.height/2)-40, 30, 30)];
    ball1.image = [UIImage imageNamed:@"Invite_ball.png"];
    UIImageView *ball2 = [[UIImageView alloc] initWithFrame:CGRectMake((topView.frame.size.width/2)+62, (topView.frame.size.height/2)-40, 30, 30)];
    ball2.image = [UIImage imageNamed:@"Invite_ball.png"];
    UILabel *evName = [[UILabel alloc] initWithFrame:CGRectMake((topView.frame.size.width/2)-100, (topView.frame.size.height/2)+20, 200, 30)];
    evName.text = self.invite.peName;
    evName.textColor = [UIColor whiteColor];
    evName.backgroundColor = [UIColor clearColor];
    evName.textAlignment = NSTextAlignmentCenter;
    evName.font = [UIFont systemFontOfSize:24];
    [topView addSubview:eventTLabel];
    [topView addSubview:ball1];
    [topView addSubview:ball2];
    [topView addSubview:evName];
    
    UIView *middleView = [[UIView alloc] init];
    middleView.frame = CGRectMake(0, 2*(self.view.frame.size.height/6), self.view.frame.size.width, self.view.frame.size.height/6);
    middleView.backgroundColor = [UIColor clearColor];
    UIImageView *userIm = [[UIImageView alloc] initWithFrame:CGRectMake((middleView.frame.size.width/2)-10, (middleView.frame.size.height/2)-68, 20, 20)];
    userIm.image = [UIImage imageNamed:@"User_icon_2.png"];
    UILabel *eventOwner = [[UILabel alloc] initWithFrame:CGRectMake((middleView.frame.size.width/2)-200, (middleView.frame.size.height/2)-40, 400, 30)];
    eventOwner.text = self.invite.memberName;
    eventOwner.textAlignment = NSTextAlignmentCenter;
    eventOwner.font = [UIFont systemFontOfSize:24];
    eventOwner.textColor = [UIColor whiteColor];
    UIImageView *emailIm = [[UIImageView alloc] initWithFrame:CGRectMake((middleView.frame.size.width/2)-10, (middleView.frame.size.height/2)+10, 20, 20)];
    emailIm.image = [UIImage imageNamed:@"Mail_icon_2.png"];
    UILabel *email = [[UILabel alloc] initWithFrame:CGRectMake((middleView.frame.size.width/2)-200, (middleView.frame.size.height/2)+36, 400, 30)];
    email.text = self.invite.memberEmail;
    email.textAlignment = NSTextAlignmentCenter;
    email.textColor = [UIColor whiteColor];
    email.font = [UIFont systemFontOfSize:24];
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, middleView.frame.size.height-2, middleView.frame.size.width, 2)];
    separatorLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Line.png"]];
    [middleView addSubview:eventOwner];
    [middleView addSubview:email];
    [middleView addSubview:userIm];
    [middleView addSubview:emailIm];
    [middleView addSubview:separatorLineView];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0,(self.view.frame.size.height/2), self.view.frame.size.width,2*(self.view.frame.size.height/2));
    self.acceptButton = [[UIButton alloc] init];
    self.acceptButton.frame =  CGRectMake((bottomView.frame.size.width/2)-200, 20, 400, 40);
    [self.acceptButton setBackgroundImage:[UIImage imageNamed:@"Background_buttons.png"]
                                 forState:UIControlStateNormal];
    [self.acceptButton setTitle:acceptTitle
                       forState:UIControlStateNormal];
    [self.acceptButton addTarget:self
                          action:@selector(acceptAction)
                forControlEvents:UIControlEventTouchUpInside];
    self.rejectButton = [[UIButton alloc] initWithFrame:CGRectMake((bottomView.frame.size.width/2)-200, 75, 400, 40)];
    [self.rejectButton setBackgroundImage:[UIImage imageNamed:@"Background_button_2.png"]
                                 forState:UIControlStateNormal];
    [self.rejectButton setTitle:rejectTitle
                       forState:UIControlStateNormal];
    [self.rejectButton addTarget:self
                          action:@selector(rejectAction)
                forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:self.acceptButton];
    [bottomView addSubview:self.rejectButton];
    
    [self.view addSubview:topView];
    [self.view addSubview:middleView];
    [self.view addSubview:bottomView];
    // Do any additional setup after loading the view.
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
- (void)acceptAction
{
    self.acceptInvite = YES;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.acceptButton.enabled = NO;
    self.rejectButton.enabled = NO;
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSString *peventID = self.invite.peID;
    NSString *userID = self.mivc.memberID;
    NSString *invitedEmail = self.mivc.email;
    NSString *post = [NSString stringWithFormat:@"&id_private_event=%@&id_member=%@&emailuser=%@",peventID,userID,invitedEmail];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/includes/registeracceptinvite2.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    [conn start];
}
- (void)rejectAction
{
    self.acceptInvite = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.acceptButton.enabled = NO;
    self.rejectButton.enabled = NO;
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSString *peventID = self.invite.peID;
    NSString *invitedEmail = self.mivc.email;
    NSString *post = [NSString stringWithFormat:@"&id_private_event=%@&emailuser=%@",peventID,invitedEmail];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/includes/registerrejectinvite2.php"]]];
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
    NSString *dat = [[NSString alloc] initWithData:self.dataRecieved encoding:NSUTF8StringEncoding];
    if (self.acceptInvite) {
        if([dat isEqualToString:@"OK"])
        {
            //[self.mivc reloadInvites];
            [self.mivc.etvc reloadEvents];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            
        }
    } else
    {
        if([dat isEqualToString:@"OK"])
        {
            //[self.mivc reloadInvites];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            
        }
    }
    [self.spinner stopAnimating];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.acceptButton.enabled = YES;
    self.rejectButton.enabled = YES;
}

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
