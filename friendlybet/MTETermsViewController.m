//
//  MTETermsViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 5/11/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTETermsViewController.h"


@interface MTETermsViewController ()
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *acceptButton;

@end

@implementation MTETermsViewController

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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,17,25);
    [button setBackgroundImage:[UIImage imageNamed:@"Arrow_2.png"] forState:UIControlStateNormal];
    
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    
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
    [self.rvc checkAction];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
