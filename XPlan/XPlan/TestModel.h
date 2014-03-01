//
//  TestModel.h
//  XPlan
//
//  Created by mjlee on 14-2-28.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TestModel : NSManagedObject{
    NSString* title;
    NSDate*   date;
}

//@property (nonatomic, retain,setter = setTitle:,getter = getTitle) NSString * title;
//@property (nonatomic, retain,setter = setCdate:,getter = getCdate) NSDate * cdate;

@end
