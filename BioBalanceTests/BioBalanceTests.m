//
//  BioBalanceTests.m
//  BioBalanceTests
//
//  Created by Jessie on 3/8/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "BioBalanceTests.h"

@implementation BioBalanceTests

- (void)setUp{
    [super setUp];
    numOrgs1=3; //orgs at level 1
    numOrgs2=4; //orgs at level 2
    CGRect randomFrame = CGRectMake(0,0,0,0);
    theControlButtons1=[[ControlButtons alloc]initWithFrame:randomFrame andOrganisms:numOrgs1 andLevel:0];
    theControlButtons2=[[ControlButtons alloc]initWithFrame:randomFrame andOrganisms:numOrgs2 andLevel:1];
    thePoints=[[PointsView alloc]init];
    theBar=[[StatusBar alloc]init];
    theBoardModel1 = [[BoardModel alloc] initWithOrganisms:numOrgs1 andLevel:0];
    theGameBoard1 = [[BoardView alloc] initWithFrame:randomFrame andOrganisms:numOrgs1 atLevel:0];
    theStatusModel = [[StatusModel alloc] init];
    theBoardModel2 = [[BoardModel alloc] initWithOrganisms:numOrgs2 andLevel:1];
    theGameBoard2 = [[BoardView alloc] initWithFrame:randomFrame andOrganisms:numOrgs2 atLevel:1];
    theInfo1 = [[Information alloc] initAtLevel:0];
    theInfo2 = [[Information alloc] initAtLevel:1];
}

//Makes sure everything initializes
-(void) testInitSetUp {
    STAssertNotNil(theGameBoard1, @"NumPad Failed to Initialize");
    STAssertNotNil(theBoardModel1, @"GridModel Failed to Initialize");
    STAssertNotNil(theControlButtons1, @"GridGenerator Failed to Initialize");
    STAssertNotNil(theGameBoard2, @"NumPad Failed to Initialize");
    STAssertNotNil(theBoardModel2, @"GridModel Failed to Initialize");
    STAssertNotNil(theControlButtons2, @"GridGenerator Failed to Initialize");
    STAssertNotNil(theBar, @"GridView Failed to Initialize");
    STAssertNotNil(thePoints, @"Timer Failed to Initialize");
    STAssertNotNil(theInfo1, @"Information Failed to Initialize");
}

//Adds, and then deletes, valid organisms of each type to boardView
-(void) testAddAndDeleteOrganismsToBoardView{
    for(int i=0; i<numOrgs1; i++){
       [theGameBoard1 addOrDeleteOrganism:i];
        STAssertEquals([theGameBoard1 numberOfOrganisms:i], 1, @"Organism Not Properly Added To Grassland View");
    }
    for(int i=0; i<numOrgs2; i++){
        [theGameBoard2 addOrDeleteOrganism:i];
        STAssertEquals([theGameBoard2 numberOfOrganisms:i], 1, @"Organism Not Properly Added To Ocean View");
    }
    for(int i=numOrgs1; i<numOrgs1*2; i++){
        [theGameBoard1 addOrDeleteOrganism:i];
        STAssertEquals([theGameBoard1 numberOfOrganisms:i-numOrgs1], 0, @"Organism Not Properly Deleted From Grassland View");
    }
    for(int i=numOrgs2; i<numOrgs2*2; i++){
        [theGameBoard2 addOrDeleteOrganism:i];
        STAssertEquals([theGameBoard2 numberOfOrganisms:i-numOrgs2], 0, @"Organism Not Properly Deleted From Ocean View");
    }
}

//Adds, then deletes, valid organisms of each type from the board model
-(void) testAddAndDeleteOrganismsToBoardModel{
    int population;
    for(int i=0;i<numOrgs1; i++){
        [theBoardModel1 addOrDeleteOrganism:i byValue:1];
        population=((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:(i)]))->population;
        STAssertEquals(population, 1, @"Organism Not Properly Added To Grassland Model");
    }
    
    for(int i=0;i<numOrgs2; i++){
        [theBoardModel2 addOrDeleteOrganism:i byValue:1];
        population=((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:(i)]))->population;
        STAssertEquals(population, 1, @"Organism Not Properly Added To Ocean Model");
    }
    
    for(int i=numOrgs1; i<numOrgs1*2; i++){
        [theBoardModel1 addOrDeleteOrganism:i byValue:1];
        population=((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:(i-numOrgs1)]))->population;
        STAssertEquals(population, 0, @"Organism Not Properly Deleted From Grassland Model");
    }
    for(int i=numOrgs2; i<numOrgs2*2; i++){
        [theBoardModel2 addOrDeleteOrganism:i byValue:1];
        population=((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:(i-numOrgs2)]))->population;
        STAssertEquals(population, 0, @"Organism Not Properly Deleted From Ocean Model");
    }
}

//Adds invalid organisms of each type to boardView to make sure it doesn't work
-(void) testAddAndDeleteInvalidOrganismsToBoardView{
    STAssertThrows([theGameBoard1 addOrDeleteOrganism:50], @"Trying to Add Invalid Organism to View");
    STAssertThrows([theGameBoard1 addOrDeleteOrganism:-1], @"Trying to Add Invalid Organism (negative) to Grassland View");
    STAssertThrows([theGameBoard2 addOrDeleteOrganism:50], @"Trying to Add Invalid Organism to View");
    STAssertThrows([theGameBoard2 addOrDeleteOrganism:-1], @"Trying to Add Invalid Organism (negative) to Grassland View");
}

//Adds invalid organisms of each type to boardModel to make sure it doesn't work
-(void) testAddAndDeleteInvalidOrganismsToBoardModel{
    STAssertThrows([theGameBoard1 addOrDeleteOrganism:50], @"Trying to Add Invalid Organism to Model");
    STAssertThrows([theGameBoard1 addOrDeleteOrganism:-1], @"Trying to Add Invalid Organism (negative) to Ocean Model");
    STAssertThrows([theGameBoard2 addOrDeleteOrganism:50], @"Trying to Add Invalid Organism to Model");
    STAssertThrows([theGameBoard2 addOrDeleteOrganism:-1], @"Trying to Add Invalid Organism (negative) to Ocean Model");
}

//Makes sure height is zero with imbalance
-(void) testBarSizeGivenBalanceConstants{
    [theBar setEcosystemImbalance:1 givenDirection:1];
    int height = theBar->bar.frame.size.height;
    STAssertEquals(height,0,@"Bar Height Not Zero With Complete Imbalance");
}

//Makes sure it isn't green when it's imbalanced or red when it's balanced
-(void) testBarColorGivenBalanceConstants{
    STAssertFalse([theBar calcBarColor:0]==[UIColor colorWithRed: 0. green: 1 blue:0. alpha:1.0], @"When imbalanced, color is green");
    STAssertFalse([theBar calcBarColor:1]==[UIColor colorWithRed: 1. green: 0 blue:0. alpha:1.0], @"When balanced, color is red");
}

//ensures that needed files exist
-(void) testFilesYes{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"grass_org0_add" ofType: @"png"];
    STAssertNotNil(path, @"Can't find org0 add file");
    path = [[NSBundle mainBundle] pathForResource:@"grass_org0_remove" ofType: @"png"];
    STAssertNotNil(path, @"Can't find org0 remove file");
    path = [[NSBundle mainBundle] pathForResource:@"grass_org1_add" ofType: @"png"];
    STAssertNotNil(path, @"Can't find org1 add file");
    path = [[NSBundle mainBundle] pathForResource:@"grass_org1_remove" ofType: @"png"];
    STAssertNotNil(path, @"Can't find org1 remove file");
    path = [[NSBundle mainBundle] pathForResource:@"grass_org2_add" ofType: @"png"];
    STAssertNotNil(path, @"Can't find org2 add file");
    path = [[NSBundle mainBundle] pathForResource:@"grass_org2_remove" ofType: @"png"];
    STAssertNotNil(path, @"Can't find org2 remove file");
    path = [[NSBundle mainBundle] pathForResource:@"grass_org0_small" ofType: @"png"];
    STAssertNotNil(path, @"Can't find org0 small file");
    path = [[NSBundle mainBundle] pathForResource:@"grass_org1_small" ofType: @"png"];
    STAssertNotNil(path, @"Can't find org1 small file");
    path = [[NSBundle mainBundle] pathForResource:@"grass_org2_small" ofType: @"png"];
    STAssertNotNil(path, @"Can't find org2 small file");
    path = [[NSBundle mainBundle] pathForResource:@"background0" ofType: @"png"];
    STAssertNotNil(path, @"Can't find grass background file");
    path = [[NSBundle mainBundle] pathForResource:@"token_pic" ofType: @"png"];
    STAssertNotNil(path, @"Can't find token pic file");
    path = [[NSBundle mainBundle] pathForResource:@"title0" ofType: @"png"];
    STAssertNotNil(path, @"Can't find title file");
    path = [[NSBundle mainBundle] pathForResource:@"icon" ofType: @"png"];
    STAssertNotNil(path, @"Can't find icon file");
    path = [[NSBundle mainBundle] pathForResource:@"poof" ofType: @"png"];
    STAssertNotNil(path, @"Can't find death image file");
    path = [[NSBundle mainBundle] pathForResource:@"instruction_overlay" ofType: @"png"];
    STAssertNotNil(path, @"Can't find instruction file");
    path = [[NSBundle mainBundle] pathForResource:@"dinfo1" ofType: @"txt"];
    STAssertNotNil(path, @"Can't find disaster information file");
    path = [[NSBundle mainBundle] pathForResource:@"info1" ofType: @"txt"];
    STAssertNotNil(path, @"Can't find ocean organism information file");
    path = [[NSBundle mainBundle] pathForResource:@"info0" ofType: @"txt"];
    STAssertNotNil(path, @"Can't find grassland organism information file");
}

//ensures that files are being read properly
-(void) testFilesNo{
    //makes sure it DOESN'T find file that doesn't exist
    NSString* path = [[NSBundle mainBundle] pathForResource:@"org2000" ofType: @"png"];
    STAssertNil(path, @"Found file that doesn't exist");
}

//Integration test.  Makes sure the method we use to update the boardview really does so
-(void) testUpdateMethod{
    int modelPop;
    //Adds 3 of each organism to Model
    for(int i=0;i<numOrgs1; i++){
        [theBoardModel1 addOrDeleteOrganism:i byValue:1];
        [theBoardModel1 addOrDeleteOrganism:i byValue:1];
        [theBoardModel1 addOrDeleteOrganism:i byValue:1];
    }
    for(int i=0; i<numOrgs2; i++){
        [theBoardModel2 addOrDeleteOrganism:i byValue:1];
        [theBoardModel2 addOrDeleteOrganism:i byValue:1];
        [theBoardModel2 addOrDeleteOrganism:i byValue:1];
    }
    //View shouldn't have any orgs yet
    for(int i=0; i<numOrgs1; i++){
        STAssertEquals([theGameBoard1 numberOfOrganisms:i], 0, @"Grassland Organism That Wasn't Added Appearing");
    }
    for(int i=0; i<numOrgs2; i++){
        STAssertEquals([theGameBoard2 numberOfOrganisms:i], 0, @"Ocean Organism That Wasn't Added Appearing");
    }
    //Updates as we do in ViewController
    for(int i=0; i<numOrgs1; i++){
        modelPop = (((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:i]))->population);
        while (modelPop>[theGameBoard1 numberOfOrganisms:i]){
            [theGameBoard1 addOrDeleteOrganism:i];
        }
        while (modelPop<[theGameBoard1 numberOfOrganisms:i]){
            [theGameBoard1 addOrDeleteOrganism:i+numOrgs1];
        }
    }
    for(int i=0; i<numOrgs2; i++){
        modelPop = (((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:i]))->population);
        while (modelPop>[theGameBoard2 numberOfOrganisms:i]){
            [theGameBoard2 addOrDeleteOrganism:i];
        }
        while (modelPop<[theGameBoard2 numberOfOrganisms:i]){
            [theGameBoard2 addOrDeleteOrganism:i+numOrgs1];
        }
    }
    //Makes sure view1 has the organisms now
    for(int i=0; i<numOrgs1; i++){
        STAssertEquals([theGameBoard1 numberOfOrganisms:i], 3, @"Grassland Organism Not Added To View");
    }
    //Makes sure view2 has the organisms now
    for(int i=0; i<numOrgs2; i++){
        STAssertEquals([theGameBoard2 numberOfOrganisms:i], 3, @"Ocean Organism Not Added To View");
    }
    //Deletes all the orgs we added to Model
    for(int i=numOrgs1;i<numOrgs1*2; i++){
        [theBoardModel1 addOrDeleteOrganism:i byValue:1];
        [theBoardModel1 addOrDeleteOrganism:i byValue:1];
        [theBoardModel1 addOrDeleteOrganism:i byValue:1];
    }
    for(int i=numOrgs2;i<numOrgs2*2; i++){
        [theBoardModel2 addOrDeleteOrganism:i byValue:1];
        [theBoardModel2 addOrDeleteOrganism:i byValue:1];
        [theBoardModel2 addOrDeleteOrganism:i byValue:1];
    }
    //Uses update system as we do in ViewController
    for(int i=0; i<numOrgs1; i++){
        modelPop = (((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:i]))->population);
        while (modelPop>[theGameBoard1 numberOfOrganisms:i]){
            [theGameBoard1 addOrDeleteOrganism:i];
        }
        while (modelPop<[theGameBoard1 numberOfOrganisms:i]){
            [theGameBoard1 addOrDeleteOrganism:i+numOrgs1];
        }
    }
    //Makes sure organisms were deleted from view
    for(int i=0; i<numOrgs1; i++){
        STAssertEquals([theGameBoard1 numberOfOrganisms:i], 0, @"Grassland Organism Not Deleted from View");
    }
    
    for(int i=0; i<numOrgs2; i++){
        modelPop = (((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:i]))->population);
        while (modelPop>[theGameBoard2 numberOfOrganisms:i]){
            [theGameBoard2 addOrDeleteOrganism:i];
        }
        while (modelPop<[theGameBoard2 numberOfOrganisms:i]){
            [theGameBoard2 addOrDeleteOrganism:i+numOrgs2];
        }
    }
    //Makes sure organisms were deleted from view
    for(int i=0; i<numOrgs2; i++){
        STAssertEquals([theGameBoard2 numberOfOrganisms:i], 0, @"Ocean Organism Not Deleted from View");
    }
}

//Integration text to make sure organism is added to both the model and board
-(void) testForModelAdditionGivenViewChange{
    //Adds to view, and then to Model
    for(int i=0; i<numOrgs1; i++){
        [theGameBoard1 addOrDeleteOrganism:i];
        [theBoardModel1 addOrDeleteOrganism:i byValue:1];
        int modelPop= (((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:i]))->population);
        STAssertEquals(modelPop, 1, @"Grassland Organism Not Added to Model");
    }
    //removes from view, and then from model
    for(int i=numOrgs1; i<2*numOrgs1; i++){
        [theGameBoard1 addOrDeleteOrganism:i];
        [theBoardModel1 addOrDeleteOrganism:i byValue:1];
        int modelPop=(((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:i-numOrgs1]))->population);
        STAssertEquals(modelPop, 0, @"Grassland Organism Not Deleted From Model");
    }
    //Adds to view, and then to Model
    for(int i=0; i<numOrgs2; i++){
        [theGameBoard2 addOrDeleteOrganism:i];
        [theBoardModel2 addOrDeleteOrganism:i byValue:1];
        int modelPop= (((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:i]))->population);
        STAssertEquals(modelPop, 1, @"Ocean Organism Not Added to Model");
    }
    //removes from view, and then from model
    for(int i=numOrgs2; i<2*numOrgs2; i++){
        [theGameBoard2 addOrDeleteOrganism:i];
        [theBoardModel2 addOrDeleteOrganism:i byValue:1];
        int modelPop=(((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:i-numOrgs2]))->population);
        STAssertEquals(modelPop, 0, @"Ocean Organism Not Deleted From Model");
    }
}

//Makes sure if user gains bonus points they remain
-(void) testForAddingPermenantPoints{
    (theStatusModel->bonusPoints=50);
    STAssertEquals((theStatusModel->bonusPoints), 50, @"50 points not consistently added");
}

//Makes sure points can't be negative
-(void) testForNegativePoints{
    (theStatusModel->bonusPoints=-50);
    STAssertEquals([theStatusModel numPointsGivenImbalance:1], 0, @"Negative points added");
}

//Makes sure adding points doesn't affect bonus points
-(void) testForNormalPoints{
    (theStatusModel->bonusPoints=0);
    [thePoints updatePoints:10];
    STAssertEquals((theStatusModel->bonusPoints), 0, @"Points not successfully updated");
}

//the Model should be imbalanced with a value of 0.99 if an organism is missing and hasn't been added yet
-(void) testForImbalanceWhenOrganismsMissing{
    //It should be imbalanced if all organisms haven't been added yet
    for(int i=0;i<numOrgs1-1;i++){
        [theBoardModel1 addOrDeleteOrganism:i byValue:1];
        float imbalance=[theBoardModel1 systemImbalance];
        float wantedImbalance=.99;
        STAssertTrue(imbalance==wantedImbalance, @"Grassland System not imbalanced before organisms added");
        [theBoardModel1 addOrDeleteOrganism:i+numOrgs1 byValue:1];
    }
    for(int i=0;i<numOrgs2-1;i++){
        [theBoardModel2 addOrDeleteOrganism:i byValue:1];
        float imbalance=[theBoardModel2 systemImbalance];
        float wantedImbalance=.99;
        STAssertTrue(imbalance==wantedImbalance, @"Ocean System not imbalanced before organisms added");
        [theBoardModel2 addOrDeleteOrganism:i+numOrgs2 byValue:1];
    }
}

//the Model should be completely imbalanced (with a value of 1) if an organism is missing and hasn't been added yet
-(void) testForImbalanceWhenOrganismsMissingAfterAdding{
    //It should be imbalanced if all organisms aren't on the board
    for(int i=0;i<numOrgs1;i++){
        [theBoardModel1 addOrDeleteOrganism:i byValue:1];
        [theBoardModel1 addOrDeleteOrganism:i+numOrgs1 byValue:1];
    }
    float imbalance=[theBoardModel1 systemImbalance];
    float wantedImbalance=1;
    STAssertTrue(imbalance==wantedImbalance, @"Grassland System not totally imbalanced with missing orgs");
    
    //It should be imbalanced if all organisms aren't on the board
    for(int i=0;i<numOrgs2;i++){
        [theBoardModel2 addOrDeleteOrganism:i byValue:1];
        [theBoardModel2 addOrDeleteOrganism:i+numOrgs2 byValue:1];
    }
    imbalance=[theBoardModel2 systemImbalance];
    wantedImbalance=1;
    STAssertTrue(imbalance==wantedImbalance, @"Ocean System not totally imbalanced with missing orgs");
}

//Makes sure it's imbalanced when ratios are off, with too many middle organisms
-(void) testForImbalanceWithTooManyMiddleOrgs{
    //If there are way too many bunnies it shouldn't be balanced
    for(int i=0;i<numOrgs1;i++){
        [theBoardModel1 addOrDeleteOrganism:i byValue:1];
        [theBoardModel1 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:1 byValue:1];
    }
    float imbalance=[theBoardModel1 systemImbalance];
    STAssertFalse(imbalance<0.25, @"Grassland System balanced with too many middle organisms");
    
    //If there are way too many bunnies it shouldn't be balanced
    for(int i=0;i<numOrgs2;i++){
        [theBoardModel2 addOrDeleteOrganism:i byValue:1];
        [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
    }
    imbalance=[theBoardModel2 systemImbalance];
    STAssertFalse(imbalance<0.25, @"Ocean System balanced with too many middle organisms");
}

//Makes sure it's imbalanced when ratios are off, with too few middle organisms
-(void) testForImbalanceWithTooFewMiddleOrgs{
    //If there are way FEW bunnies it shouldn't be balanced either
    for(int i=0;i<numOrgs1;i++){
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:i byValue:1];
        [theBoardModel1 addOrDeleteOrganism:2 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:2 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:3 byValue:1];
    }
    float imbalance=[theBoardModel1 systemImbalance];
    STAssertFalse(imbalance<0.25, @"Grassland System balanced with too few middle organisms");
    
    for(int i=0;i<numOrgs2;i++){
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:i byValue:1];
        [theBoardModel2 addOrDeleteOrganism:2 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:2 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:3 byValue:1];
    }
    imbalance=[theBoardModel2 systemImbalance];
    STAssertFalse(imbalance<0.25, @"Ocean System balanced with too few middle organisms");
}

//Makes sure it's balanced when ratios are good
-(void) testForBalanceWithGoodRatios{
    //These ratios are good; the board should be balanced with them
    for(int i=0;i<5;i++){
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel1 addOrDeleteOrganism:2 byValue:1];
    }
    int imbalance=[theBoardModel1 systemImbalance];
    STAssertEquals(imbalance, 0, @"Grassland System not balanced with good ratios");
    for(int i=0;i<5;i++){
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:2 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:2 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:2 byValue:1];
        [theBoardModel2 addOrDeleteOrganism:3 byValue:1];
    }
    imbalance=[theBoardModel2 systemImbalance];
    STAssertEquals(imbalance, 0, @"Ocean System not balanced with good ratios");
}

//tests our updateBoard function to make sure births/deaths are actually calculated
-(void) testNetOrganism{
    //Makes sure the updateBoard function actually DOES something
    //Has to be called many times as probabilities are low
    [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
    [theBoardModel1 addOrDeleteOrganism:1 byValue:1];
    [theBoardModel1 addOrDeleteOrganism:1 byValue:1];
    [theBoardModel1 addOrDeleteOrganism:1 byValue:1];
    [theBoardModel1 addOrDeleteOrganism:1 byValue:1];
    int plantsBefore =(((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:0]))->population);
    int bunniesBefore =(((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:1]))->population);
    int wolvesBefore =(((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:2]))->population);
    for(int i=0; i<10000; i++){
        [theBoardModel1 updateBoard];
    }
    int plantsAfter =(((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:0]))->population);
    int bunniesAfter=(((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:1]))->population);
    int wolvesAfter =(((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:2]))->population);
    STAssertFalse((wolvesAfter==wolvesBefore&&plantsAfter==plantsBefore&&bunniesAfter==bunniesBefore),
                  @"No grassland population change after large number of updates");
}

//tests our updateBoard function to make sure births/deaths are actually calculated for level two
-(void) testNetOrganismLevelTwo{
    //Makes sure the updateBoard function actually DOES something
    //Has to be called many times as probabilities are low
    [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
    [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
    [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
    [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
    [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
    int phytoBefore =(((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:0]))->population);
    int jelliesBefore =(((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:1]))->population);
    for(int i=0; i<10000; i++){
        [theBoardModel2 updateBoard];
    }
    int phytoAfter =(((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:0]))->population);
    int jelliesAfter=(((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:1]))->population);
    STAssertFalse((phytoAfter==phytoBefore&&jelliesAfter==jelliesBefore),
                  @"No ocean population change after large number of updates");
}

//Ensure number of organisms in view correspond to expected numbers
-(void) testOrgNumsInView{
    //Makes sure the function that returns array count gives the expected number of organisms
    for (int i=0; i<numOrgs1; i++){
        [theGameBoard1 addOrDeleteOrganism:i];
        [theGameBoard1 addOrDeleteOrganism:i];
        [theGameBoard1 addOrDeleteOrganism:i];
        STAssertEquals([theGameBoard1 numberOfOrganisms:i], 3, @"added grassland organisms not showing up in organism count");
    }
    //Makes sure the function that returns array count gives the expected number of organisms
    for (int i=0; i<numOrgs2; i++){
        [theGameBoard2 addOrDeleteOrganism:i];
        [theGameBoard2 addOrDeleteOrganism:i];
        [theGameBoard2 addOrDeleteOrganism:i];
        STAssertEquals([theGameBoard2 numberOfOrganisms:i], 3, @"added ocean organisms not showing up in organism count");
    }
}

//Makes sure populations, food counts, and pred counts are all updating, and are consistant 
-(void) testForEqualityOfPopsPredsAndFood{
    //after adding 1 wolf, 2 bunnies, and 3 plants, bunny's foodcount should be 3 and pred count should be 1, etc.
    [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
    [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
    [theBoardModel1 addOrDeleteOrganism:0 byValue:1];
    [theBoardModel1 addOrDeleteOrganism:1 byValue:1];
    [theBoardModel1 addOrDeleteOrganism:1 byValue:1];
    [theBoardModel1 addOrDeleteOrganism:2 byValue:1];
    int bunnyPopAccordingToBunnies = (((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:1]))->population);
    int bunnyPopAccordingToWolves = (((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:2]))->foodCount);
    int bunnyPopAccordingToPlants = (((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:0]))->predCount);
    int wolfPopAccordingToBunnies = (((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:1]))->predCount);
    int wolfPopAccordingToWolves = (((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:2]))->population);
    int plantPopAccordingToPlants = (((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:0]))->population);
    int plantPopAccordingToBunnies = (((OrganismModel*)([(theBoardModel1->organisms) objectAtIndex:1]))->foodCount);
    bool allEqual = (bunnyPopAccordingToBunnies==bunnyPopAccordingToWolves)&&(bunnyPopAccordingToWolves==bunnyPopAccordingToPlants)&&               (wolfPopAccordingToBunnies==wolfPopAccordingToWolves)&&(plantPopAccordingToBunnies==plantPopAccordingToPlants);
    STAssertTrue(allEqual, @"Grassland Populations don't match");
    
}

//Makes sure populations, food counts, and pred counts are all updating, and are consistant, for level 2
-(void) testForEqualityOfPopsPredsAndFoodLevelTwo{
    [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
    [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
    [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
    [theBoardModel2 addOrDeleteOrganism:0 byValue:1];
    [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
    [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
    [theBoardModel2 addOrDeleteOrganism:1 byValue:1];
    [theBoardModel2 addOrDeleteOrganism:2 byValue:1];
    [theBoardModel2 addOrDeleteOrganism:2 byValue:1];
    [theBoardModel2 addOrDeleteOrganism:3 byValue:1];
    int tunaPopAccordingToSharks = (((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:3]))->foodCount);
    int tunaPopAccordingToTuna = (((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:2]))->population);
    int tunaPopAccordingToJellies = (((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:1]))->predCount);
    int jellyPopAccordingToTuna = (((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:2]))->foodCount);
    int jellyPopAccordingToPhyto = (((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:0]))->predCount);
    int jellyPopAccordingToJellies = (((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:1]))->population);
    int phytoPopAccordingToJellies = (((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:1]))->foodCount);
    int phytoPopAccordingToPhyto = (((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:0]))->population);
    int sharkPopAccordingToTuna = (((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:2]))->predCount);
    int sharkPopAccordingToSharks = (((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:3]))->population);
    bool allEqual = (tunaPopAccordingToJellies==tunaPopAccordingToSharks)&&(tunaPopAccordingToSharks==tunaPopAccordingToTuna)&&
    (jellyPopAccordingToJellies==jellyPopAccordingToPhyto)&&(jellyPopAccordingToPhyto==jellyPopAccordingToTuna)&&
    (phytoPopAccordingToJellies==phytoPopAccordingToPhyto)&&(sharkPopAccordingToSharks==sharkPopAccordingToTuna);
    STAssertTrue(allEqual, @"Ocean Populations don't match");
    
}

//Makes sure there's information on the organisms in level 1
-(void) testForInformationOnOrganismsLevelOne{
    for (int i=0; i<numOrgs1; i++){
        STAssertNotNil([theInfo1->orgInfo objectAtIndex:i], @"Information not found for grassland creature");
    }
}

//Makes sure there's information on the organisms in level 2
-(void) testForInformationOnOrganismsLevelTwo{
    for (int i=0; i<numOrgs2; i++){
        STAssertNotNil([theInfo2->orgInfo objectAtIndex:i], @"Information not found for ocean creature");
    }
}

//Makes sure there's disaster information on level 2
-(void) testForInformationOnDisastersLevelTwo{
    for (int i=0; i<([theBoardModel2->disasters count]); i++){
        STAssertNotNil([theInfo2->disasterInfo objectAtIndex:i], @"Information not found for ocean disaster");
    }
}

//Makes sure there aren't disasters at level 1
-(void) testForDisasterModelImplementationLevelOne{
    //Make sure the model knows there aren't any disasters in level one
    int numDisasters = [theBoardModel1->disasters count];
    STAssertEquals(numDisasters, 0, @"Board model thinks there are disasters in level 0");
}

//Makes sure Board View and Board Model both properly implement disasters in level 2
-(void) testForDisasterModelImplementationLevelTwo{
    //Test boardView to make sure disaster functions work
    for (int i=0; i<([theBoardModel2->disasters count]); i++){
        [theGameBoard2 markAsSeen:i];
        STAssertTrue([theGameBoard2 disasterSeenBefore:i], @"Game Board Mark as Seen Function Not Working");
    }
    
    //test boardModel to make sure changes occur after disaster does
    for (int i=0; i<numOrgs2; i++) {
        //add organisms to be killed
        [theBoardModel2 addOrDeleteOrganism: (i) byValue: 20];
    }
    //deploy a disaster
    [theBoardModel2 deployDisaster];
    
    //make sure populations changed
    int phytoAfter =(((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:0]))->population);
    int jelliesAfter=(((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:1]))->population);
    int tunaAfter =(((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:2]))->population);
    int sharksAfter =(((OrganismModel*)([(theBoardModel2->organisms) objectAtIndex:3]))->population);
    bool allSame = (phytoAfter==20)&&(jelliesAfter==20)&&(tunaAfter==20)&&(sharksAfter==20);
    STAssertFalse(allSame, @"No population change after disaster occured");
}

- (void)tearDown{
    [super tearDown];
}

@end
