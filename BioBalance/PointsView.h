//
//  TokenView.h
//  BioBalance
//
//  Created by Jessie on 3/9/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import <UIKit/UIKit.h>

// This class displays the points
@interface PointsView : UIView{
    UIButton* thePoints;
}

//Controls the visual representation of the user's points
-(void) updatePoints: (int) newNum;

@end
