//
//  DiaryTaskModel.h
//  XPlan
//
//  Created by mjlee on 14-3-22.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DiaryTaskModel : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * weekday;

@end
