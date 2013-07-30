//
//  ControlButtons.m
//  BioBalance
//
//  Created by Jessie on 3/8/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "ControlButtons.h"

@implementation ControlButtons
@synthesize organismToAddOrDelete;

- (id)initWithFrame:(CGRect)frame andOrganisms:(int) numOrganisms andLevel: (int) level{
    self = [super initWithFrame:frame];
    if (self) {
        numOrgs=numOrganisms;
        levelNum = level;
        //says which level the game is on so the correct button images are added
        if (levelNum==0){
            prefix = [[NSString alloc]initWithFormat:@"grass"];
        }
        if (levelNum==1){
            prefix = [[NSString alloc]initWithFormat:@"ocean"];
        }
        //sets a black background (we might change that eventually), declares sizes, and has the two arrays of buttons
        self.backgroundColor=[UIColor blackColor];
        int width = ((self.bounds.size.width - (15 * (numOrgs+1)))/numOrgs);
        int height = ((self.bounds.size.height - (15 * 3))/2);
        int originX = 15;
        int originYAdd = 15;
        int originYDelete = height+30;
        addButtons =[[NSMutableArray alloc] init];
        deleteButtons =[[NSMutableArray alloc] init];
        //organismToAddOrDelete is from 0 to 2*numOrgs-1, and indicates which organism and whether it's being added or deleted.
        organismToAddOrDelete = 0;
        
        NSString* titleAdd;
        NSString* titleDelete;
        for (int i=0; i<numOrgs; i++){
            //makes the add and delete buttons
            [addButtons addObject:[[UIButton alloc] initWithFrame:CGRectMake(originX, originYAdd, width, height)]];
            [deleteButtons addObject:[[UIButton alloc] initWithFrame:CGRectMake(originX, originYDelete, width, height)]];
            UIButton* currentAddButton = [addButtons objectAtIndex:i];
            UIButton* currentDeleteButton = [deleteButtons objectAtIndex:i];
            
            //sets the tag so we'll be able to communicate which button is highlighted
            [currentAddButton setTag:(i)];
            [currentDeleteButton setTag:(i+numOrgs)];
            
            //adds a long press recoginizer to add buttons so that we can have info messages
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showInfoMessage:)];
            [longPress setMinimumPressDuration:1]; // triggers the action after 1 second of press
            [currentAddButton addGestureRecognizer:longPress];
            
            //adds the buttonPressed methods (different for add and delete)
            [currentAddButton addTarget:self action:@selector(organsimAddedOrDeleted:) forControlEvents:UIControlEventTouchUpInside];
            [currentDeleteButton addTarget:self action:@selector(organsimAddedOrDeleted:) forControlEvents:UIControlEventTouchUpInside];
            
            //Sets the pictures of the buttons, using i to declare the title
            titleAdd=[[NSString alloc] initWithFormat:@"_org%d_add.png",i];
            titleDelete=[[NSString alloc] initWithFormat:@"_org%d_removeb.png",i];
            [currentAddButton setBackgroundImage:[UIImage imageNamed:([prefix stringByAppendingString: titleAdd])] forState:UIControlStateNormal];
            [currentDeleteButton setBackgroundImage:[UIImage imageNamed:([prefix stringByAppendingString: titleDelete])]  forState:UIControlStateNormal];
            
            [self addSubview:currentAddButton];
            [self addSubview:currentDeleteButton];
            
            [currentDeleteButton setEnabled:NO];
            originX +=15+width;
        }
    }
    return self;
}

// When an organism button is pressed to add or delete it, set which organism is to be added or deleted
-(void) organsimAddedOrDeleted: (id) sender{
    //updates current value
    UIButton* newButton = ((UIButton*) sender);
    organismToAddOrDelete = newButton.tag;
    //tells the view controller the button was pressed
    [target1 performSelector: selector1];
    
}

//lets you set the "remove" button to/from greyscale
-(void) setRemoveButton: (int) orgNum{
    UIButton* currentDeleteButton;
    NSString* titleDelete;
    if(orgNum>=numOrgs){
        //this means it was deleted, so it went TO 0, so it should be set as grey.
        currentDeleteButton = [deleteButtons objectAtIndex:orgNum-numOrgs];
        titleDelete=[[NSString alloc] initWithFormat:@"_org%d_removeb.png",orgNum-numOrgs];
        [currentDeleteButton setEnabled:NO];
        
    }
    else{
        //otherwise, set it as the color button
        currentDeleteButton = [deleteButtons objectAtIndex:orgNum];
        titleDelete=[[NSString alloc] initWithFormat:@"_org%d_remove.png",orgNum];
        [currentDeleteButton setEnabled:YES];
    }
    //set the button to the appropriate image
    [currentDeleteButton setBackgroundImage:[UIImage imageNamed:([prefix stringByAppendingString: titleDelete])]  forState:UIControlStateNormal];
}

//for view controller's button pressed stuff for an addition/deletion
-(void) setTarget1:(id) sender atAction:(SEL)action{
    target1=sender;
    selector1 = action;
}

//for view controller's button pressed stuff for a request for information on the organism
-(void) setTarget2:(id) sender atAction:(SEL)action{
    target2=sender;
    selector2 = action;
}

//This is the long press gesture recognizer that lets us give the user information about the organism if he holds down the organism button.
- (void)showInfoMessage:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        UIButton* newButton = ((UIButton*) recognizer.view);
        organismToAddOrDelete = newButton.tag;
        [target2 performSelector:selector2];
    }
}

// lets us disable all buttons if user loses
-(void) disableButtons{
    for (int i=0; i<numOrgs;i++){
        [[deleteButtons objectAtIndex:i] setEnabled:NO];
        [[addButtons objectAtIndex:i] setEnabled:NO];
    }
}

@end
