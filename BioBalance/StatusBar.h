//
//  StatusBar.h
//  BioBalance
//
//  Created by Jessie on 3/12/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import <UIKit/UIKit.h>

// This class sets up the status bars--both the individual ones under each organism buttons, and the large one indicating overall status
@interface StatusBar : UIView {
@public
    //the bar changes color and height according to ecosystem imbalance
    float ecosystemImbalance;
    //the bar and it's dimensions
    UIImageView* bar;
    int maxHeight;
    int maxWidth;
    int yCenter;
    int xCenter;
}
//set the height based upon the imbalance and direction (as the individual ones grow horizontally and the main one grows vertically)
-(void) setEcosystemImbalance: (float) imbalance givenDirection: (int) direction;

//set color based upon imbalance
-(UIColor*) calcBarColor: (float) imbalance;
@end
