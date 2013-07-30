//
//  BioBalanceTests.h
//  BioBalanceTests
//
//  Created by Jessie on 3/8/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "BoardView.h"
#import "ControlButtons.h"
#import "PointsView.h"
#import "StatusBar.h"
#import "BoardModel.h"
#import "StatusModel.h"
#import "Information.h"

@interface BioBalanceTests : SenTestCase{
    //since we don't have a viewcontroller to test, and can't switch levels, we
    //declare a copy of everything for level 1 and level 2.
    PointsView* thePoints;
    StatusBar* theBar;
    NSTimer* timer;
    BoardModel* theBoardModel1;
    StatusModel* theStatusModel;
    BoardView* theGameBoard1;
    ControlButtons* theControlButtons1;
    int numOrgs1;
    BoardModel* theBoardModel2;
    BoardView* theGameBoard2;
    ControlButtons* theControlButtons2;
    Information* theInfo1;
    Information* theInfo2;
    int numOrgs2;
}

//Makes sure everything initializes
-(void) testInitSetUp;

//Adds, and then deletes, valid organisms of each type to boardView
-(void) testAddAndDeleteOrganismsToBoardView;

//Adds, then deletes, valid organisms of each type from the board model
-(void) testAddAndDeleteOrganismsToBoardModel;

//Adds invalid organisms of each type to boardView to make sure it doesn't work
-(void) testAddAndDeleteInvalidOrganismsToBoardView;

//Adds invalid organisms of each type to boardModel to make sure it doesn't work
-(void) testAddAndDeleteInvalidOrganismsToBoardModel;

//Makes sure the bar's height is zero with imbalance
-(void) testBarSizeGivenBalanceConstants;

//Makes sure the bar isn't green when it's imbalanced or red when it's balanced
-(void) testBarColorGivenBalanceConstants;

//Makes sure files that should be there are
-(void) testFilesYes;

//Makes sure files that aren't there aren't giving false positives
-(void) testFilesNo;

//Integration test.  Makes sure the method we use to update the boardview really does so
-(void) testUpdateMethod;

//Integration text to make sure organism is added to both the model and board
-(void) testForModelAdditionGivenViewChange;

//Makes sure bonus points are being saved
-(void) testForAddingPermenantPoints;

//Makes sure no negative points will be displayed 
-(void) testForNegativePoints;

//Makes sure adding points doesn't affect bonus points
-(void) testForNormalPoints;

//the Model should be imbalanced with a value of 0.99 if an organism is missing and hasn't been added yet
-(void) testForImbalanceWhenOrganismsMissing;

//the Model should be completely imbalanced (with a value of 1) if an organism is missing and hasn't been added yet
-(void) testForImbalanceWhenOrganismsMissingAfterAdding;

//Makes sure it's imbalanced when ratios are off, with too many middle organisms
-(void) testForImbalanceWithTooManyMiddleOrgs;

//Makes sure it's imbalanced when ratios are off, with too few middle organisms
-(void) testForImbalanceWithTooFewMiddleOrgs;

//Makes sure it's balanced when ratios are good
-(void) testForBalanceWithGoodRatios;

//tests our updateBoard function to make sure births/deaths are actually calculated
-(void) testNetOrganism;

//tests our updateBoard function to make sure births/deaths are actually calculated for level two
-(void) testNetOrganismLevelTwo;

//Ensure number of organisms in view correspond to expected numbers
-(void) testOrgNumsInView;

//Makes sure populations, food counts, and pred counts are all updating, and are consistant 
-(void) testForEqualityOfPopsPredsAndFood;

//Makes sure populations, food counts, and pred counts are all updating, and are consistant, for level 2
-(void) testForEqualityOfPopsPredsAndFoodLevelTwo;

//Makes sure there's information on the organisms in level 1
-(void) testForInformationOnOrganismsLevelOne;

//Makes sure there's information on the organisms in level 2
-(void) testForInformationOnOrganismsLevelTwo;

//Makes sure there's disaster information on level 2
-(void) testForInformationOnDisastersLevelTwo;

//Makes sure there aren't disasters at level 1
-(void) testForDisasterModelImplementationLevelOne;

//Makes sure Board View and Board Model both properly implement disasters in level 2
-(void) testForDisasterModelImplementationLevelTwo;

@end
