//
//  Bunny.m
//  BioBalance
//
//  Created by Jessie on 3/9/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "BunnyView.h"

@implementation BunnyView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //we set bunnies to move 20, but have a delay, so they look like they're hopping
        displacement = 20;
        speed = 0.5;
        delay =3;
        [newOrganism setImage:[UIImage imageNamed:@"grass_org1_small.png"]];
        [self addSubview:newOrganism];
        
    }
    return self;
}

@end
