//
//  NSDate+Conversions.m
//  XPlan
//
//  Created by mjlee on 14-3-1.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "NSDate+Conversions.h"

@implementation NSDate (Conversions)
- (NSString*)format:(NSString*)format {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:self];
}

- (NSDate *)beginingOfDay
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSMonthCalendarUnit |
                                                    NSYearCalendarUnit  |
                                                    NSHourCalendarUnit  |
                                                    NSMinuteCalendarUnit|
                                                    NSSecondCalendarUnit)
                                          fromDate:self];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [cal dateFromComponents:components];
    
}

- (NSDate*)endOfDay
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSMonthCalendarUnit |
                                                    NSYearCalendarUnit  |
                                                    NSHourCalendarUnit  |
                                                    NSMinuteCalendarUnit|
                                                    NSSecondCalendarUnit)
                                          fromDate:self];
    
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    
    return [cal dateFromComponents:components];
    
}
@end
