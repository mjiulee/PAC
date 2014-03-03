//
//  NSDate+Category.h
//  
//
//  Created by Youri on 08.08.12.
//  Copyright (c) 2012 MyCompanyName. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSecondsMinute      60
#define kSecondsHour		3600
#define kSecondsDay         86400
#define kSecondsWeek		604800
#define kSecondsYear		31556926

@interface NSDate (Category)

#pragma mark Comparing dates

- (BOOL) isEarlierDate: (NSDate *) aDate;
- (BOOL) isLaterDate: (NSDate *) aDate;
- (BOOL) dateBetweenStartDate:(NSDate*)start andEndDate:(NSDate*)end;

#pragma mark Date formatting

- (NSString*)localeFormattedDateString;
- (NSString*)localeFormattedDateStringWithTime;
+ (NSDate *)localeFormatted;
- (NSDate *)dateFormattedLocale;

- (NSString *)formattedStringWithFormat:(NSString *)format;
- (NSDate *)dateWithoutTime;
+ (NSDate *)dateWithoutTime;

#pragma mark SQLite formatting

- (NSDate *) dateForSqlite;
+ (NSDate*) dateFromSQLString:(NSString*)dateStr;

#pragma mark Beginning and end of date components

- (NSDate *) startOfDay;

- (NSDate *) endOfDay;

- (NSDate *)beginningOfWeek;

- (NSDate *)beginningOfMonth;

- (NSDate *)beginningOfYear;

- (NSDate *)endOfWeek;

- (NSDate *)endOfMonth;

- (NSDate *)endOfYear;

#pragma mark Date math

- (NSDate *) dateByAddingMinutes:(NSInteger)minutes;

- (NSDate *) dateBySubtractingMinutes:(NSInteger)minutes;

- (NSDate *) dateByAddingHours:(NSInteger)hours;

- (NSDate *) dateBySubtractingHours:(NSInteger)hours;

- (NSDate *) dateByAddingDays:(NSInteger)days;

- (NSDate *) dateBySubtractingDays:(NSInteger)days;

- (NSDate *) dateByAddingMonth:(int)monthes;

- (NSDate *) dateBySubstractingMonth:(int)monthes;

#pragma mark Date components

- (NSInteger) seconds;

- (NSInteger) minute;

- (NSInteger) hour;

- (NSInteger) day;

- (NSInteger) month;

- (NSInteger) week;

- (NSInteger) weekday;

- (NSInteger) year;

- (NSString*) monthName;

- (NSString*) yearFromDateStr;


@end
