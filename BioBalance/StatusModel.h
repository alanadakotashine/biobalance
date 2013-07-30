//
//  StatusModel.h
//  BioBalance
//
//  Created by jarthur on 4/2/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import <Foundation/Foundation.h>
//This class controls the win counter, lose counter, and points

@interface StatusModel : NSObject{
@public
    // win counter sees how long the user has been balanced, lose counter sees how long the user has been imbalanced, stagnantCounter sees if the user has forgotten to add all organisms, and bonus points indicate extra earned points
    int winCounter;
    int loseCounter;
    int stagnantCounter;
    int bonusPoints;
    bool lostGame;
}

//Checks whether the user has won/lost, based upon how long balance/imbalance has been preserved
-(int) checkWinOrLoseGivenImbalance:(float)imbalance;

//Returns the number of points given the imbalance
-(int) numPointsGivenImbalance: (float) imbalance;

@end
