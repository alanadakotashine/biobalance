//
//  KrillView.m
//  BioBalance
//
//  Created by Jessie on 4/1/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "PhytoplanktonView.h"

@implementation PhytoplanktonView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        displacement = 0;
        speed = 0;
        delay= 0;
        [newOrganism setImage:[UIImage imageNamed:@"ocean_org0_small.png"]];
        [self addSubview:newOrganism];
    }
    return self;
}

//since plants don't move, we don't need to animate them
-(void) animateOrganism{
}

@end
