//
//  XPUIRadioButton.h
//  XPlan
//
//  Created by mjlee on 14-2-25.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPUIRadioGroup;
@interface XPUIRadioButton : UIView{
    CGPoint originalLocation;
}

@property(nonatomic,setter = setIfCheck:) BOOL ifCHeck;
@property(nonatomic,strong) NSString* title;
@property(nonatomic,strong) NSString* value;
@property(nonatomic,weak) XPUIRadioGroup*group;

@end

@interface XPUIRadioGroup : NSObject{
}
@property(nonatomic,strong) NSMutableArray* radios;

-(XPUIRadioGroup*)initWithRadios:(id)firstObj, ...NS_REQUIRES_NIL_TERMINATION;
-(NSString*)getSelectedValue;
@end

