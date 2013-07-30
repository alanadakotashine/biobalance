//
//  Organism.m
//  BioBalance
//
//  Created by Jessie on 3/22/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "OrganismView.h"

@implementation OrganismView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //Finds declared x and y positions, and sets beginning direction
        currentX = frame.origin.x;
        currentY = frame.origin.y;
        move=true;
        direction = arc4random()%4;
        newOrganism = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    }
    return self;
}

//animates by moving the specified distance at the specified speed, and then repeats after the specified delay
-(void) animateOrganism{
    //they just move in squares so they never exceed the bounds of the board, and only if the game isn't paused
    [UIView animateWithDuration:speed delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:
     ^(void){
         if (move){
             if (direction==1){
                 currentX+=displacement;
             }
             else if (direction==2){
                 currentX-=displacement;
             }
             else if (direction==3){
                 currentY-=displacement;
             }
             else{
                 currentY+=displacement;
             }
             direction = (direction+1)%4;
             self.frame=CGRectMake(currentX, currentY, self.bounds.size.width, self.bounds.size.height);
         }
        [self performSelector:@selector(animateOrganism) withObject:nil afterDelay:delay];}
        completion:nil];
}

//makes them stop moving
-(void) removeAnimation{
    move=FALSE;
}

//lets them move again
-(void) resumeAnimation{
    move=TRUE;
}

//Makes the "poof" of smoke appear for a delay of 0.05s, and then removes the organism
-(void) killOrganism{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:
     ^(void){
         [newOrganism setImage:[UIImage imageNamed:@"poof.png"]];
         [self performSelector:@selector(removeOrganism) withObject:nil afterDelay:0.05];}
    completion:nil];
}

//remove the organism from the view
-(void) removeOrganism{
    [self removeFromSuperview];
}

@end
