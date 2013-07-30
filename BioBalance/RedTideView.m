//
//  RedTideView.m
//  BioBalance
//
//  Created by jarthur on 4/9/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "RedTideView.h"

@implementation RedTideView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //sets the pic, adds it to subview, and sets it to hidden.
        [disasterView setImage:[UIImage imageNamed:@"disaster1.png"]];
        [self addSubview:disasterView];
        self.hidden=true;
    }
    return self;
}


@end
