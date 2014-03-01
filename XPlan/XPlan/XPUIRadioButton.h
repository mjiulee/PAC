//
//  XPUIRadioButton.h
//  XPlan
//
//  Created by mjlee on 14-2-25.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPUIRadioButton : UIView{
    CGPoint originalLocation;
}

@property(nonatomic) BOOL ifCHeck;
@property(nonatomic,strong) NSString* title;

@end

@interface XPUIRadioGroup : NSObject{
}

@property(nonatomic,strong) NSMutableArray* _radios;
@end

