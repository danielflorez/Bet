//
//  MTELoginViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 3/27/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTELoginViewController.h"
#import "MTEBetStore.h"
#import "MTEEventsTableViewController.h"
#import "MTERegisterViewController.h"
#import "MTEButtonEventViewController.h"
#import "MTEForgotPasswordViewController.h"
#import "MTETermsFacebookViewController.h"

@import JavaScriptCore;


@interface MTELoginViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;
@property (nonatomic, strong) NSString *fbname;
@property (nonatomic, strong) NSString *fbemail;
@property (nonatomic, strong) NSString *fbid;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic) int facebookCalls;
@property (nonatomic) BOOL facebook;
@property (nonatomic, strong) FBLoginView *loginView;
@property (nonatomic, strong) NSString *fbLabel;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;

@end

@implementation MTELoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.facebook = 0;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
    self.emailTextField.text =[[NSUserDefaults standardUserDefaults] stringForKey:@"Username"];
    self.loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email", @"user_friends",@"publish_actions"]];
    UIImage *bg = [UIImage imageNamed:@"Background.jpg"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bg]];
    self.emailTextField.backgroundColor = [UIColor clearColor];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 40)];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 40)];
    self.emailTextField.leftView = paddingView;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passTextField.leftView = paddingView1;
    self.passTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImage *fieldBGImage = [UIImage imageNamed:@"Field_User.png"];
    [self.emailTextField setBackground:fieldBGImage];
    NSString *name;
    NSString *password;
    NSString *forgotPassword;
    NSString *regis;
    NSString *contact;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        name = @"User";
        password = @"Password";
        forgotPassword = @"Forgot your password?";
        regis = @"Register";
        contact = @"Contact Us";
        self.fbLabel = @"Log in with facebook";
    }
    else {
        name = @"Usuario";
        password = @"Contraseña";
        forgotPassword = @"Olvidaste tu contraseña?";
        regis = @"Registrar";
        contact = @"Contactenos";
        self.fbLabel = @"Ingrese con facebook";
    }
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.passTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:password attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.forgotButton setTitle:forgotPassword forState:UIControlStateNormal];
    [self.contactButton setTitle:contact forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.facebookCalls = 0;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.loginView.frame = CGRectMake((self.view.frame.size.width/2)-100, self.registerButton.frame.origin.y + 80,  200, 38);
    self.loginView.delegate = self;
    self.registerButton.enabled = YES;
    self.loginButton.enabled = YES;
    for (id obj in self.loginView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            
            UIImage *bg = [UIImage imageNamed:@"Fb_Connect1.png"];
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
            loginLabel.text = self.fbLabel;
            loginLabel.textAlignment = NSTextAlignmentLeft;
            loginLabel.frame = CGRectMake(40, 0, self.loginView.frame.size.width-40, self.loginView.frame.size.height);
        }
    }
    [self.view addSubview:self.loginView];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.fbname = user.name;
    self.fbemail = [user objectForKey:@"email"];
    self.fbid = [user objectForKey:@"id"];
    self.facebookCalls++;
    self.registerButton.enabled = NO;
    self.loginButton.enabled = NO;
    if (self.facebookCalls<2) {
        [self loginFacebook:self.fbemail withName:self.fbname withID:self.fbid];
    }
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginClicked:(id)sender
{
    self.facebook = 0;
    self.loginButton.enabled = NO;
    self.loginView.hidden = YES;
    self.forgotButton.enabled = NO;
    self.registerButton.enabled = NO;
    if (![self.passTextField.text isEqualToString:@""]) {
        if ([self NSStringIsValidEmail:self.emailTextField.text]) {
            [[NSUserDefaults standardUserDefaults] setValue:self.emailTextField.text forKey:@"Username"];
            [[NSUserDefaults standardUserDefaults]synchronize ];
            [self login:self.emailTextField.text withPassword:self.passTextField.text];
        }else {
            NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
            NSString *title;
            if([language isEqualToString:@"en"])
            {
                title = @"The user has to be an email.";
            }
            else {
                title = @"El usuario tiene que ser un email.";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:title
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            self.loginButton.enabled = YES;
            self.loginView.hidden = NO;
            self.forgotButton.enabled = YES;
            self.registerButton.enabled = YES;
        }
    }else{
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"Please type your password.";
        }
        else {
            title = @"Por favor ingresa tu contraseña.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.loginButton.enabled = YES;
        self.loginView.hidden = NO;
        self.forgotButton.enabled = YES;
        self.registerButton.enabled = YES;
    }
}

- (IBAction)registerClicked:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTERegisterViewController *regis = [storyboard instantiateViewControllerWithIdentifier:@"register"];
    regis.lvc = self;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController pushViewController:regis animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer
{
    [[self view] endEditing:YES];
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

- (void) login:(NSString *)email withPassword:(NSString *)pass
{
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSURL *url = [NSURL URLWithString:@"http://www.mangostatecnologia.com/secureLogin/js/sha512.js"];
    NSError *err;
    NSString *scriptData = [NSString stringWithContentsOfURL:url
                                                    encoding:NSUTF8StringEncoding
                                                       error:&err];
    if (scriptData == nil) {
        NSLog(@"Error loading scripts; %@", err);
        scriptData = @"";
    }
    JSContext *scriptContext = [[JSContext alloc] init];
    [scriptContext evaluateScript:scriptData];
    JSValue *func = scriptContext[@"hex_sha512"];
    JSValue *result = [func callWithArguments:@[pass]];
    NSString *newText = [result toString];
    //NSLog(@"Script functions:%@", scriptContext[@"hex_sha512"]);
    NSString *post = [NSString stringWithFormat:@"&email=%@&p=%@",email,newText];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/includes/process_login2.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
}

- (void) loginFacebook:(NSString *)email withName:(NSString *)name withID:(NSString *)fbid
{
    self.facebook = 1;
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSString *post = [NSString stringWithFormat:@"&username=%@&email=%@&fbid=%@",name,email,fbid];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/includes/register_facebook2_new1.php"]]];
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
    NSString *dat = [[NSString alloc] initWithData:self.dataRecieved encoding:NSUTF8StringEncoding];
    if (self.facebook) {
        if ([dat isEqualToString:@"OK"])
        {
            [[MTEBetStore sharedStore] loadData];
            MTEButtonEventViewController *bevc = [[MTEButtonEventViewController alloc] init];
            bevc.email = self.fbemail;
            bevc.loginView = self.loginView;
            bevc.facebookLogin = YES;
            bevc.fbname = self.fbname;
            [self.spinner stopAnimating];
            [self.navigationController pushViewController:bevc animated:YES];
        }
        else if([dat isEqualToString:@"NO"])
        {
            MTETermsFacebookViewController *tvc = [[MTETermsFacebookViewController alloc] init];
            tvc.fbemail = self.fbemail;
            tvc.loginView = self.loginView;
            [self.spinner stopAnimating];
            [self.navigationController pushViewController:tvc animated:YES];
        }
        else
        {
            NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
            NSString *title;
            if([language isEqualToString:@"en"])
            {
                title = @"Problems login with facebook please try again.";
            }
            else {
                title = @"Problemas al ingresar con facebook por favor vuelva a intentar.";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:title
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self.spinner stopAnimating];
        }
    }
    else
    {
        if ([dat isEqualToString:@"OK"])
        {
            [[MTEBetStore sharedStore] loadData];
            MTEButtonEventViewController *bevc = [[MTEButtonEventViewController alloc] init];
            bevc.email = self.emailTextField.text;
            bevc.loginView = self.loginView;
            bevc.facebookLogin = NO;
            bevc.lvc = self;
            [self.spinner stopAnimating];
            [self.navigationController pushViewController:bevc animated:YES];
        }else if ([dat isEqualToString:@"ACT"])
        {
            NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
            NSString *title;
            if([language isEqualToString:@"en"])
            {
                title = @"You haven't activated you account please follow the instructions that were sent to you in an email.";
            }
            else {
                title = @"Falta activar la cuenta, por favor sigue las instrucciones del email de activacion que se envio.";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:title
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self.spinner stopAnimating];
        }
        else {
            NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
            NSString *title;
            if([language isEqualToString:@"en"])
            {
                title = @"User or password is mistaken.";
            }
            else {
                title = @"Clave o usuario errados.";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:title
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self.spinner stopAnimating];
        }
    }
    self.loginButton.enabled = YES;
    self.loginView.hidden = NO;
    self.forgotButton.enabled = YES;
    self.registerButton.enabled = YES;
}
- (IBAction)forgotAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTEForgotPasswordViewController *fpvc = [storyboard instantiateViewControllerWithIdentifier:@"fotgotPassword"];
    [self.navigationController pushViewController:fpvc
                                         animated:YES];
}

- (IBAction)contactAction:(id)sender {
    
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:info@mangostatecnologia.com"]];
    
}

@end
