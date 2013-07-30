//
//  KrillModel.m
//  BioBalance
//
//  Created by Jessie on 4/1/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "PhytoplanktonModel.h"

@implementation PhytoplanktonModel
-(id) init{
    //give plenty of food, because phytoplankton are always balanced food-wise in this model
    self = [super init];
    birthScalar = 0.008;
    deathScalar = 0.01;
    foodCount = 100000000000000;
    return self;
}

@end
