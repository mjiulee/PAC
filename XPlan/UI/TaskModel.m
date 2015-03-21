//
//  TaskModel.m
//  XPlan
//
//  Created by mjlee on 15/2/11.
//  Copyright (c) 2015年 mjlee. All rights reserved.
//

#import "TaskModel.h"
#import "ProjectModel.h"


@implementation TaskModel

@dynamic content;
@dynamic dateCreate;
@dynamic dateDone;
@dynamic neednotify;
@dynamic notifydate;
@dynamic notifyname;
@dynamic prLevel;
@dynamic sectionIdDaily;
@dynamic sectionIdMonthly;
@dynamic status;
@dynamic type;
@dynamic sectionIdWeakly;
@dynamic project;

- (NSString *)sectionIdMonthly
{
    // Create and cache the section identifier on demand.
    //NSLog(@"%s",__func__);
    [self willAccessValueForKey:@"sectionIdMonthly"];
    NSString *tmp = [self primitiveValueForKey:@"sectionIdMonthly"];
    NSLog(@"%s,tmp=%@",__func__,tmp);
    [self didAccessValueForKey:@"sectionIdMonthly"];
    
    if (!tmp){
        tmp = [[self dateCreate] formattedStringWithFormat:@"YYYY年MM月"];
        [self setPrimitiveValue:tmp forKey:@"sectionIdMonthly"];
    }
    return tmp;
}

- (NSString *)sectionIdDaily
{
    // Create and cache the section identifier on demand.
    //NSLog(@"%s",__func__);
    [self willAccessValueForKey:@"sectionIdDaily"];
    NSString *tmp = [self primitiveValueForKey:@"sectionIdDaily"];
    NSLog(@"%s,tmp=%@",__func__,tmp);
    [self didAccessValueForKey:@"sectionIdDaily"];
    
    if (!tmp){
        tmp = [[self dateCreate] formattedStringWithFormat:@"YYYY年MM月dd日"];
        [self setPrimitiveValue:tmp forKey:@"sectionIdDaily"];
    }
    return tmp;
}

- (NSString *)sectionIdWeakly{
    // Create and cache the section identifier on demand.
    //NSLog(@"%s",__func__);
    [self willAccessValueForKey:@"sectionIdWeakly"];
    NSString *tmp = [self primitiveValueForKey:@"sectionIdWeakly"];
    NSLog(@"%s,tmp=%@",__func__,tmp);
    [self didAccessValueForKey:@"sectionIdWeakly"];
    
    if (!tmp){
        tmp = [[self dateCreate] formattedStringWithFormat:@"YYYY年"];
        tmp = [NSString stringWithFormat:@"%@ 第%d周",tmp,[[self dateCreate] week]];
        [self setPrimitiveValue:tmp forKey:@"sectionIdWeakly"];
    }
    return tmp;
}

- (void)setDateCreate:(NSDate *)dateCreate
{
    //NSLog(@"%s",__func__);
    // If the todoDueDate changes, the section identifier become invalid.
    [self willChangeValueForKey:@"dateCreate"];
    [self setPrimitiveValue:dateCreate forKey:@"dateCreate"];
    [self didChangeValueForKey:@"dateCreate"];
    
    // Set the section identifier to nil, so that it will be recalculated
    // when the sectionIdentifier method is called the next time:
    [self setPrimitiveValue:nil forKey:@"sectionIdDaily"];
    [self setPrimitiveValue:nil forKey:@"sectionIdWeakly"];
    [self setPrimitiveValue:nil forKey:@"sectionIdMonthly"];
}


+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier
{
    // If the value of todoDueDate changes, the section identifier may change as well.
    return [NSSet setWithObject:@"dateCreate"];
}

@end
