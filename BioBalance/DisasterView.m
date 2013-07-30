//
//  DisasterView.m
//  BioBalance
//

//  Created by jarthur on 4/8/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "DisasterView.h"

@implementation DisasterView

-(id) initWithFrame:(CGRect)frame{
    //initializes the frame; sets the "seen before" bool to be false.
    self = [super initWithFrame:frame];
    if (self) {
        disasterView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        seenBefore=false;
    }
    return self;
    
}

-(void) deployDisaster{
    //Makes the disaster appear on the screen
    self.hidden=false;
}

-(void) hideDisaster{
    //makes the disaster diasppear from the screen after 6 seconds
    [self performSelector:@selector(hide) withObject:nil afterDelay:6.0];
}

-(void) hide{
    //hides the disaster from the screen
    self.hidden=true;
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
