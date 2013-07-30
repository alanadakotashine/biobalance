//
//  TokenView.m
//  BioBalance
//
//  Created by Jessie on 3/9/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "PointsView.h"

@implementation PointsView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //initializes points to 0
        //added points are the extra ones that the user gets for being balanced for long enough;
        //totalPoints is addedPoints plus whatever points they get given system imbalance
        self.backgroundColor=[UIColor blackColor];
        
        //So putting text on top of an image is kind of a pain, so instead I made a button that's always
        //inactive and set the image as the background and the text as the title.
        thePoints = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (self.bounds.size.width), (self.bounds.size.height))];
        [thePoints setBackgroundImage:[UIImage imageNamed:@"token_pic.png"] forState:UIControlStateDisabled];
        [thePoints setTitle:(@"0") forState:UIControlStateNormal];
        [thePoints setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [(thePoints.titleLabel) setFont:[UIFont fontWithName:@"Marker Felt" size:36.0]];
        [thePoints setEnabled:false];
        [self addSubview:thePoints];
    }
    return self;
}

-(void) updatePoints: (int) newNum{
    //Sets the title when the points update
    [thePoints setTitle:[[NSString alloc] initWithFormat:@"%d", newNum] forState:UIControlStateNormal];
}

@end
