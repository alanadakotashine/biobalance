//
//  Organism.h
//  BioBalance
//
//  Created by Jessie on 3/22/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrganismView;

@interface OrganismView : UIView{
    int currentX; //current position
    int currentY;
    int displacement; //how far it moves
    int speed; //how fast it moves
    int direction; //the direction it moves in
    int delay; //delay until repeat move
    bool move; //whether it should move or not
    UIImageView *newOrganism; //the organism
    
}

//animates by moving the specified distance at the specified speed, and then repeats after the specified delay
-(void) animateOrganism;

//makes them stop moving
-(void) removeAnimation;

//lets them move again
-(void) resumeAnimation;

//Makes the "poof" of smoke appear for a delay of 0.05s, and then removes the organism
-(void) killOrganism;

//remove the organism from the view
-(void) removeOrganism;
@end
