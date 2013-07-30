//
//  OilSpillView.m
//  BioBalance
//

//  Created by jarthur on 4/8/13.


//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "OilSpillView.h"

@implementation OilSpillView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //sets the pic, adds it to subview, and sets it to hidden.
        [disasterView setImage:[UIImage imageNamed:@"disaster0.png"]];
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
