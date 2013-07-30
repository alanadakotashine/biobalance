//
//  WhaleView.m
//  BioBalance
//
//  Created by Jessie on 4/29/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "WhaleView.h"

@implementation WhaleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //sets the pic, adds it to subview, and sets it to hidden.
        [disasterView setImage:[UIImage imageNamed:@"disaster2.png"]];
        [self addSubview:disasterView];
        self.hidden=true;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
