//
//  LevelController.m
//  BioBalance
//
//  Created by jarthur on 4/2/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "StatusModel.h"

@implementation StatusModel
//Initializes everything to 0
-(id) init{
    self=[super init];
    winCounter=0;
    loseCounter=0;
    bonusPoints = 0;
    lostGame=false;
    return self;
}

-(int) checkWinOrLoseGivenImbalance:(float)imbalance{
    //If they've been COMPLETELY imbalanced for long enough, they lose
    //Before they lose, they start losing points
    if (imbalance==1){
        loseCounter+=5;
        if(loseCounter%75==74){
            bonusPoints-=50;
        }
        if (loseCounter>275){
            lostGame=true;
            return -3;
        }
        winCounter=0;
    }
    else if (imbalance==(float)0.99){
        stagnantCounter+=1;
        if(stagnantCounter>250){
            return 0;
        }
    }
    //If they're really imbalanced, and it's not because they haven't added anything yet, increment by 1.
    else if (imbalance>0.85){
        loseCounter+=1;
        winCounter=0;
    }
    else if (imbalance<=0.02){
        //If they've been balanced for long enough, they win
        //Even before they win, they start gaining points
        winCounter+=1;
        if(winCounter%25==24){
            bonusPoints+=50;
        }
        if (winCounter>=150){
            bonusPoints+=200;
            return -2;
        }
        loseCounter=0;
    }
    else{
        loseCounter = 0;
        winCounter = 0;
    }
    return -1;
}

-(int) numPointsGivenImbalance: (float) imbalance{
    //changes the number of points to the new number, adding the extra points
    if (imbalance>=0.99){
        //if it's totally imbalanced, no points
        return 0;
    }
    //otherwise, points depend on level of imbalance.
    int points = (1-imbalance)*500+bonusPoints;
    if(points<0){
        return 0;
    }
    return points;
}

@end
