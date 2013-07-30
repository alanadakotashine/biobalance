//
//  ViewController.m
//  BioBalance
//
//  Created by Jessie on 3/8/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "ViewController.h"
#define TIME_STEP 0.05

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    //Add how many organisms are in each level; change this for new levels.  Also declare beginning levelm
    //set currentDisaster to be -1, and add the number of diasasters at each level
    organismsAtLevel[0]= 3;
    organismsAtLevel[1]= 4;
    disastersAtLevel[0]= 0;
    disastersAtLevel[1]= 3;
    currentLevel=0;
    currentDisaster=-1;
    
    //set background color to be black, and define all sizes and frames
    self.view.backgroundColor = [UIColor blackColor];
    int SCREEN_WIDTH = self.view.bounds.size.width;
    int SCREEN_HEIGHT = self.view.bounds.size.height;
    int GBOARD_ORIGIN_X = SCREEN_WIDTH *.05;
    int GBOARD_ORIGIN_Y = SCREEN_HEIGHT * .12;
    int GBOARD_HEIGHT = SCREEN_HEIGHT *.65;
    int GBOARD_WIDTH = SCREEN_WIDTH *.8;
    int GBUTTONS_ORIGIN_X = SCREEN_WIDTH*.24;
    int GBUTTONS_ORIGIN_Y = SCREEN_HEIGHT * .8-10;
    int GBUTTONS_WIDTH = SCREEN_WIDTH *.6;
    int GBUTTONS_HEIGHT =  SCREEN_WIDTH *.2;
    int SBAR_ORIGIN_X =(GBOARD_WIDTH+GBOARD_ORIGIN_X +((SCREEN_WIDTH - (GBOARD_WIDTH+GBOARD_ORIGIN_X+GBOARD_WIDTH * .1)))/2);
    int SBAR_WIDTH = GBOARD_WIDTH * .1;
    int SBAR_HEIGHT = (GBUTTONS_HEIGHT/4 + ((GBUTTONS_ORIGIN_Y+GBUTTONS_HEIGHT)-GBOARD_ORIGIN_Y));
    statusBarFrame = CGRectMake(SBAR_ORIGIN_X, GBOARD_ORIGIN_Y, SBAR_WIDTH, SBAR_HEIGHT);
    gameBoardFrame = CGRectMake(GBOARD_ORIGIN_X, GBOARD_ORIGIN_Y, GBOARD_WIDTH, GBOARD_HEIGHT);
    buttonsFrame = CGRectMake(GBUTTONS_ORIGIN_X, GBUTTONS_ORIGIN_Y, GBUTTONS_WIDTH, GBUTTONS_HEIGHT);
    indBarFrame = CGRectMake(GBUTTONS_ORIGIN_X+15, (GBUTTONS_ORIGIN_Y+GBUTTONS_HEIGHT), GBUTTONS_WIDTH, GBUTTONS_HEIGHT/4);
    
    //put in the title--it's also a new game button, letting the user restart.  Disable the title until a game is being played
    CGRect titleFrame = CGRectMake(0, SCREEN_HEIGHT * .025, SCREEN_WIDTH, SCREEN_WIDTH * .1);
    title = [[UIButton alloc] initWithFrame: titleFrame];
    [title setBackgroundImage:[UIImage imageNamed:@"title0.png"] forState:UIControlStateNormal];
    [title addTarget:self action:@selector(alertChangeInGameStatus) forControlEvents:UIControlEventTouchUpInside];
    [title setEnabled:false];
    [self.view addSubview:title];
    
    //initialize win music and points model, which don't change between levels
    thePoints = [[PointsView alloc] initWithFrame:CGRectMake(GBOARD_ORIGIN_X-10, GBUTTONS_ORIGIN_Y+20, GBUTTONS_WIDTH / 3, GBUTTONS_HEIGHT)];
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"winTune" ofType:@"m4a"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.numberOfLoops=-1;
    
    //Launch the welcome pop-up
    [self welcomeUser];
}

// Give the welcome pop-up, which gives the option of viewing instructions or going straight to the game
-(void) welcomeUser{
    NSString* welcomeText = @"The goal is to keep an environment at equilibrium.  Add and remove organisms from their environment and watch your BioPoints increase. You need at least one of each organism to win.  Sustain balance to move onto the next level.  Watch out for disasters!";
    UIAlertView* welcomeAlert = [[UIAlertView alloc] initWithTitle:@"Welcome to Biobalance!"
                                                           message:welcomeText
                                                          delegate:self
                                                 cancelButtonTitle:@"Instructions"
                                                 otherButtonTitles:@"Straight to Game", nil];
    
    [welcomeAlert setTag:-1];
    [welcomeAlert show];
}

// Show the instructions page
-(void) displayInstructions{
    // set up instructions
    theInstructions = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    UIGraphicsBeginImageContext(theInstructions.frame.size);
    [[UIImage imageNamed:@"instruction_overlay.png"] drawInRect:theInstructions.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    theInstructions.backgroundColor = [UIColor colorWithPatternImage:image];
    //set up button
    UIButton *clickToStart = [[UIButton alloc] initWithFrame:CGRectMake(240, 375, 200, 100)];
    [clickToStart setBackgroundImage:[UIImage imageNamed:@"startButton.png"]  forState:UIControlStateNormal];
    [clickToStart addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    //add both to view
    [theInstructions addSubview:clickToStart];
    [self.view addSubview: theInstructions];
}

// Removes the instructions, enable the title button, add the points to the subview, and start the game
-(void) startGame{
    [theInstructions removeFromSuperview];
    [title setEnabled:true];
    [self.view addSubview: thePoints];
    [self newGame];
}

// Resets everything that changes in between levels
-(void) newGame{
    //find number of orgs and disaster at the new level and set the timer
    numOrgs = organismsAtLevel[currentLevel];
    numDisasters=disastersAtLevel[currentLevel];
    timer = [NSTimer scheduledTimerWithTimeInterval: TIME_STEP
                                            target:self
                                          selector:@selector(updateBoard)
                                          userInfo:nil
                                           repeats:YES];
    //Initialize the information, control buttons, board model, game status, game board, and status bars
    theInfo = [[Information alloc] initAtLevel:currentLevel];
    theControlButtons = [[ControlButtons alloc] initWithFrame:buttonsFrame andOrganisms:numOrgs andLevel:currentLevel];
    [theControlButtons setTarget1:self atAction:@selector(controlButtonPressed)];
    [theControlButtons setTarget2:self atAction:@selector(giveInfo)];
    [self.view addSubview: theControlButtons];
    theBoardModel = [[BoardModel alloc] initWithOrganisms:numOrgs andLevel:currentLevel];
    theGameStatus = [[StatusModel alloc]init];
    theBar = [[StatusBar alloc] initWithFrame:statusBarFrame];
    [self.view addSubview: theBar];
    [self makeIndStatusBars];
    theGameBoard = [[BoardView alloc] initWithFrame:gameBoardFrame andOrganisms:numOrgs atLevel:currentLevel];
    [self.view addSubview: theGameBoard];
}

// Initialize the individual status bars with the correct dimentions
-(void) makeIndStatusBars{
    indBarFrame.origin.x=(buttonsFrame.origin.x+15);
    indBarFrame.size.width=(buttonsFrame.size.width-(15 * (numOrgs+1)))/numOrgs;
    theBars = [[NSMutableArray alloc] init];
    for(int i=0;i<numOrgs;i++){
        [theBars addObject:[[StatusBar alloc]initWithFrame:indBarFrame]];
        indBarFrame.origin.x+=15+(buttonsFrame.size.width-(15 * (numOrgs+1)))/numOrgs;
        [self.view addSubview:[theBars objectAtIndex:i]];
    }
}

// Gives information alert on the organism or disaster
-(void) giveInfo{
    //Stops the timer and stops the animals from moving, then set up the alert
    [timer invalidate];
    [theGameBoard stopBoard];
    UIAlertView* alert = [[UIAlertView alloc] init];
    [alert addButtonWithTitle:@"OK!"];
    //If there's no current disaster, we're giving organism info.  We get the organism number, then get the info on that organism from the info class.
    if (currentDisaster==-1){
        int organism = (theControlButtons.organismToAddOrDelete);
        [alert setTitle:[theInfo->orgInfo objectAtIndex:organism]];
        [alert setMessage:[theInfo->orgInfo objectAtIndex:organism+numOrgs]];
        [alert setTag:-5];
    }
    //If a disaster is occuring, we need to get the disaster's information.
    else{
        [alert setTitle: [theInfo->disasterInfo objectAtIndex:currentDisaster]];
        [alert setMessage:[theInfo->disasterInfo objectAtIndex:currentDisaster+numDisasters]];
        [alert setTag:currentDisaster];
    }
    [alert setDelegate:self];
    [alert show];
}

// Calculate all model-based changes
-(void) updateBoard{
    //Update populations
    [theBoardModel updateBoard];
    //See if a disaster happened
    if([theBoardModel disasterOccurred]){
        //Get which disaster it was, and deploy it in the model and view
        [theBoardModel deployDisaster];
        currentDisaster = (theBoardModel -> curDisaster);
        [theGameBoard deployDisaster:currentDisaster];
        //We only give info on each disaster once, so if it hadn't been seen yet, we get the information and set the "seen" boolean to true.
        if(![theGameBoard disasterSeenBefore:currentDisaster]){
            [self giveInfo];
            [theGameBoard markAsSeen:currentDisaster];
        }
        else{
            [self alertChangeInGameStatus];
        }
    }
    //Make sure same number of orgs in model and view are the same
    [self changePops];
    //Update main status bar, based upon system imbalance
    float imbalance = (theBoardModel->ecosystemImbalance);
    [theBar setEcosystemImbalance:imbalance givenDirection:0];
    //Update mini status bars under each organism, based upon individual imbalances
    for(int i=0; i<numOrgs; i++){
        [(StatusBar*)[theBars objectAtIndex:i] setEcosystemImbalance:[theBoardModel getImbalanceGivenOrganism:i] givenDirection:1];
    }
    //Update points
    [thePoints updatePoints:([theGameStatus numPointsGivenImbalance:imbalance])];
    //Check if they won or lost; alert them if they have
    int newGame = [theGameStatus checkWinOrLoseGivenImbalance:imbalance];
    if (newGame==0){
        [self remindUser];
    }
    else if(newGame!=-1){
        [self alertChangeInGameStatus];
    }
}

// Adjust the board view to reflect the same numbers as the board model, after any calculated changes in population
-(void) changePops{
    int modelPop;
    for(int i=0; i<numOrgs; i++){
        //get the population of the organism according to the model, and that according to the board
        modelPop = (((OrganismModel*)([(theBoardModel->organisms) objectAtIndex:i]))->population);
        int beforePop = [theGameBoard numberOfOrganisms:i];        
        //change the population of the board to reflect that of the model
        while (modelPop>[theGameBoard numberOfOrganisms:i]){
            [theGameBoard addOrDeleteOrganism:i];
        }
        while (modelPop<[theGameBoard numberOfOrganisms:i]){
            [theGameBoard addOrDeleteOrganism:i+numOrgs];
        }
        //if an entire species has died out, set the "remove" button to be black and white
        if(modelPop==0&&beforePop>0){
            [theControlButtons setRemoveButton:i+numOrgs];
        }
    }
}

// Add or delete the organism from model and board when control button is pressed
-(void) controlButtonPressed{
    //get the organism to add or delete, and its population before the change
    int organism = (theControlButtons.organismToAddOrDelete);
    int beforePop = [theGameBoard numberOfOrganisms:organism];
    //Add the organism to the game board
    [theGameBoard addOrDeleteOrganism:organism];
    //get the population after the addition or deletion;
    //add or delete the organism to the model
    int afterPop = [theGameBoard numberOfOrganisms:organism];
    [theBoardModel addOrDeleteOrganism:organism byValue:1];
    //change the "remove" button to/from black and white if the population changed to or from 0
    if (afterPop==0&&beforePop>0){
        [theControlButtons setRemoveButton:organism];
    }
    if (afterPop>0&&beforePop==0){
        [theControlButtons setRemoveButton:organism];
    }
}

//remind user that he needs to add all organisms to win the game
-(void) remindUser{
    //Stops the timer and stops the animals from moving, then set up the alert
    [timer invalidate];
    [theGameBoard stopBoard];
    UIAlertView* alert = [[UIAlertView alloc] init];
    [alert addButtonWithTitle:@"OK!"];
    [alert setMessage:@"Remember: You have to add at least one of each organism to win!"];
    [alert setDelegate:self];
    [alert setTag:-6];
    [alert show];
}

//Set up and show the alert for a lost or won game, or pressed the title to restart, or repeat disaster
-(void) alertChangeInGameStatus{
    //stop the timer and animations, and declare the alert strings and int
    [timer invalidate];
    [theGameBoard stopBoard];
    UIAlertView* alert;
    NSString* alertTitle;
    NSString* alertMessage;
    NSString* alertButtonTitle;
    NSString* otherButtonTitle;
    int tag;
    int statusChange;
    // if there's not a disaster, it's just a won or lost game
    if (currentDisaster==-1){
        statusChange = [theGameStatus checkWinOrLoseGivenImbalance:(theBoardModel->ecosystemImbalance)];
    }
    else{
        statusChange = currentDisaster;
    }
    //alerts if a disaster has struck again (this alert doesn't include the information, and only pops up if the specific disaster has already occurred in the game)
    if (statusChange>=0){
        alertTitle = [theInfo->disasterInfo objectAtIndex:currentDisaster];
        alertMessage = @"";
        alertButtonTitle=@"More Info";
        otherButtonTitle=@"Continue";
        tag=currentDisaster;
    }
    //if they've lost, set the message to tell them so
    if (statusChange==-3){
        alertTitle = @"Sorry!";
        alertMessage = @"Your System Stayed Unbalanced for Too Long";
        alertButtonTitle = @"Try Again!";
        otherButtonTitle = @"Cancel";
        tag=-3;
    }
    //if they've won, set the message to tell them so
    if (statusChange==-2){
        alertTitle = @"Congratulations! You've Achieved Ecosystem Balance";
        alertMessage = [NSString stringWithFormat:@"%@%d%@",
                        @"You won the level with ",[theGameStatus numPointsGivenImbalance:(0)],@" points"];
        otherButtonTitle = @"Replay Level";
        if (currentLevel<maxLevel){
            alertButtonTitle = @"Next Level!";
        }
        else{
            alertButtonTitle = @"Start Again!";
        }
        tag=-4;
        [player play];
    }
    //Let them start over if they press the title button (go back to the first level)
    if (statusChange==-1){
        alertTitle = @"New Game?";
        if (currentLevel==0){
            alertMessage = [[NSString alloc] initWithFormat:@"Do You Want To Restart?"];
        }
        else{
            alertMessage = [[NSString alloc] initWithFormat:@"Do You Want To Go Back To Level 1?"];
        }
        alertButtonTitle = @"New Game!";
        otherButtonTitle = @"Cancel";
        tag=-2;
    }
    //initiate the alert with the relevant information and show it.
    alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                       message:alertMessage
                                      delegate:self
                             cancelButtonTitle:alertButtonTitle
                             otherButtonTitles:otherButtonTitle, nil];
    alert.tag=tag;
    [alert show];
}

// takes care of all of the alert options we have in the game
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // all the options if the user hit the "cancel button" in the alert
    if (buttonIndex == [alertView cancelButtonIndex]){
        // If the tag is -1, it's the beginning and they wanted to see the instructions, so we display them.
        if(alertView.tag==-1){
            [self displayInstructions];
        }
        // If the tag is >=0, they wanted more information on the current disaster, so we display it.
        else if (alertView.tag>=0){
            [self giveInfo];
        }
        // Otherwise, we're going to be restarting the game at some level, so no matter what we reset everything and start a new game
        else{
            [theBar removeFromSuperview];
            [theGameBoard removeFromSuperview];
            [theControlButtons removeFromSuperview];
            [thePoints updatePoints:0];
            for(int i=0;i<numOrgs;i++){
                [[theBars objectAtIndex:i] removeFromSuperview];
            }
            // If they selected to restart the game (tag of -2), the current level is set to 0
            if (alertView.tag==-2){
                currentLevel=0;
            }
            // If the tag was -4, they won the level, so stop the music and either increment levels or, if we're out of levels, go back to the beginning
            if (alertView.tag==-4){
                [player pause];
                if (currentLevel<maxLevel){
                    currentLevel++;
                }
                else{
                    currentLevel=0;
                }
            }
            [self newGame];
        }
    }
    // all the options if the user pushed the "other" button (or if there was only one button to push)
    else{
        // if the tag is -1, they chose to start the game without viewing the instructions, so we start the game
        if(alertView.tag==-1){
            [title setEnabled:true];
            [self.view addSubview: thePoints];
            [self newGame];
        }
        // if the tag is -3, they lost and chose not to play again, so we disable the buttons and set lose counter to 0 so they touch the title to play again
        else if(alertView.tag==-3){
            theGameStatus->loseCounter=0;
            [theControlButtons disableButtons];
        }
        // if the tag is -4, they won and decided to restart the level they just played, so we reset everything and start a new game of the same level
        else if(alertView.tag==-4){
            [player pause];
            player.currentTime = 0.0;
            [theBar removeFromSuperview];
            [theGameBoard removeFromSuperview];
            [theControlButtons removeFromSuperview];
            for(int i=0;i<numOrgs;i++){
                [[theBars objectAtIndex:i] removeFromSuperview];
            }
            [thePoints updatePoints:0];
            [self newGame];
        }
        // otherwise, either they cancelled the "new game" option or it was just information, so we start the current game back up.
        else{
            // if the tag is greater than or equal to 0, the alert was for a disaster, so we reset disaster stuff too
            if (alertView.tag>=0){
                [theGameBoard hideDisaster:currentDisaster];
                //we don't want multiple disasters at one time, so we keep a boolean
                //and set it to false only after 7 seconds (which is when the disaster will
                //have been removed from the view)
                [self performSelector:@selector(setDisaster) withObject:nil afterDelay:7];
                //the disaster has ended, so set currentDisaster to -1.
                currentDisaster=-1;
            }
            //If we don't check the lose counter there's a problem with losing, hitting "cancel," hitting the title button, and hitting "cancel" again.
            if (!(theGameStatus->lostGame)){
                (theGameStatus->stagnantCounter=0);
                [theGameBoard resumeBoard];
                theGameStatus->loseCounter=0;
                timer= [NSTimer scheduledTimerWithTimeInterval: TIME_STEP
                                                        target:self
                                                      selector:@selector(updateBoard)
                                                      userInfo:nil
                                                       repeats:YES];
            }
        }
    }
}

//sets the disaster boolean to false (we call it with a delay of 7 secs, which is why it's a new function)
-(void) setDisaster{
    theBoardModel->disasterGoing=false;
}

//locks ipad in portrait mode
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end