//
//  ViewController.m
//  BioBalance
//
//  Created by Jessie on 3/8/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "ViewController.h"
#define TIME_STEP 0.01

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //add how many organisms are in each level; change this for new levels.  ALso declare beginning level
    organismsAtLevel[0]=3;
    organismsAtLevel[1]= 4;
    currentLevel=0;
    
    //set background color to be black
    self.view.backgroundColor = [UIColor blackColor];
    
    //Define all the sizes
    int SCREEN_WIDTH = self.view.bounds.size.width;
    int SCREEN_HEIGHT = self.view.bounds.size.height;

    int GBOARD_ORIGIN_X = SCREEN_WIDTH *.05;
    int GBOARD_ORIGIN_Y = SCREEN_HEIGHT * .12;
    int GBOARD_HEIGHT = SCREEN_HEIGHT *.65;
    int GBOARD_WIDTH = SCREEN_WIDTH *.8;

    int GBUTTONS_ORIGIN_X = SCREEN_WIDTH*.24;
    int GBUTTONS_ORIGIN_Y = SCREEN_HEIGHT * .8; 
    int GBUTTONS_WIDTH = SCREEN_WIDTH *.6;
    int GBUTTONS_HEIGHT =  SCREEN_WIDTH *.2;
    
    int SBAR_ORIGIN_X =(GBOARD_WIDTH+GBOARD_ORIGIN_X +((SCREEN_WIDTH - (GBOARD_WIDTH+GBOARD_ORIGIN_X+GBOARD_WIDTH * .1)))/2);
    int SBAR_WIDTH = GBOARD_WIDTH * .1;
    int SBAR_HEIGHT = (GBUTTONS_HEIGHT + (GBUTTONS_ORIGIN_Y-GBOARD_ORIGIN_Y) - 15);
    
    //Create the frames
    statusBarFrame = CGRectMake(SBAR_ORIGIN_X, GBOARD_ORIGIN_Y, SBAR_WIDTH, SBAR_HEIGHT);
    gameBoardFrame = CGRectMake(GBOARD_ORIGIN_X, GBOARD_ORIGIN_Y, GBOARD_WIDTH, GBOARD_HEIGHT);
    buttonsFrame = CGRectMake(GBUTTONS_ORIGIN_X, GBUTTONS_ORIGIN_Y, GBUTTONS_WIDTH, GBUTTONS_HEIGHT);
    pointsFrame = CGRectMake(GBOARD_ORIGIN_X, GBUTTONS_ORIGIN_Y, GBUTTONS_WIDTH / 3, GBUTTONS_HEIGHT);
    
    //put in the title--it's also a new game button, letting the user restart
    CGRect titleFrame = CGRectMake(0, SCREEN_HEIGHT * .025, SCREEN_WIDTH, SCREEN_WIDTH * .1);
    UIButton *title = [[UIButton alloc] initWithFrame: titleFrame];
    [title setBackgroundImage:[UIImage imageNamed:@"title0.png"] forState:UIControlStateNormal];
    [title addTarget:self action:@selector(newGameOption) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:title];
    
    //create the level control, then make the new game
    levelControl = [[LevelController alloc]init];
    [self newGame];
}

-(void) newGame{
    //find number of orgs
    numOrgs = organismsAtLevel[currentLevel];

    //Initialize control buttons
    theControlButtons = [[ControlButtons alloc] initWithFrame:buttonsFrame andOrganisms:numOrgs andLevel:currentLevel];
    [theControlButtons setTarget:self atAction:@selector(controlButtonPressed)];
    [self.view addSubview: theControlButtons];
    
    //initialize points
    thePoints = [[PointsView alloc] initWithFrame:pointsFrame];
    [self.view addSubview: thePoints];
    
    //initialize the timer
    timer = [NSTimer scheduledTimerWithTimeInterval: TIME_STEP
                                             target:self
                                           selector:@selector(updateBoard)
                                           userInfo:nil
                                            repeats:YES];
    
    // Allocate and Initialize board model
    theBoardModel = [[BoardModel alloc] initWithOrganisms:numOrgs andLevel:currentLevel];
    
    //create the status bar
    theBar = [[StatusBar alloc] initWithFrame:statusBarFrame];
    [self.view addSubview: theBar];
    
    //create the game baord
    theGameBoard = [[BoardView alloc] initWithFrame:gameBoardFrame andOrganisms:numOrgs atLevel:currentLevel];
    [self.view addSubview: theGameBoard];
    
}

-(void) updateBoard{
    //Calculate all Model-Based Changes
    [theBoardModel updateBoard];
    
    //Make sure same number of orgs in model and view
    [self changePops];
    
    //Update status bar, based upon system imbalance
    [theBar setEcosystemImbalance:(theBoardModel->ecosystemImbalance)];
    
    //check if they won or lost
    int newGame = [self checkWinOrLose];
    
    //Update points
    [thePoints updatePoints:([theBoardModel updatePoints])];
    
    if(newGame!=0){
        //If the levelController has calculated a new game, invalidate the timer, announce it, and
        //make a new game.
        [timer invalidate];
        [self announceWinOrLose:newGame];
    }
}

-(void) changePops{
    //Adjust the board view to reflect the same numbers as the board model
    int modelPop;
    for(int i=0; i<numOrgs; i++){
        modelPop = (((OrganismModel*)([(theBoardModel->organisms) objectAtIndex:i]))->population);
        while (modelPop>[theGameBoard numberOfOrganisms:i]){
            [theGameBoard addOrDeleteOrganism:i];
        }
        while (modelPop<[theGameBoard numberOfOrganisms:i]){
            [theGameBoard addOrDeleteOrganism:i+numOrgs];
        }
    }
}

-(int) checkWinOrLose{
    //checks if user has won or lost the game.  If they've won, current level increases
    //also sees whether user has won/lost "bonus points"
    int winOrLose = [levelControl checkWinOrLoseGivenImbalance:(theBoardModel->ecosystemImbalance)];
    int pointChange = 0;
    int newGame = 0;
    if(winOrLose==2){
        pointChange=100;
        currentLevel++;
        newGame=1;
    }
    if (winOrLose==-2){
        newGame=-1;
    }
    else if (winOrLose!=0){
        pointChange = 50 * winOrLose;
    }
    (theBoardModel->bonusPoints+=pointChange);
    return newGame;
}

//add or delete the organism from model and board when control button is pressed
-(void) controlButtonPressed{
    int organism = (theControlButtons.organismToAddOrDelete);
    if ([theGameBoard addOrDeleteOrganism:organism]==1){
        [theBoardModel addOrDeleteOrganism:organism];
    }
}

-(void) newGameOption{
    //Lets them start over if they press the title button
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Game?"
                                                    message:@"Do You Want To Restart?"
                                                   delegate:self
                                          cancelButtonTitle:@"New Game!"
                                          otherButtonTitles:@"Cancel", nil];
    [alert show];
}

-(void) announceWinOrLose: (int) lostOrWon{
    UIAlertView* alert;
    NSString* alertTitle;
    NSString* alertMessage;
    NSString* alertButtonTitle;
    if (lostOrWon==-1){
        alertTitle = @"Sorry!";
        alertMessage = @"Your System Stayed Unbalanced for Too Long";
        alertButtonTitle = @"Try Again!";
    }
    else{
        alertTitle = @"Congratulations! You've Achieved Ecosystem Balance";
        alertMessage = @"You won the level with %d points", [theBoardModel updatePoints];
        alertButtonTitle = @"Next Level!";
    }
    alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                       message:alertMessage
                                      delegate:self
                             cancelButtonTitle:alertButtonTitle
                             otherButtonTitles:@"Cancel", nil];
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //if the user was sure he wanted a new game, this loads it
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [theBar removeFromSuperview];
        [self newGame];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end