//
//  OgranismModel.h
//  BioBalance
//
//  Created by Jessie on 3/22/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ratio 3 //ratio of food to organism and organism to predator needed to be balanced

@class OrganismModel;

@interface OrganismModel : NSObject {
@public
    float birthScalar; //How likely the organism is to breed
    float deathScalar; //How likely the organism is to die
    float predCount; //number of predators
    float foodCount; //availability of food
    float population; //population of the given organism
    bool addedOnce; //whether the organism has been added to the game before
}

//So the model knows an organism has been added before
-(void) wasAdded;

//If there's no food they don't reproduce; otherwise they reproduce by the function of the birth scalar and the log of their population
-(float) probabilityOfBirth;

//If there's no food they die; otherwise their death probability depends on the number of predators
-(float) probabilityOfDeath;

//A function based upon the ratio of food to the organism and predators to the organism
-(float) imbalance;

@end
