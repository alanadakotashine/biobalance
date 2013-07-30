//
//  StatusBar.m
//  BioBalance
//
//  Created by Jessie on 3/10/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "StatusBar.h"

@implementation StatusBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor blackColor];
    maxHeight= self.bounds.size.height;
    maxWidth = self.bounds.size.width;
    yCenter = self.center.y;
    xCenter=self.center.x;
    return self;
}

//set the height based upon the imbalance and direction (as the individual ones grow horizontally and the main one grows vertically)
-(void) setEcosystemImbalance:(float)imbalance givenDirection:(int) direction{
    if (direction==0){
        //0 means grow vertically
        [self setCenter:CGPointMake (xCenter, yCenter+(maxHeight/2)-(maxHeight*((1-imbalance)/2)))];
        [self setBounds:CGRectMake(0,0, maxWidth, maxHeight*(1-imbalance))];
    }
    else{
        //otherwise, grow horizontally
        [self setCenter:CGPointMake (xCenter-(maxWidth/2)+(maxWidth*((1-imbalance)/2)), yCenter)];
        [self setBounds:CGRectMake(0,0, maxWidth*(1-imbalance), maxHeight)];
    }
    [self calcBarColor: imbalance];
}

//sets the color of the bar to be greener when it's balanced, and more red when it's imbalanced
-(UIColor*) calcBarColor: (float) imbalance{
    UIColor* color;
    float balance = 1-imbalance;
    float distFromMid = (balance-.5);
    float scale = 1-(fabsf(distFromMid)*2.0);
    if (distFromMid < 0){
        color =  [UIColor colorWithRed: 1. green: scale blue:0 alpha:1.0];
        [self setBackgroundColor: color];
        [self setNeedsDisplay];
        
    }
    else{
        color =  [UIColor colorWithRed: scale green: 1. blue:0. alpha:1.0];
        [self setBackgroundColor: color];
        [self setNeedsDisplay];
    }
    return color;
}

@end