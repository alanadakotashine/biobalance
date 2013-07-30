//
//  DisasterModel.h
//  BioBalance
//
//  Created by Jessie on 4/8/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisasterModel : NSObject{
@public
    //holds the percentage of each organism killed; as the largest number of orgs is 4 the array is plenty big enough, but it'll have to
    //be adjusted if enough levels are added
    double percentKilled[15];
}

@end
