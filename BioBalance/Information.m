//
//  Information.m
//  BioBalance
//
//  Created by Jessie on 4/8/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import "Information.h"

@implementation Information

-(id)initAtLevel: (int) currentLevel{
    //gets all the information out of the files.
    self=[super init];
    levelNum=currentLevel;
    [self parseInfo];
    return self;
}


-(void) parseInfo{
    //This reads in the organism file and saves text as an NSString; file name should be infox.txt, where x is the level num
    NSString* file = [[NSString alloc] initWithFormat:@"info%d",levelNum];
    NSString* Path = [[NSBundle mainBundle] pathForResource:file ofType: @"txt"];
    NSError* error;
    NSString* readString = [[NSString alloc] initWithContentsOfFile:Path encoding:NSUTF8StringEncoding error:&error];
    
    //this gets all the lines and saves them in an array
    orgInfo = [readString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    //does the same for disaster information (file name should be dinfox.txt, where x is level nm)
    file = [[NSString alloc] initWithFormat:@"dinfo%d",levelNum];
    Path = [[NSBundle mainBundle] pathForResource:file ofType: @"txt"];
    readString = [[NSString alloc] initWithContentsOfFile:Path encoding:NSUTF8StringEncoding error:&error];
    disasterInfo = [readString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

@end
