//
//  JellyfishView.m
//  BioBalance
//
//  Created by Jessie on 4/1/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "JellyfishView.h"

@implementation JellyfishView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        displacement = 30;
        speed = 2.5;
        delay= 1;
        [newOrganism setImage:[UIImage imageNamed:@"ocean_org1_small.png"]];
        [self addSubview:newOrganism];
    }
    return self;
}

@end
