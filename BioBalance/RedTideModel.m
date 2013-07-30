//
//  RedTideModel.m
//  BioBalance
//
//  Created by jarthur on 4/9/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "RedTideModel.h"

@implementation RedTideModel
-(id) init{
    self=[super init];
    //INCREASE phytoplankton, as that's what red tide IS
    //decrease everything else
    percentKilled[0]=-1;
    percentKilled[1]=0.98;
    percentKilled[2]=0.9;
    percentKilled[3]=0.25;
    return self;
}

@end
