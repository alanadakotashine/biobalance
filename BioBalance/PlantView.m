//
//  Plant.m
//  BioBalance
//
//  Created by Jessie on 3/9/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "PlantView.h"

@implementation PlantView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //plants don't move, so we just set the animation constats to zero and set the image
        displacement = 0;
        speed = 0;
        delay=0;
        [newOrganism setImage:[UIImage imageNamed:@"grass_org0_small.png"]];
        [self addSubview:newOrganism];
    }
    return self;
}

//since plants don't move, we don't need to animate them
-(void) animateOrganism{
}

@end
