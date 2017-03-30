//
//  MTEIpadInviteViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/21/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEIpadInviteViewController.h"
#import "MTEFBMember.h"

@interface MTEIpadInviteViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *invitePicker;
@property (weak, nonatomic) IBOutlet UITextView *emailTextView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;
@property (weak, nonatomic) IBOutlet UITextView *emailTitleTextField;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;
@property (nonatomic, strong) NSString *alertMessage;
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (nonatomic) BOOL isSaving;
@property (nonatomic) int numInvites;

@end

@implementation MTEIpadInviteViewController

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
    self.bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView_.adUnitID = @"ca-app-pub-8260074602621393/7755568460";
    self.bannerView_.rootViewController = self;
    self.bannerView_.frame = CGRectMake(0, self.view.frame.size.height - 156, self.view.frame.size.width, 90);
    [self.view addSubview:self.bannerView_];
    [self.bannerView_ loadRequest:[GADRequest request]];
    if (!self.facebookmMembers) {
        self.facebookmMembers = [[NSMutableArray alloc] init];
    }
    if (!self.emails) {
        self.emails = [[NSMutableArray alloc] init];
    }
    UIImage *bg = [UIImage imageNamed:@"Background.jpg"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *title;
    NSString *fbButtonText;
    if([language isEqualToString:@"en"])
    {
        title = @"Enter the emails that you want to invite, separated by a comma.";
        fbButtonText = @"Invite with facebook";
        self.alertMessage = @"The invitations where created.";
    }
    else {
        title = @"Anote los emails a los que desea invitar, separados por una coma.";
        fbButtonText = @"Invita con facebook";
        self.alertMessage = @"Se crearon las invitaciones.";
    }
    [self.fbButton setTitle:fbButtonText
                   forState:UIControlStateNormal];
    self.emailTitleTextField.text = title;
    self.emailTextView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Invite_mail_field.png"]];
    self.emailTitleTextField.font = [UIFont systemFontOfSize:20];
    self.emailTitleTextField.textColor = [UIColor whiteColor];
    [self fetchfacebookMembers];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *title;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        title = @"Invite";
    }
    else {
        title = @"Invitar";
    }
    self.tabBarController.navigationItem.title = title;
    if ([self.events count]>0) {
        self.selectedEvent = [self.events objectAtIndex:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [self.events count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    MTEEvent *ev = [self.events objectAtIndex:row];
    CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    UIView *cell = [[UIView alloc] initWithFrame:viewFrame];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width/2)-80, (cell.frame.size.height/2)-11, 160, 21)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text =[ev name];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:nameLabel];
    cell.backgroundColor = [UIColor clearColor];
    UIImage *bg = [UIImage imageNamed:@"Invite_select.png"];
    UIGraphicsBeginImageContextWithOptions(cell.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, cell.frame.size.width, cell.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    separatorLineView.backgroundColor = [UIColor colorWithPatternImage:resultImage];
    [cell addSubview:separatorLineView];
    return cell;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

- (void)pickerView:(UIPickerView *)thePickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    self.selectedEvent = [self.events objectAtIndex:row];
}

- (IBAction)inviteClick:(id)sender {
    NSArray *e = [self.emailTextView.text componentsSeparatedByString:@","];
    _emails = [[NSMutableArray alloc] initWithArray:e];
    [self checkEmails];
    if ([self.emails count] > 0)
    {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        _spinner.hidesWhenStopped = YES;
        [self.view addSubview:_spinner];
        [_spinner startAnimating];
        self.numInvites = 0;
        for (NSString *email in self.emails) {
            [self saveInvites:email];
        }
    }
}

- (void)checkEmails
{
    NSMutableArray *toDelete = [[NSMutableArray alloc] init];
    for (NSString *email in self.emails) {
        if (![self NSStringIsValidEmail:email]) {
            [toDelete addObject:email];
        }
    }
    [self.emails removeObjectsInArray:toDelete];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [[self view] endEditing:YES];
}

- (void)fetchfacebookMembers
{
    self.isSaving = NO;
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = NO;
    self.inviteButton.enabled = NO;
    self.fbButton.enabled = NO;
    [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:FALSE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mangostatecnologia.com/secureLogin/test/members_facebook.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    [conn start];
}

- (void)saveInvites:(NSString *)email
{
    self.isSaving = YES;
    self.tabBarController.navigationItem.leftBarButtonItem.enabled = NO;
    self.inviteButton.enabled = NO;
    self.fbButton.enabled = NO;
    [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:FALSE];
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSString *post = [NSString stringWithFormat:@"&id_private_event=%@&email_invite=%@",self.selectedEvent.eventID,email];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/includes/registerinvite2.php"]]];
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
    if (self.isSaving)
    {
        //Use your downloaded data here
        NSString *dat = [[NSString alloc] initWithData:self.dataRecieved encoding:NSUTF8StringEncoding];
        if([dat isEqualToString:@"OK"])
        {
            self.numInvites++;
        }
        if (self.numInvites == [self.emails count])
        {
            self.emails = [[NSMutableArray alloc] init];
            self.emailTextView.text = @"";
            [self.spinner stopAnimating];
            self.tabBarController.navigationItem.leftBarButtonItem.enabled = YES;
            self.inviteButton.enabled = YES;
            self.fbButton.enabled = YES;
            [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:TRUE];
            [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:self.alertMessage
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            self.emailTitleTextField.text = @"";
        }
    }else
    {
        NSDictionary *member= [NSJSONSerialization JSONObjectWithData:self.dataRecieved
                                                              options:0
                                                                error:nil];
        for (NSDictionary *user in [member objectForKey:@"Events"]) {
            MTEFBMember *m = [[MTEFBMember alloc] init];
            m.email = user[@"email"];
            m.facebook_id = user[@"fbid"];
            [self.facebookmMembers addObject:m];
        }
        [self.spinner stopAnimating];
        self.tabBarController.navigationItem.leftBarButtonItem.enabled = YES;
        self.inviteButton.enabled = YES;
        self.fbButton.enabled = YES;
        [[[[self.tabBarController tabBar]items]objectAtIndex:0]setEnabled:TRUE];
        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
    }
}

- (IBAction)facebookInviteAction:(id)sender
{
    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Select Friends";
        self.friendPickerController.delegate = self;
    }
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    [self.tabBarController presentViewController:self.friendPickerController
                                        animated:YES
                                      completion:nil];
}

- (void) handlePickerDone
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender
{
    [self handlePickerDone];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
    for (NSDictionary<FBGraphUser> *user in self.friendPickerController.selection) {
        NSString *fid = [user objectForKey:@"id"];
        for (MTEFBMember *m in self.facebookmMembers) {
            if ([m.facebook_id isEqualToString:fid]) {
                [self.emails addObject:m.email];
            }
        }
    }
    [self checkEmails];
    self.numInvites = 0;
    for (NSString *email in self.emails) {
        [self saveInvites:email];
    }
    [self handlePickerDone];
}

@end
