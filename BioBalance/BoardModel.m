//
//  BoardModel.m
//  BioBalance
//
//  Created by Neal Kemp on 3/12/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "BoardModel.h"

#define ARC4RANDOM_MAX      0x100000000

@implementation BoardModel

//Initialize with level constants
- (id) initWithOrganisms: (int) numOrganisms andLevel: (int) level{
    self = [super init];
    numOrgs=numOrganisms;
    disasterGoing=false;
    levelNum = level;
    curDisaster = 0;
    organisms = [[NSMutableArray alloc] init];
    disasters=[[NSMutableArray alloc]init];
    if (levelNum==0){
        [organisms addObject:[[PlantModel alloc]init]];
        [organisms addObject:[[BunnyModel alloc]init]];
        [organisms addObject:[[WolfModel alloc]init]];
    }
    if (levelNum==1){
        [organisms addObject:[[PhytoplanktonModel alloc]init]];
        [organisms addObject:[[JellyfishModel alloc]init]];
        [organisms addObject:[[TunaModel alloc]init]];
        [organisms addObject:[[SharkModel alloc]init]];
        
        [disasters addObject:[[OilSpillModel alloc]init]];
        [disasters addObject:[[RedTideModel alloc] init]];
        [disasters addObject:[[WhaleModel alloc] init]];
    }
    ecosystemImbalance = 1.0;
    return self;
}

//How imbalanced the system is; and average of individual imbalances for the organisms
-(float) systemImbalance{
    //If you don't have all the organisms it's very imbalanced (though not enough
    //to start subtracting points and let you lose, if all organisms hadn't been added before)
    bool somethingZero = false;
    bool allAddedOnce = true;
    float toReturn = 0;
    for (int i=0; i<numOrgs; i++){
        OrganismModel *currentOrg = ((OrganismModel*)([organisms objectAtIndex:i]));
        if (currentOrg->population==0){
            somethingZero = true;
            if (currentOrg->addedOnce==false){
                allAddedOnce = false;
            }
        }
        toReturn += [currentOrg imbalance];
    }
    //if an organism has a pop of 0 and they've all been added before, it's perfectly imbalanced; otherwise it's almost perfectly imbalanced
    if (somethingZero==true){
        if(allAddedOnce==false){
            return 0.99;
        }
        return 1;
    }
    return toReturn/numOrgs;
}

//returns the imbalance of a particular organism, for the smaller status bars
-(float) getImbalanceGivenOrganism: (int) organism{
    return [((OrganismModel*)([organisms objectAtIndex:organism])) imbalance];
}

//Sees if an organism has a calculated birth or death
-(int) netOrganisms: (OrganismModel*) organism{
    int net = 0;
    //Sets a random number and sees if there's a birth
    double randomNum = ((double)arc4random() / ARC4RANDOM_MAX);
    if (randomNum <= [organism probabilityOfBirth]){
        net++;
    }
    //sets a new random number and sees if there's a death
    randomNum = ((double)arc4random() / ARC4RANDOM_MAX);
    if (randomNum <= [organism probabilityOfDeath] && (organism->population>0)){
        net--;
    }
    //returns 0 if both or neither happened, 1 if only birth, and -1 if only death
    return net;
}

//sees if a disaster has been calculated to occur
-(bool) disasterOccurred{
    //If the level has no disasters, or a disaster is already happening, it's always false;
    if ([disasters count]==0 || disasterGoing){
        return false;
    }
    //depends on how well the player is doing; if they're struggling, it's less likely,
    //and if they're completely imbalanced it won't happen.
    double randomNum = ((double)arc4random() / ARC4RANDOM_MAX);
    if (randomNum > 0.003 * (1-ecosystemImbalance)){
        return false;
    }
    return true;
}

//Choose a random disaster, and adjust populations accordingly
-(void) deployDisaster{
    disasterGoing=true;
    //if phytoplankten population is too high, aviod red tide; if it's very high, deploy a whale
    //to control the number of UIViews as too many will cause game to freeze.
    //Please note: This is just a quick fix for a bug we were having and does not
    //exhibit any game logic. 
    if (((OrganismModel*)[organisms objectAtIndex:0])->population>=75){
        curDisaster=2;
    }
    else if (((OrganismModel*)[organisms objectAtIndex:0])->population>=55){
        curDisaster=0;
    }
    else{
        curDisaster = arc4random() % [disasters count];
    }
    DisasterModel* disaster = [disasters objectAtIndex:curDisaster];
    float numDead;
    int pop;
    for (int i=0;i<numOrgs;i++){
        //go through and change the populations
        pop = ((OrganismModel*)[organisms objectAtIndex:i])->population;
        numDead = pop * (disaster->percentKilled[i]);
        [self addOrDeleteOrganism: (i+numOrgs) byValue: numDead];
    }
}

//Updates population counts, predator counts, and food counts for each organism given change
-(void) addOrDeleteOrganism: (int) organism byValue: (int) value{
    NSAssert(organism>=0&&organism<2*numOrgs, @"Invalid organism entered");
    //Adds organisms
    if(organism<numOrgs){
        //Always update population count
        [((OrganismModel*)[organisms objectAtIndex:organism]) wasAdded];
        ((OrganismModel*)[organisms objectAtIndex:organism])->population+=value;
        if(organism>0){
            //Update pred count of organism that the current one feeds on
            //(plants are never predators, so we never update a predator count with plants)
            ((OrganismModel*)[organisms objectAtIndex:organism-1])->predCount+=value;
        }
        if(organism<numOrgs-1){
            //Update food count of the organism that eats the current one
            //(wolves are never predators, so we never update food count with wolves)
            ((OrganismModel*)[organisms objectAtIndex:organism+1])->foodCount+=value;
        }
    }
    //Deletes organisms (using same methods)
    else{
        ((OrganismModel*)[organisms objectAtIndex:organism-numOrgs])->population-=value;
        if(organism-numOrgs>0){
            ((OrganismModel*)[organisms objectAtIndex:organism-1-numOrgs])->predCount-=value;
        }
        if(organism-numOrgs+1<numOrgs){
            ((OrganismModel*)[organisms objectAtIndex:organism-numOrgs+1])->foodCount-=value;
        }
    }
}

//Make calculations, change populations, and update imbalance
-(void) updateBoard {
    for(int i=0; i<numOrgs; i++){
        //uses previous function to update the populations, based upon changes calculated by netOrganisms
        int net = [self netOrganisms:[organisms objectAtIndex:i]];
        if (net<0){
            [self addOrDeleteOrganism:i+numOrgs byValue:1];
        }
        if (net>0){
            [self addOrDeleteOrganism:i byValue:1];
        }
    }
    
    //Update imbalance
    ecosystemImbalance = [self systemImbalance];
}

@end