//
//  OgranismModel.m
//  BioBalance
//
//  Created by Jessie on 3/22/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "OrganismModel.h"

@implementation OrganismModel
    
//Initialize everything to 0
-(id) init{
    foodCount=0;
    predCount=0;
    population = 0;
    addedOnce = false;
    return self;
}

//So the model knows an organism has been added before
-(void) wasAdded{
    addedOnce=true;
}

//If there's no food they don't reproduce; otherwise they reproduce by the function of the birth scalar and the log of their population
-(float) probabilityOfBirth{
    if([self imbalance]<0.05){
        return 0.005;
    }
    if (foodCount==0){
        return 0;
    }
    return birthScalar * (log (population+1));
}

//If there's no food they die; otherwise their death probability depends on the number of predators and food availability
-(float) probabilityOfDeath{
    if([self imbalance]<0.05){
        return 0.005;
    }
    if (foodCount==0){
        return 1;
    }
    if (foodCount<population){
        return (1-(foodCount/population));
    }
    else{
        return deathScalar * log (predCount+1);
    }
}

//A function based upon the ratio of food to the organism and predators to the organism
-(float) imbalance{
    if(population==0){
        return 1;
    }
    //If there's more than the ratio (currently 3) times as much food as there is of the organism,
    //food-wise, that organism is balanced
    if (foodCount>ratio*population){
        //If there's fewer than 1/the ratio (currently 3) times as many predators as organisms,
        //the organism is balanced predator-wise
        if(population>ratio*predCount){
            //If both are true the system is balanced; return 0
            return 0;
        }
        else{
            //If only the predators are out of balance, return a number close to 0 if it's close, and 1
            //otherwise
            return 1-(population/(ratio*predCount));
        }
    }
    else{
        if(population>ratio*predCount){
            //If only the food is out of balanced, return a number close to 0 if it's close, and 0
            //otherwise
            return 1-(foodCount/(ratio*population));
        }
        else{
            //If both are unbalanced, multiply each unbalance together
            return 1-((foodCount/(ratio*population))*(population/(ratio*predCount)));
        }
    }
}
@end
