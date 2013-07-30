//
//  WhaleModel.m
//  BioBalance
//
//  Created by Jessie on 4/29/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "WhaleModel.h"

@implementation WhaleModel
-(id) init{
    self=[super init];
    //decrease populations of krill and jellyfish
    percentKilled[0]=0.99;
    percentKilled[1]=0;
    percentKilled[2]=0;
    percentKilled[3]=0;
    return self;
}
@end
