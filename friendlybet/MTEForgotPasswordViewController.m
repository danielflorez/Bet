//
//  MTEForgotPasswordViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 5/8/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEForgotPasswordViewController.h"

@interface MTEForgotPasswordViewController ()
@property (nonatomic, strong) UITextField *emailLabel;
@property (nonatomic, strong) UITextView *instructionTextField;
@property (nonatomic, strong) UIButton *sendEmail;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;

@end

@implementation MTEForgotPasswordViewController

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
    NSString *title;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        title = @"Recover Password";
    }
    else {
        title = @"Recuperar Contraseña";
    }
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text =  title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,17,25);
    [button setBackgroundImage:[UIImage imageNamed:@"Arrow_4.png"] forState:UIControlStateNormal];
    
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    NSString *senButTitle;
    NSString *name;
    NSString *instructions;
    if([language isEqualToString:@"en"])
    {
        senButTitle = @"Send email";
        name = @"email";
        instructions = @"Please enter your email to send you a mail with the instructions to reset your password.";
    }
    else {
        senButTitle = @"Enviar correo";
        name = @"email";
        instructions = @"Por favor ingrese su email para enviarle un correo con las instrucciones para resetear su contraseña.";
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
    UIImage *bg = [UIImage imageNamed:@"Background.jpg"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bg]];
    self.instructionTextField = [[UITextView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, (self.view.frame.size.height/2) - 130,200, 80)];
    self.instructionTextField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Invite_Mail_field.png"]];
    self.instructionTextField.textColor = [UIColor whiteColor];
    self.instructionTextField.text = instructions;
    self.instructionTextField.font = [UIFont systemFontOfSize:12];
    self.instructionTextField.editable = NO;
    self.emailLabel = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, (self.view.frame.size.height/2) - 40,200, 30)];
    UIImage *fieldBGImage = [UIImage imageNamed:@"Field_User.png"];
    [self.emailLabel setBackground:fieldBGImage];
    
    self.sendEmail = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-100, (self.view.frame.size.height/2)+10,200,28)];
    [self.sendEmail setBackgroundImage:[UIImage imageNamed:@"Background_buttons.png"]
                              forState:UIControlStateNormal];
    [self.sendEmail setTitle:senButTitle
                    forState:UIControlStateNormal];
    [self.sendEmail addTarget:self
                       action:@selector(sendForgotEmail)
             forControlEvents:UIControlEventTouchUpInside];
    self.emailLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.emailLabel.leftView = paddingView;
    [self.view addSubview:self.emailLabel];
    self.emailLabel.leftViewMode = UITextFieldViewModeAlways;
    self.emailLabel.textColor = [UIColor whiteColor];
    self.emailLabel.font = [UIFont systemFontOfSize:12];
    self.emailLabel.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:self.sendEmail];
    [self.view addSubview:self.instructionTextField];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)sendForgotEmail
{
    self.sendEmail.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    if ([self NSStringIsValidEmail:self.emailLabel.text]) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        _spinner.hidesWhenStopped = YES;
        [self.view addSubview:_spinner];
        [_spinner startAnimating];
        if (!self.dataRecieved) {
            self.dataRecieved = [[NSMutableData alloc] init];
        }
        NSString *post = [NSString stringWithFormat:@"&email_forgot=%@,",self.emailLabel.text];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mangostatecnologia.com/secureLogin/includes/mail_forgot.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        [connection start];
    }else {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"Please enter a valid email.";
        }
        else {
            title = @"Por favor ingrese un email valido.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.sendEmail.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    
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
    if ([dat isEqualToString:@"OK"])
    {
        [self.spinner stopAnimating];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"We could't send the email please try again.";
        }
        else {
            title = @"No fue posible enviar el correo por favor vuelva a intentar mas tarde.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.spinner stopAnimating];
    }
    self.sendEmail.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
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
