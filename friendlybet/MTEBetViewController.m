//
//  MTEBetViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/15/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEBetViewController.h"
#import "MTEMemberBetsTableViewController.h"

@interface MTEBetViewController ()
@property (nonatomic, strong) NSMutableData *dataRecieved;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *seeScores;

@end

@implementation MTEBetViewController

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
    //self.view.backgroundColor = [UIColor clearColor];
    UIImage *bg = [UIImage imageNamed:@"Background.jpg"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bg]];
    NSString *saveTittle;
    NSString *cancelTitle;
    NSString *seeButton;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        saveTittle = @"Save";
        cancelTitle = @"Cancel";
        seeButton = @"See your friends bets.";
    }
    else
    {
        saveTittle = @"Grabar";
        cancelTitle = @"Cancelar";
        seeButton = @"Ver apuestas de tus amigos.";
    }
    self.flag1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.match.team1 flag]]];
    self.flag2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.match.team2 flag]]];
    self.team1.text = [self.match.team1 name];
    self.team2.text = [self.match.team2 name];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
    [self.saveButton setTitle:saveTittle forState:UIControlStateNormal];
    [self.saveButton setBackgroundImage:[UIImage imageNamed:@"Background_buttons.png"]
                                 forState:UIControlStateNormal];
    [self.seeScores setTitle:seeButton forState:UIControlStateNormal];
    [self.seeScores setBackgroundImage:[UIImage imageNamed:@"Background_buttons.png"]
                               forState:UIControlStateNormal];
    
    [self.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"Background_button_2.png"]
                                 forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveAction:(id)sender {
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];
    NSString *s1 = self.score1.text;
    NSString *s2 = self.score2.text;
    NSString *matchid = self.match.matchID;
    NSString *eventID = self.event.eventID;
    NSString *memberID = self.event.memberID;
    NSString *post = [NSString stringWithFormat:@"&id_member=%@&id_private_event=%@&id_game=%@&score_team1=%@&score_team2=%@",memberID,eventID,matchid,s1,s2];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/includes/registerbet2.php"]]];
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
    if ([dat isEqualToString:@"OK"]) {
        [self.gmvc reloadBets];
        //[self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else if([dat isEqualToString:@"ERROR_GAME_STARTED"])
    {
        NSString *regis;
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        if([language isEqualToString:@"en"])
        {
            regis = @"The match has started.";
        }
        else {
            regis = @"El partido ya comenzo.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:regis
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.spinner stopAnimating];
}

- (IBAction)cancelAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)seeBets:(id)sender
{
    if (![self.match.started isKindOfClass:[NSNull class]])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        MTEMemberBetsTableViewController *ftvc = [storyboard instantiateViewControllerWithIdentifier:@"memberBets"];
        ftvc.match = self.match;
        ftvc.event = self.event;
        [self.navigationController pushViewController:ftvc
                                             animated:YES];
    }
    else
    {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"You can only see yout friends bets when the match has started";
        }
        else {
            title = @"Solo puedes ver las apuestas de tus amigos despues de que el partido haya comenzado.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [[self view] endEditing:YES];
}


@end
