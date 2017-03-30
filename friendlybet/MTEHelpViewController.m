//
//  MTEHelpViewController.m
//  friendlybet
//
//  Created by DANIEL FLOREZ HUERTAS on 5/8/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEHelpViewController.h"

@interface MTEHelpViewController ()
@property (nonatomic, strong) UITextView *instructionTextField;

@end

@implementation MTEHelpViewController

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
    self.instructionTextField = [[UITextView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    self.instructionTextField.backgroundColor = [UIColor clearColor];
    self.instructionTextField.textColor = [UIColor whiteColor];
    self.instructionTextField.font = [UIFont systemFontOfSize:12];
    self.instructionTextField.editable = NO;
    self.instructionTextField.scrollEnabled = YES;
    NSString *helpText;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqualToString:@"en"])
    {
        helpText = @"Name:Type the name of your event. \rFee: Is the cost to participate in your event. \rPercentages: Type the percentage from the total amount collected in your event you want to give to the first, second and third place. \rPoints: You have four types of guesses you can use in your event. \rScore: The player guess the complete score of the matche, for example if the score is Colombia 3 - Greece 0 , to win this points the player would have had to bet Colombia 3 - Greece 0. \r1/2Score: The player only have to guess one of the teams score, for example if the score is Colombia 3 - Greece 0 is , and the player had bet Colombia 3 - Greece 1 he would win this points, because of the score of Colombia. \rWinner: The player only have to guess the winner,for example if the score is Colombia 3 - Greece 0, and the player bet Colombia 2 - Greece 0 he would win this points because he guessed the winner. \rSelect the  two teams that passes from each group, this are the points the player will get for each team he bets correctly that passes to the next stage. \rNote: If you don't want to use one of this guesses just leave is't field empty. If you want to use any of the guesses type a number between 1 and 10 in its field. \rTeam: If you select a team, your event will be with all the matches of the selected team in all the tournament stages. \rStages: If you don't select a team, you have to choose which stages will be in your event.";
    }
    else {
        helpText = @"Nombre: Ingrese el nombre del evento. \rCuota: Ingrese el valor de la cuota para participar. \rPorcentajes: Ingrese el porcentaje del total del evento que ira para el primer , segundo y tercer puesto en su respectivo cuadro. \rPuntos: Tiene disponibles cuatro tipos de aciertos a los que le podra asignar unos puntos menos de 10:  Marcador: El jugador le acierta el marcador completo, por ejemplo si el partido queda  Colombia 3 - Grecia 0 el jugador tiene que poner en su apuesta Colombia 3 - Grecia 0 para ganar estos puntos. \r1/2Marcador: El jugador solo tiene que acertar uno de los dos marcadores, por ejemplo si el partido queda Colombia 3 - Grecia 0, y el jugador pone Colombia 3 - Grecia 1 se gana estos puntos por que tiene bien el marcador de Colombia. \rGanador: El jugador tiene que acertar que equipo gano sin importar el marcador, por ejemplo si el partido queda Colombia 3 - Grecia 0, y el jugador aposto Colombia 2 - Grecia 0 se gana estos puntos porque acerto el ganador. \rSeleccionar los equipos que pasan de cada grupo, el jugador recibe esta cantidad de puntos por cada equipo que acierte que paso a la siguente ronda. \rNota: Usted puede dejar en blanco el tipo de acierto que no desee utilizar en su evento. Si desea usar uno de los tipos de acierto pongo un numero entre 1 y 10 en su campo. \rEquipo: Si usted elije un equipo quiere decir que en su evento solo va a apostar a los partidos en los que juegue este equipo durante todas las fases.\rFases: Si no selecciono un equipo tiene que escoger que fases desea escoger para su evento.";
    }
    self.instructionTextField.text = helpText;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        self.instructionTextField.font = [UIFont systemFontOfSize:22];
    }else
    {
        self.instructionTextField.font = [UIFont systemFontOfSize:12];
    }
    [self.view addSubview:self.instructionTextField];
    [self.instructionTextField setContentOffset:CGPointMake(0, 1) animated:YES];
    [self.view setNeedsDisplay];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
