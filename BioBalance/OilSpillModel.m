//
//  OilSpillModel.m
//  BioBalance
//
//  Created by Jessie on 4/8/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "OilSpillModel.h"

@implementation OilSpillModel
-(id) init{
    self=[super init];
    //decrease populations of everything
    percentKilled[0]=0.9;
    percentKilled[1]=0.25;
    percentKilled[2]=0.75;
    percentKilled[3]=0.5;
    return self;
}

@end
