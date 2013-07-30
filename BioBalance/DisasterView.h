//
//  DisasterView.h
//  BioBalance
//
//  Created by jarthur on 4/8/13.
//  Copyright (c) 2013 Team6. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DisasterView;

@interface DisasterView : UIView{
    UIImageView* disasterView;
    @public
    bool seenBefore;
}

-(void) deployDisaster;
-(void) hideDisaster;
-(void) hide;


@end
