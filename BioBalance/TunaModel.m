//
//  HerringModel.m
//  BioBalance
//
//  Created by Jessie on 4/1/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "TunaModel.h"

@implementation TunaModel
-(id) init{
    self=[super init];
    birthScalar = 0.008;
    deathScalar = 0.01;
    return self;
}
@end
