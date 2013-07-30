//
//  ControlButtons.h
//  BioBalance
//
//  Created by Jessie on 3/8/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import <UIKit/UIKit.h>

//This class sets up the add and delete buttons

@interface ControlButtons : UIView{
    //arrays which holds the buttons to add and delete organisms from the board
    NSMutableArray* addButtons;
    NSMutableArray* deleteButtons;
    
    //is set according to game level and used as a naming convention for the image files
    NSString* prefix;
    
    // gets constants for the level, as well as selectors and targets for the viewcontroller to see what button is pressed when
    int numOrgs;
    int levelNum;
    id target1;
    SEL selector1;
    id target2;
    SEL selector2;
}
// indicates which button was pressed
@property int organismToAddOrDelete;

//Initialization includes numOrgs and level num
- (id)initWithFrame:(CGRect)frame andOrganisms:(int) numOrganisms andLevel: (int) level;

// When an organism button is pressed to add or delete it, set which organism is to be added or deleted
-(void) organsimAddedOrDeleted: (id) sender;

//lets you set the "remove" button to/from greyscale
-(void) setRemoveButton: (int) orgNum;

//for view controller's button pressed stuff for an addition/deletion
-(void) setTarget1:(id) sender atAction:(SEL)action;

//for view controller's button pressed stuff for a request for information on the organism
-(void) setTarget2:(id) sender atAction:(SEL)action;

//This is the long press gesture recognizer that lets us give the user information about the organism if he holds down the organism button.
- (void)showInfoMessage:(UILongPressGestureRecognizer *)recognizer;

// lets us disable all buttons if user loses
-(void) disableButtons;


@end
