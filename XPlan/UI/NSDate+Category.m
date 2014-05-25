//
//  NSDate+Category.m
//  
//
//  Created by Youri on 08.08.12.
//  Copyright (c) 2012 MyCompanyName. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)

#define kCalendar [NSCalendar currentCalendar]

#define kDateComponents (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)


#pragma mark -
#pragma mark Comparing dates
- (BOOL) isTheSameDay: (NSDate *) aDate
{
    if (!aDate)
    {
        return NO;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* selfFormatstr = [formatter stringFromDate:self];
    NSString* adateFormatstr= [formatter stringFromDate:aDate];
    return [selfFormatstr isEqualToString:adateFormatstr];
}

- (BOOL) isEarlierDate: (NSDate *) aDate
{
	return ([[self earlierDate:aDate] isEqualToDate:self]);
}

- (BOOL) isLaterDate: (NSDate *) aDate
{
	return ([[self laterDate:aDate] isEqualToDate:self]);
}

- (BOOL) dateBetweenStartDate:(NSDate*)start andEndDate:(NSDate*)end {
    
    BOOL isEarlier = [self isLaterDate:start];
    BOOL isLater = [self isEarlierDate:end];
    
    if (isLater && isEarlier) {
        return YES;
    } else
        return NO;
}

#pragma mark -
#pragma mark Date formatting

- (NSString*)localeFormattedDateString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *ret = [formatter stringFromDate:self];
    
    return ret;
}

- (NSString*)localeFormattedDateStringWithTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    [formatter setLocale:[NSLocale currentLocale]];
    //   [formatter setDateStyle:NSDateFormatterShortStyle];
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}

+ (NSDate *)localeFormatted {
    
    return [[NSDate date] dateFormattedLocale];
}

- (NSDate *)dateFormattedLocale {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *ret = [formatter stringFromDate:self];
    
    return [formatter dateFromString:ret];
}


- (NSString *)formattedStringWithFormat:(NSString *)format
{
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    [formatter setDateFormat:format];
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}

- (NSDate *)dateWithoutTime
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *ret = [formatter stringFromDate:self];
    
    return [formatter dateFromString:ret];
}

+ (NSDate *)dateWithoutTime
{
    return [[NSDate date] dateWithoutTime];
}


#pragma mark -
#pragma mark SQLite formatting

- (NSDate *) dateForSqlite {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; 

    NSString *ret = [formatter stringFromDate:self];
    
    NSDate *date = [formatter dateFromString:ret];
    
    return date;
}

+ (NSDate*) dateFromSQLString:(NSString*)dateStr {
    
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    NSDate *date = [dateForm dateFromString:dateStr];
    return date;
}


#pragma mark -
#pragma mark Beginning and end of date components

- (NSDate *) startOfDay
{
    
    
	NSDateComponents *components = [kCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
											   fromDate:self];
    [components setHour: 0];
    [components setMinute: 0];
    [components setSecond: 0];
    
    return [kCalendar dateFromComponents:components];
}

- (NSDate *) endOfDay
{
    NSDateComponents *components = [kCalendar components: NSUIntegerMax fromDate: self];
    [components setHour: 23];
    [components setMinute: 59];
    [components setSecond: 59];
    
    return [kCalendar dateFromComponents:components];
}


- (NSDate *)beginningOfWeek {
    
    NSDate *beginningOfWeek = nil;
	BOOL ok = [kCalendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
						   interval:NULL forDate:self];
	if (ok) {
		return beginningOfWeek;
	}
    
	// couldn't calc via range, so try to grab Sunday, assuming gregorian style
	// Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [kCalendar components:NSWeekdayCalendarUnit fromDate:self];
    
	/*
	 Create a date components to represent the number of days to subtract from the current date.
	 The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.) */
    
	NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];

    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] + 1)];
	beginningOfWeek = nil;
	beginningOfWeek = [kCalendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
    
	//normalize to midnight, extract the year, month, and day components and create a new date from those components.
	NSDateComponents *components = [kCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
											   fromDate:beginningOfWeek];
	return [kCalendar dateFromComponents:components];
    
}

- (NSDate *)beginningOfMonth {
    
    NSDateComponents *comps = [kCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [comps setDay:1];
    
    return [kCalendar dateFromComponents:comps];
    
}

- (NSDate *)beginningOfYear {
    
    NSDateComponents *comps = [kCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [comps setDay:1];
    [comps setMonth:1];
    
    return [kCalendar dateFromComponents:comps];
    
}

- (NSDate *)endOfWeek {
	NSDateComponents *weekdayComponents = [kCalendar components:NSWeekdayCalendarUnit fromDate:self];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	[componentsToAdd setDay:(8 - [weekdayComponents weekday])];
	NSDate *endOfWeek = [kCalendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    
	return endOfWeek;
}

- (NSDate *)endOfMonth {
    
    NSRange daysRange = [kCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
    
    NSDateComponents *components = [kCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [components setDay:daysRange.length];
    
    return [kCalendar dateFromComponents:components];
}

- (NSDate *)endOfYear {
    
    NSUInteger days = 0;
    NSDateComponents *components = [kCalendar components:NSYearCalendarUnit fromDate:self];
    NSUInteger months = [kCalendar rangeOfUnit:NSMonthCalendarUnit
                                       inUnit:NSYearCalendarUnit
                                      forDate:self].length;
    for (int i = 1; i <= months; i++) {
        components.month = i;
        NSDate *month = [kCalendar dateFromComponents:components];
        days += [kCalendar rangeOfUnit:NSDayCalendarUnit
                               inUnit:NSMonthCalendarUnit
                              forDate:month].length;
    }
    
    NSDateComponents *comps = [kCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];;
    
    [comps setMonth:12];
   
    return [[kCalendar dateFromComponents:comps] endOfMonth];
}

- (NSDate *)dateWithHour:(NSUInteger)hour mintus:(NSInteger)minutes
{
    NSDateComponents *comps = [kCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit| NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:self];
    [comps setHour:hour];
    [comps setMinute:minutes];
    return [kCalendar dateFromComponents:comps];
}

#pragma mark -
#pragma mark Date math

- (NSDate *) dateByAddingDays:(NSInteger)days
{    
    NSDate *date = [self dateByAddingTimeInterval:(days * kSecondsDay)];
	return date;
}

- (NSDate *) dateBySubtractingDays:(NSInteger)days
{
    
    NSDate *date = [self dateByAddingTimeInterval:(-days * kSecondsDay)];
	return date;
}

- (NSDate *) dateByAddingHours:(NSInteger)hours
{
    NSDate *date = [self dateByAddingTimeInterval:(hours * kSecondsHour)];
	return date;
}

- (NSDate *) dateBySubtractingHours:(NSInteger)hours
{
    NSDate *date = [self dateByAddingTimeInterval:(-hours * kSecondsHour)];
    return date;
}

- (NSDate *) dateByAddingMinutes:(NSInteger)minutes
{
    NSDate *date = [self dateByAddingTimeInterval:(minutes * kSecondsMinute)];
	return date;
}

- (NSDate *) dateBySubtractingMinutes:(NSInteger)minutes
{
    NSDate *date = [self dateByAddingTimeInterval:(-minutes * kSecondsMinute)];
	return date;
}


 - (NSDate*) dateByAddingMonth:(int)monthes
{
    NSDateComponents *components = [kCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
     components.month += monthes;
     
     return [kCalendar dateFromComponents:components];
}

- (NSDate*) dateBySubstractingMonth:(int)monthes
{
    NSDateComponents *components = [kCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    components.month -= monthes;
    
    return [kCalendar dateFromComponents:components];
}


#pragma mark Date components

- (NSInteger) hour
{
	NSDateComponents *components = [kCalendar components:kDateComponents fromDate:self];
	return [components hour];
}

- (NSInteger) minute
{
	NSDateComponents *components = [kCalendar components:kDateComponents fromDate:self];
	return [components minute];
}

- (NSInteger) seconds
{
	NSDateComponents *components = [kCalendar components:kDateComponents fromDate:self];
	return [components second];
}

- (NSInteger) day
{
	NSDateComponents *components = [kCalendar components:kDateComponents fromDate:self];
	return [components day];
}

- (NSInteger) month
{
	NSDateComponents *components = [kCalendar components:kDateComponents fromDate:self];
	return [components month];
}

- (NSInteger) week
{
	NSDateComponents *components = [kCalendar components:kDateComponents fromDate:self];
	return [components week];
}

- (NSInteger) weekday
{
	NSDateComponents *components = [kCalendar components:kDateComponents fromDate:self];
	return [components weekday];
}

- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents *components = [kCalendar components:kDateComponents fromDate:self];
	return [components weekdayOrdinal];
}
- (NSInteger) year
{
	NSDateComponents *components = [kCalendar components:kDateComponents fromDate:self];
	return [components year];
}


- (NSString*) monthName {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    [formatter setLocale:[NSLocale currentLocale]];
    
    NSString *stringFromDate = [formatter stringFromDate:self];
    
    return stringFromDate;
}

- (NSString*) yearFromDateStr {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    [formatter setLocale:[NSLocale currentLocale]];
    
    NSString *stringFromDate = [formatter stringFromDate:self];
    
    return stringFromDate;
}


@end
