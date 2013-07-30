//
//  ViewController.h
//  BioBalance
//
//  Created by Jessie on 3/8/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BoardView.h"
#import "ControlButtons.h"
#import "PointsView.h"
#import "StatusBar.h"
#import "BoardModel.h"
#import "StatusModel.h"
#import "Information.h"
#import <AudioToolbox/AudioServices.h>

// As we only have levels 0 and 1 implemented, maxLevel is 1.
#define maxLevel 1

@interface ViewController : UIViewController{
    // The frames
    CGRect buttonsFrame; //frame for control buttons
    CGRect statusBarFrame; //frame for status bar
    CGRect gameBoardFrame; //frame for game board
    CGRect indBarFrame; //frame for individual status bars
    
    // The objects
    BoardView* theGameBoard;
    ControlButtons* theControlButtons;
    PointsView* thePoints;
    StatusBar* theBar;
    UIButton *title;
    NSTimer* timer;
    BoardModel* theBoardModel;
    StatusModel* theGameStatus;
    Information* theInfo;
    NSMutableArray* theBars;
    UIView* theInstructions;
    
    // Ints that indicate the level's specifications, and whether a disaster is occuring
    int numOrgs;
    int currentLevel;
    int numDisasters;
    int currentDisaster;
    
    // Arrays giving the numbers of disasters and organisms at each level
    int organismsAtLevel[2];
    int disastersAtLevel[2];
    
    // Music player for when the user wins
    AVAudioPlayer *player;
}

// Give the welcome pop-up, which gives the option of viewing instructions or going straight to the game
-(void) welcomeUser;

// Show the instructions page
-(void) displayInstructions;

// Removes the instructions, enable the title button, add the points to the subview, and start the game
-(void) startGame;

// Resets everything that changes in between levels
-(void) newGame;

// Initialize the individual status bars with the correct dimentions
-(void) makeIndStatusBars;

// Gives information alert on the organism or disaster
-(void) giveInfo;

// Calculate all model-based changes
-(void) updateBoard;

// Adjust the board view to reflect the same numbers as the board model, after any calculated changes in population
-(void) changePops;

// Add or delete the organism from model and board when control button is pressed
-(void) controlButtonPressed;

//If the user is stagnant for too long, remind him that he needs to add all organisms
-(void) remindUser;

//Set up and show the alert for a lost or won game, or pressed the title to restart, or repeat disaster
-(void) alertChangeInGameStatus;

// takes care of all of the alert options we have in the game
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

//sets the disaster boolean to false (we call it with a delay of 7 secs, which is why it's a new function)
-(void) setDisaster;

//locks ipad in portrait mode
-(NSUInteger)supportedInterfaceOrientations;

@end