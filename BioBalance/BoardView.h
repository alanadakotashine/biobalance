//
//  BoardView.h
//  BioBalance
//
//  Created by Jessie on 3/8/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlantView.h"
#import "BunnyView.h"
#import "WolfView.h"
#import "SharkView.h"
#import "TunaView.h"
#import "JellyfishView.h"
#import "PhytoplanktonView.h"
#import "OilSpillView.h"
#import "RedTideView.h"
#import "WhaleView.h"

@interface BoardView : UIView{
@public
    //initialize arrays of organisms and disasters, as well as constants for the level
    UIImageView* gameBoard;
    NSMutableArray* allOrgs;
    NSMutableArray* allDisasters;
    int numOrgs;
    int levelNum;
}
//Initialize with constants for the level
-(id)initWithFrame:(CGRect)frame andOrganisms: (int) numOrganisms atLevel: (int) level;

//returns the number of organisms the view is displaying
-(int) numberOfOrganisms: (int) orgNum;

//Function adds appropriate organism based upon level number to the game board
-(OrganismView*) addSpecificOrgGivenNum: (int) orgNum andFrame: (CGRect) frame;

// adds organism to game at random location on the board, or removes it from the board and the array
-(void) addOrDeleteOrganism: (int) orgNum;

//pauses the organisms on the board
-(void) stopBoard;

//reanimates organisms
-(void) resumeBoard;

//sees if a disaster has been seen before (so viewcontroller knows whether to send an alert)
-(bool) disasterSeenBefore: (int) disasterNum;

//Mark disaster as seen
-(void) markAsSeen: (int) disasterNum;

//makes the disaster visable
-(void) deployDisaster: (int) disasterNum;

//hides disaster
-(void) hideDisaster: (int) disasterNum;
@end
