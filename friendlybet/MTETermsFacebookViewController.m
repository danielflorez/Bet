//
//  MTETermsFacebookViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 5/23/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTETermsFacebookViewController.h"
#import "MTEBetStore.h"
#import "MTEButtonEventViewController.h"

@interface MTETermsFacebookViewController ()
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;

@end

@implementation MTETermsFacebookViewController

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
    UIImage *bg = [UIImage imageNamed:@"Background.jpg"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton = YES;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, 7*(self.view.frame.size.height/8))];
    NSString *buttonTitle;
    NSString *terms;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        buttonTitle = @"I have read and accept the terms.";
        terms = @"http://mangostatecnologia.com/pollamundial/terms-conditions/";
    }
    else {
        buttonTitle = @"He leido y acepto los terminos.";
        terms = @"http://mangostatecnologia.com/pollamundial/terminos-y-condiciones/";
    }
    NSURL *URL = [NSURL URLWithString:terms];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:URL];
    self.webView.delegate = self ;
    [self.webView loadRequest:requestObj];
    [self.view addSubview:self.webView];
    self.acceptButton = [[UIButton alloc] init];
    self.acceptButton.frame = CGRectMake((self.view.frame.size.width/2)-150, (7*(self.view.frame.size.height/8))+20, 300, 40);
    [self.acceptButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.acceptButton addTarget:self
                          action:@selector(acceptAction)
                forControlEvents:UIControlEventTouchUpInside];
    UIImage *bgb = [UIImage imageNamed:@"Background_buttons.png"];
    UIGraphicsBeginImageContextWithOptions(self.acceptButton.frame.size, NO, 0.f);
    [bgb drawInRect:CGRectMake(0.f, 0.f, self.acceptButton.frame.size.width, self.acceptButton.frame.size.height)];
    UIImage *resultImage1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.acceptButton setBackgroundColor:[UIColor colorWithPatternImage:resultImage1]];
    [self.view addSubview:self.acceptButton];
    [self.view setNeedsDisplay];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)acceptAction
{
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    NSString *post = [NSString stringWithFormat:@"&email=%@",self.fbemail];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/includes/accepttermsfacebook.php"]]];
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
    if ([dat isEqualToString:@"OK"])
    {
        [[MTEBetStore sharedStore] loadData];
        MTEButtonEventViewController *bevc = [[MTEButtonEventViewController alloc] init];
        bevc.email = self.fbemail;
        bevc.loginView = self.loginView;
        bevc.facebookLogin = YES;
        [self.navigationController pushViewController:bevc animated:YES];
    }
    else {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"Problems accepting the terms please try again.";
        }
        else {
            title = @"Problemas al aceptar los terminos por favor vuelva a intentar.";
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

@end
