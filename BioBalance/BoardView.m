//
//  BoardView.m
//  BioBalance
//
//  Created by Jessie on 3/8/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "BoardView.h"

@implementation BoardView

-(id)initWithFrame:(CGRect)frame andOrganisms: (int) numOrganisms atLevel: (int) level{
    self = [super initWithFrame:frame];
    if (self) {
        numOrgs = numOrganisms;
        levelNum = level;
        CGRect frame = CGRectMake(0,0,self.bounds.size.width, self.bounds.size.height);
        //initialize array of organism arrays
        allOrgs=[[NSMutableArray alloc] init];
        for (int i=0; i<numOrgs; i++){
            [allOrgs addObject:[[NSMutableArray alloc] init]];
        }
        //initialize disaster array
        allDisasters=[[NSMutableArray alloc]init];
        if(levelNum==1){
            [allDisasters addObject:[[OilSpillView alloc]initWithFrame:frame]];
            [allDisasters addObject:[[RedTideView alloc]initWithFrame:frame]];
            [allDisasters addObject:[[WhaleView alloc] initWithFrame:frame]];
        }
        //Sets the gameboard (it would be easy to set different backgrounds if we want, say, an ocean level)
        gameBoard = [[UIImageView alloc] initWithFrame:frame];
        NSString *imageName =[[NSString alloc] initWithFormat:@"background%d.png",level];
        [gameBoard setImage:[UIImage imageNamed:imageName]];
        [self addSubview:gameBoard];
    }
    return self;
}

//returns the number of organisms the view is displaying
-(int)numberOfOrganisms:(int) orgNum{
    if (orgNum<numOrgs){
        return [[allOrgs objectAtIndex:orgNum] count];
    }
    else{
        return [[allOrgs objectAtIndex:orgNum-numOrgs] count];
    }
}

//Function adds appropriate organism based upon level number; here's where new code would go if new levels were added
-(OrganismView*) addSpecificOrgGivenNum: (int) orgNum andFrame: (CGRect) frame{
    OrganismView* newOrg;
    if (levelNum==0){
        //We need to specify the organism based upon the org num
        if (orgNum==0){
            newOrg=[[PlantView alloc] initWithFrame:frame];
        }
        if (orgNum==1){
            newOrg=[[BunnyView alloc] initWithFrame:frame];
        }
        if (orgNum==2){
            newOrg=[[WolfView alloc] initWithFrame:frame];
        }
    }
    if (levelNum==1){
        if (orgNum==0){
            newOrg=[[PhytoplanktonView alloc] initWithFrame:frame];
        }
        if (orgNum==1){
            newOrg=[[JellyfishView alloc] initWithFrame:frame];
        }
        if (orgNum==2){
            newOrg=[[TunaView alloc] initWithFrame:frame];
        }
        if (orgNum==3){
            newOrg=[[SharkView alloc] initWithFrame:frame];
        }
    }
    return newOrg;
}

// adds organism to game at random location on the board, or removes it from the board and the array
-(void) addOrDeleteOrganism: (int) orgNum{
    NSAssert(orgNum>=0&&orgNum<2*numOrgs, @"Invalid organism entered");
    float randx = 0;
    float randy = 0;
    //nums 0-orgNum-1 indicate addition
    if (orgNum<numOrgs){
        if (orgNum == 0) {
            //randomly places them on the board; plants don't move so they can spread out more without ever exceeding the bounds.
            randx = arc4random_uniform(self.bounds.size.width-60);
            randy = arc4random_uniform(self.bounds.size.height-60);
        }
        else{
            //randomly places them on the board
            randx = arc4random_uniform(self.bounds.size.width-240)+120;
            randy = arc4random_uniform(self.bounds.size.height-240)+120;
        }
        CGRect frame = CGRectMake(randx, randy, 60, 60);
        OrganismView* newOrg = [self addSpecificOrgGivenNum: orgNum andFrame:frame];
        //add organism to appropriate array, and set it to animate
        [[allOrgs objectAtIndex:orgNum] addObject:newOrg];
        [newOrg animateOrganism];
        [self addSubview:newOrg];
    }
    //Organisms can only be deleted if there's an instance to delete
    //we remove the image from the view and delete it from the array
    else{
        int orgCount=[[allOrgs objectAtIndex:orgNum-numOrgs] count];
        if (orgCount>0){
            OrganismView *removedOrg = [[allOrgs objectAtIndex:orgNum-numOrgs] objectAtIndex:orgCount-1];
            [removedOrg killOrganism];
            [[allOrgs objectAtIndex:orgNum-numOrgs] removeLastObject];
        }
    }
}

//pauses the animals on the board
-(void) stopBoard{
    for (int j=1; j<numOrgs;j++){
        int orgCount=[[allOrgs objectAtIndex:j] count];
        for(int i=0;i<orgCount;i++){
            OrganismView *removedOrg = [[allOrgs objectAtIndex:j] objectAtIndex:i];
            [removedOrg removeAnimation];
        }
    }
}

//re-animates all animals on the board
-(void) resumeBoard{
    for (int j=1; j<numOrgs;j++){
        int orgCount=[[allOrgs objectAtIndex:j] count];
        for(int i=0;i<orgCount;i++){
            OrganismView *removedOrg = [[allOrgs objectAtIndex:j] objectAtIndex:i];
            [removedOrg resumeAnimation];
        }
    }
}

//sees if a disaster has been seen before (so viewcontroller knows whether to send an alert)
-(bool) disasterSeenBefore: (int) disasterNum{
    DisasterView* dView =[allDisasters objectAtIndex:disasterNum];
    return dView->seenBefore;
}

//sets "seen before" as true for a specific disaster.
-(void) markAsSeen: (int) disasterNum{
    DisasterView* dView =[allDisasters objectAtIndex:disasterNum];
    dView->seenBefore=true;
}

//makes the disaster visable
-(void) deployDisaster: (int) disasterNum{
    DisasterView* dView =[allDisasters objectAtIndex:disasterNum];
    [self addSubview:dView];
    [dView deployDisaster];
}

//hides the disaster
-(void) hideDisaster: (int) disasterNum{
    DisasterView* dView =[allDisasters objectAtIndex:disasterNum];
    [self addSubview:dView];
    [dView hideDisaster];
}


@end
