//
//  MTECreateEventViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 4/11/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTECreateEventViewController.h"
#import "MTESelectTeamViewController.h"
#import "MTEHelpViewController.h"

@interface MTECreateEventViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *feeTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstPlaceTextField;
@property (weak, nonatomic) IBOutlet UITextField *secondPlaceTextField;
@property (weak, nonatomic) IBOutlet UITextField *thirdPlaceTextField;
@property (weak, nonatomic) IBOutlet UITextField *scorePointsTextField;
@property (weak, nonatomic) IBOutlet UITextField *oneScoreTextField;
@property (weak, nonatomic) IBOutlet UITextField *winnerTextField;
@property (weak, nonatomic) IBOutlet UILabel *perceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *ayudaButton;
@property (weak, nonatomic) IBOutlet UITextField *selectTeamGroup;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSMutableData *dataRecieved;

@end

@implementation MTECreateEventViewController

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
    NSString *help;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        title = @"Create Event";
        help = @"Help";
    }
    else {
        title = @"Crear Evento";
        help = @"Ayuda";
    }
    self.navigationItem.title = title;
    [self.ayudaButton setTitle:help forState:UIControlStateNormal];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,17,25);
    [button setBackgroundImage:[UIImage imageNamed:@"Arrow_2.png"] forState:UIControlStateNormal];
    
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    UIImage *bg = [UIImage imageNamed:@"Background.jpg"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bg]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Cancel"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
    self.nameTextField.backgroundColor = [UIColor clearColor];
    self.feeTextField.backgroundColor = [UIColor clearColor];
    self.firstPlaceTextField.backgroundColor = [UIColor clearColor];
    self.secondPlaceTextField.backgroundColor = [UIColor clearColor];
    self.thirdPlaceTextField.backgroundColor = [UIColor clearColor];
    self.scorePointsTextField.backgroundColor = [UIColor clearColor];
    self.oneScoreTextField.backgroundColor = [UIColor clearColor];
    self.winnerTextField.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
    NSString *name;
    NSString *feePlace;
    NSString *firstPlace;
    NSString *secondPlace;
    NSString *thirdPlace;
    NSString *score;
    NSString *oneScore;
    NSString *winner;
    NSString *team;
    NSString *perTitle;
    NSString *poinTitle;
    NSString *selectTeam;
    if([language isEqualToString:@"en"])
    {
        name = @"Name";
        feePlace = @"Fee";
        firstPlace = @"1st place";
        secondPlace = @"2nd place";
        thirdPlace = @"3rd place";
        score = @"Score";
        oneScore = @"1/2 score";
        winner = @"Winner";
        team = @"Team";
        perTitle = @"Percentages";
        poinTitle = @"Points";
        selectTeam = @"Select the 2 teams that pass by group.";
    }
    else {
        name = @"Nombre";
        feePlace = @"Cuota";
        firstPlace = @"1er puesto";
        secondPlace = @"2do puesto";
        thirdPlace = @"3er puesto";
        score = @"Marcador";
        oneScore = @"1/2marcador";
        winner = @"Ganador";
        team = @"Equipo";
        perTitle = @"Porcentajes";
        poinTitle = @"Puntos";
        selectTeam = @"Seleccionar los 2 equipos que pasan x grupo.";
    }
    self.perceTitleLabel.text = perTitle;
    self.pointTitleLabel.text = poinTitle;
    self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.feeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:feePlace attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.firstPlaceTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:firstPlace attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.secondPlaceTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:secondPlace attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:8]}];
    self.thirdPlaceTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:thirdPlace attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.scorePointsTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:score attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.oneScoreTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:oneScore attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.winnerTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:winner attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.teamTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:team attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.selectTeamGroup.attributedPlaceholder = [[NSAttributedString alloc] initWithString:selectTeam attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 29, 65)];
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 29, 65)];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 19, 65)];
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 19, 65)];
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 19, 65)];
    UIView *paddingView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 19, 65)];
    UIView *paddingView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 19, 65)];
    UIView *paddingView7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 19, 65)];
    UIView *paddingView8 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 19, 65)];
    UIView *paddingView9 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 29, 65)];
    self.nameTextField.leftView = paddingView;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.feeTextField.leftView = paddingView1;
    self.feeTextField.leftViewMode = UITextFieldViewModeAlways;
    self.firstPlaceTextField.leftView = paddingView2;
    self.firstPlaceTextField.leftViewMode = UITextFieldViewModeAlways;
    self.secondPlaceTextField.leftView = paddingView3;
    self.secondPlaceTextField.leftViewMode = UITextFieldViewModeAlways;
    self.thirdPlaceTextField.leftView = paddingView4;
    self.thirdPlaceTextField.leftViewMode = UITextFieldViewModeAlways;
    self.scorePointsTextField.leftView = paddingView5;
    self.scorePointsTextField.leftViewMode = UITextFieldViewModeAlways;
    self.oneScoreTextField.leftView = paddingView6;
    self.oneScoreTextField.leftViewMode = UITextFieldViewModeAlways;
    self.winnerTextField.leftView = paddingView7;
    self.winnerTextField.leftViewMode = UITextFieldViewModeAlways;
    self.teamTextField.leftView = paddingView8;
    self.teamTextField.leftViewMode = UITextFieldViewModeAlways;
    self.selectTeamGroup.leftView = paddingView9;
    self.selectTeamGroup.leftViewMode = UITextFieldViewModeAlways;
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.groupPhaseSwitch.transform = CGAffineTransformMakeScale(0.70, 0.70);
    self.round16Switch.transform = CGAffineTransformMakeScale(0.70, 0.70);
    self.round8Switch.transform = CGAffineTransformMakeScale(0.70, 0.70);
    self.semiFinalSwitch.transform = CGAffineTransformMakeScale(0.70, 0.70);
    self.finalSwitch.transform = CGAffineTransformMakeScale(0.70, 0.70);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createEvent:(id)sender {
    BOOL valid = YES;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.ayudaButton.enabled = NO;
    self.createButton.enabled = NO;
    if (!self.dataRecieved) {
        self.dataRecieved = [[NSMutableData alloc] init];
    }
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    NSString *eventName = self.nameTextField.text;
    NSString *fee = self.feeTextField.text;
    NSString *firstPlace = self.firstPlaceTextField.text;
    NSString *secondPlace = self.secondPlaceTextField.text;
    NSString *thirdPlace = self.thirdPlaceTextField.text;
    NSString *scorePoints = self.scorePointsTextField.text;
    NSString *oneScorePoints = self.oneScoreTextField.text;
    NSString *winnerPoints = self.winnerTextField.text;
    NSString *qualifiedPoints = self.selectTeamGroup.text;
    NSString *groupPhase = [[NSString alloc] init];
    NSString *roundSixteen = [[NSString alloc] init];
    NSString *roundEight = [[NSString alloc] init];
    NSString *semifinal = [[NSString alloc] init];
    NSString *final = [[NSString alloc] init];
    NSString *teamID = [[NSString alloc] init];
    int firstPlaceInt = [firstPlace intValue];
    int secondPlaceInt = [secondPlace intValue];
    int thirdPlaceInt = [thirdPlace intValue];
    int scorePointsInt = [scorePoints intValue];
    int oneScorePoinsInt = [scorePoints intValue];
    int winnerPointsInt = [winnerPoints intValue];
    int qualifiedInt = [qualifiedPoints intValue];
    if (self.groupPhaseSwitch.isOn)
    {
        groupPhase = @"1";
    }
    else
    {
        if (![self.teamTextField.text isEqualToString:@""])
        {
            groupPhase = @"1";
        }
        else{
            groupPhase = @"0";
        }
    }
    if (self.round16Switch.isOn)
    {
        roundSixteen = @"1";
    }
    else
    {
        if (![self.teamTextField.text isEqualToString:@""])
        {
            roundSixteen = @"1";
        }
        else{
            roundSixteen = @"0";
        }
    }
    if (self.round8Switch.isOn)
    {
        roundEight = @"1";
    }
    else
    {
        if (![self.teamTextField.text isEqualToString:@""])
        {
            roundEight = @"1";
        }
        else{
            roundEight = @"0";
        }
    }
    if (self.semiFinalSwitch.isOn)
    {
        semifinal = @"1";
    }
    else
    {
        if (![self.teamTextField.text isEqualToString:@""])
        {
            semifinal = @"1";
        }
        else{
            semifinal = @"0";
        }
    }
    if (self.finalSwitch.isOn) {
        final = @"1";
    }
    else
    {
        if (![self.teamTextField.text isEqualToString:@""])
        {
            final = @"1";
        }
        else{
            final = @"0";
        }
    }
    if ([self.teamTextField.text isEqualToString:@""]) {
        teamID = @"0";
        if(![self.groupPhaseSwitch isOn]&&![self.round16Switch isOn]&&![self.round8Switch isOn]&&![self.semiFinalSwitch isOn]&&![self.finalSwitch isOn])
        {
            NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
            NSString *title;
            if([language isEqualToString:@"en"])
            {
                title = @"If you don't select a team you have to choose at least one phase.";
            }
            else {
                title = @"Si no selecciona un equipo tiene que escoger por lo menos una de las fases.";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:title
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            valid = NO;
            [self.spinner stopAnimating];
            self.navigationItem.leftBarButtonItem.enabled = YES;
            self.ayudaButton.enabled = YES;
            self.createButton.enabled = YES;
        }
    }
    else {
        teamID = self.selectedTeam.teamID;
    }
    if ([eventName isEqualToString:@""])
    {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"The name field can't be empty.";
        }
        else {
            title = @"Es necesario llenar el campo nombre.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        valid = NO;
        [self.spinner stopAnimating];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.ayudaButton.enabled = YES;
        self.createButton.enabled = YES;
    }
    if ([fee isEqualToString:@""])
    {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"The fee field can't be empty.";
        }
        else {
            title = @"Es necesario llenar el campo cuota.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        valid = NO;
        [self.spinner stopAnimating];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.ayudaButton.enabled = YES;
        self.createButton.enabled = YES;
    }
    if ([scorePoints isEqualToString:@""]&&[oneScorePoints isEqualToString:@""]&&[winnerPoints isEqualToString:@""])
    {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"You have to assign values to at least one of the points fields.";
        }
        else {
            title = @"Se necesita asignar valor por lo menos a uno de los campos de puntos.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        valid = NO;
        [self.spinner stopAnimating];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.ayudaButton.enabled = YES;
        self.createButton.enabled = YES;
    }
    if (!((firstPlaceInt+secondPlaceInt+thirdPlaceInt)==100))
    {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title;
        if([language isEqualToString:@"en"])
        {
            title = @"The sum of the % of the first, second and third place must be 100.";
        }
        else {
            title = @"La suma de los % del primer, segundo y tercer lugar debe ser 100.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        valid = NO;
        [self.spinner stopAnimating];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.ayudaButton.enabled = YES;
        self.createButton.enabled = YES;
    }
    if ((scorePointsInt)>10) {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title1;
        if([language isEqualToString:@"en"])
        {
            title1 = @"Points for whole score must be lower than 11.";
        }
        else {
            title1 = @"Puntos x marcador debe ser menor que 11.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title1
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        valid = NO;
        [self.spinner stopAnimating];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.ayudaButton.enabled = YES;
        self.createButton.enabled = YES;
    }
    if ((oneScorePoinsInt)>10) {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title2;
        if([language isEqualToString:@"en"])
        {
            title2 = @"Points 1/2 score must be lower than 11.";
        }
        else {
            title2 = @"Puntos x 1/2 marcador debe ser menor que 11.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title2
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        valid = NO;
        [self.spinner stopAnimating];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.ayudaButton.enabled = YES;
        self.createButton.enabled = YES;
    }
    if ((winnerPointsInt)>10) {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title3;
        if([language isEqualToString:@"en"])
        {
            title3 = @"Points for whole score must be lower than 11.";
        }
        else {
            title3 = @"Puntos x ganador debe ser menor que 11.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title3
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        valid = NO;
        [self.spinner stopAnimating];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.ayudaButton.enabled = YES;
        self.createButton.enabled = YES;
    }
    if ((qualifiedInt)>10) {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *title4;
        if([language isEqualToString:@"en"])
        {
            title4 = @"Points for selecting team that advanced the group stage must be lower than 11.";
        }
        else {
            title4 = @"Puntos por seleccionar equipos que pasan la fase de grupos debe ser menor que 11.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:title4
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        valid = NO;
        [self.spinner stopAnimating];
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.ayudaButton.enabled = YES;
        self.createButton.enabled = YES;
    }
    if (valid) {
        NSString *post = [NSString stringWithFormat:@"&namepevent=%@&owner_id=%@&pointsxscore=%@&pointsxwinner=%@&pointsxteamscore=%@&pointsxqualified=%@&groupphase=%@&round16=%@&quarterfinals=%@&semifinals=%@&finals=%@&firstprize=%@&secondprize=%@&thirdprize=%@&entry_fee=%@&id_team=%@",eventName,self.memberID,scorePoints,winnerPoints,oneScorePoints,qualifiedPoints,groupPhase,roundSixteen,roundEight,semifinal,final,firstPlace,secondPlace,thirdPlace,fee,self.selectedTeam.teamID];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.mangostatecnologia.com/secureLogin/includes/registerpevent2.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
        [request setHTTPBody:postData];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        [connection start];
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
    if ([dat isEqualToString:@"OK1OK2"])
    {
        //[self.eventTVC reloadEvents];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if ([dat isEqualToString:@"ERROR"])
        {
            NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
            NSString *title;
            if([language isEqualToString:@"en"])
            {
                title = @"There already exists an event with that name.";
            }
            else {
                title = @"Ya existe un evento con ese nombre.";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:title
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            self.nameTextField.text = @"";
            [alert show];
        }
    }
    [self.spinner stopAnimating];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.ayudaButton.enabled = YES;
    self.createButton.enabled = YES;
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

- (IBAction)selectTeamAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTESelectTeamViewController *selectTeam = [storyboard instantiateViewControllerWithIdentifier:@"selectTeam"];
    selectTeam.cevc = self;
    if ([self.teamTextField.text isEqualToString:@""]) {
        selectTeam.selectedRow = 0;
    }else{
        selectTeam.selectedRow = self.selectedRow;
    }
    [self.navigationController pushViewController:selectTeam animated:YES];
}

- (IBAction)ayudaAction:(id)sender {
    MTEHelpViewController *help = [[MTEHelpViewController alloc] init];
    [self.navigationController pushViewController:help animated:YES];
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
