//
//  WolfModel.m
//  BioBalance
//
//  Created by Jessie on 3/22/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "WolfModel.h"

@implementation WolfModel
-(id) init{
    self=[super init];
    birthScalar = 0.008;
    deathScalar = 0.002;
    return self;
}

-(float) probabilityOfDeath{
    //since wolves have no predators, we wanted them to occationally randomly die out, so we
    //declare a "predator" of random death based upon population.  BUT we don't want that
    //weighing into our imbalance, so we use its own function to do so.
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
        return deathScalar * log(population+1);
    }
}


@end
