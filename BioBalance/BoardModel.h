//
//  BoardModel.h
//  BioBalance
//
//  Created by Neal Kemp on 3/12/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <math.h>
#import <objc/runtime.h>
#import "PlantModel.h"
#import "BunnyModel.h"
#import "WolfModel.h"
#import "JellyfishModel.h"
#import "SharkModel.h"
#import "PhytoplanktonModel.h"
#import "TunaModel.h"
#import "OilSpillModel.h"
#import "RedTideModel.h"
#import "WhaleModel.h"

// This class models everything in the game, including balance, organisms, and disasters
@interface BoardModel : NSObject {
@public
    int numOrgs; //constant for the level
    int levelNum; //constant for the level
    int curDisaster; //indicates current disaster
    bool disasterGoing; //whether a disaster is going
    float ecosystemImbalance; //indicates imbalance
    NSMutableArray *organisms; //array of all the organisms in the model, at the given level
    NSMutableArray *disasters; //array of all possible disasters at the given level
}
//Initialize with level constants
- (id) initWithOrganisms: (int) numOrganisms andLevel: (int) level;

//How imbalanced the system is; and average of individual imbalances for the organisms
-(float) systemImbalance;

//returns the imbalance of a particular organism, for the smaller status bars
-(float) getImbalanceGivenOrganism: (int) organism;

//Sees if an organism has a calculated birth or death
-(int) netOrganisms: (OrganismModel*) organism;

//sees if a disaster has been calculated to occur
-(bool) disasterOccurred;

//Choose a random disaster, and adjust populations accordingly
-(void) deployDisaster;

//Updates population counts, predator counts, and food counts for each organism given change
-(void) addOrDeleteOrganism: (int) organism byValue: (int) value;

//Make calculations, change populations, and update imbalance
-(void) updateBoard;

@end