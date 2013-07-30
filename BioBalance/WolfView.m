//
//  Wolf.m
//  BioBalance
//
//  Created by Jessie on 3/9/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "WolfView.h"

@implementation WolfView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //wolves move faster than bunnies, with less delay
        displacement = 30;
        speed = 0.25;
        delay= 1;
        [newOrganism setImage:[UIImage imageNamed:@"grass_org2_small.png"]];
        [self addSubview:newOrganism];
    }
    return self;
}

@end
