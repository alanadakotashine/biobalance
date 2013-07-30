//
//  Information.h
//  BioBalance
//
//  Created by Jessie on 4/8/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import <Foundation/Foundation.h>
//This class is responsible for parsing all of the information on the organisms and disasters out of the files

//We set up the files as follows: the first line gives the name of organism or disaster 0,
//the second line as organism/disaster 1, and so on.  The (number of orgs or disasters) line gives
//the INFORMATION on that organism/disaster.  In this manner we can get the desired
//alert title and information by calling the array at index (currentOrg or disaster), and then
//calling it at index (TOTAL org/disaster + current org/disaster)
@interface Information : NSObject{
@public
    // the arrays hold all the information on the organisms and disasters
    NSArray* orgInfo;
    NSArray* disasterInfo;
    int levelNum;
}

// special initiation to give it the current level, so it reads the right files
-(id)initAtLevel: (int) currentLevel;

// parses the files and reads the information into the arrays so it can be accessed easily for the pop-ups
-(void) parseInfo;

@end
