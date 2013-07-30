//
//  PlantModel.m
//  BioBalance
//
//  Created by Jessie on 3/22/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "PlantModel.h"

@implementation PlantModel
-(id) init{
    //give plenty of food, because plants are always balanced food-wise in this model
    //(we assume infinite sunlight)
    self = [super init];
    birthScalar = 0.008;
    deathScalar = 0.01;
    foodCount = 100000000000000;
    return self;
}

@end
