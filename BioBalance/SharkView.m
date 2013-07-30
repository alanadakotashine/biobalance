//
//  BarracudaView.m
//  BioBalance
//
//  Created by Jessie on 4/1/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "SharkView.h"

@implementation SharkView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        displacement = 30;
        speed = 0.25;
        delay= 1;
        [newOrganism setImage:[UIImage imageNamed:@"ocean_org3_small.png"]];
        [self addSubview:newOrganism];
    }
    return self;
}

@end
