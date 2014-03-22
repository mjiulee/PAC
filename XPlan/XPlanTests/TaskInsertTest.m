//
//  TaskInsertTest.m
//  XPlan
//
//  Created by mjlee on 14-3-3.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TaskModel.h"
#import "ProjectModel.h"
#import "XPDataManager.h"
#import "NSDate+Category.h"

@interface TaskInsertTest : XCTestCase
@property(nonatomic,strong)XPDataManager* coreDataManger;
-(void)getItem:(NSString**)brief date:(NSDate**)date status:(NSNumber**)status ext:(int)ext;
@end

@implementation TaskInsertTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    XPDataManager* cdMgr = [[XPDataManager alloc] init];
    self.coreDataManger = cdMgr;
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}


-(void)testForDateHelper{
    NSDate* today = [NSDate date];
    NSDate* dateWithHoure = [today dateWithHour:9 mintus:36];
    NSLog(@"today = %@",[dateWithHoure formattedStringWithFormat:@"yyyy-MM-dd hh:mm"]);
    for (int i = 0 ; i < 5; i ++) {
        NSDate* tomorrow = [dateWithHoure dateByAddingDays:1];
        NSLog(@"tomorrow = %@",[tomorrow formattedStringWithFormat:@"yyyy-MM-dd hh:mm"]);
    }
    XCTAssertNotEqual(YES, YES, @"NSDate Helper is Pass");
}

-(void)testForInsert
{
    BOOL      ifError = NO;
    NSString* title;
    NSDate*   date;
    NSNumber* status = [NSNumber numberWithInt:1];
    // 测试Inser函数的正确性：日期类的：增加
    int ext = 1;
    for (int i = 0 ; i < 5; i ++) {
        // test:
        status = [NSNumber numberWithInt:1];
        [self getItem:&title date:&date status:&status ext:i];
//        [self.coreDataManger insertTask:title
//                                 status:0
//                                   date:date
//                                project:nil];
        [self.coreDataManger insertTask:title
                                   date:date
                                   type:XPTask_Type_User
                                prLevel:XPTask_PriorityLevel_normal
                                project:nil];
        
        // test:
        status = [NSNumber numberWithInt:0];
        [self getItem:&title date:&date status:&status ext:-i];
        [self.coreDataManger insertTask:title
                                   date:date
                                   type:XPTask_Type_User
                                prLevel:XPTask_PriorityLevel_important
                                project:nil];
        continue;
        
        NSLog(@"title=%@,date=%@,ext=%d",title,date.description,ext);
        if (title == nil || date == nil) {
            ifError = YES;
            break;
        }
        /*[self.coreDataManger insertTask:title
                                 status:1
                                   date:date
                                project:nil];
        NSArray* days = [self.coreDataManger selectTaskByDay:date status:0];
        if (!days || [days count] != 1) {
            ifError = YES;
            break;
        }*/
        ext ++;
    }
    /*
    // 测试Inser函数的正确性：日期类的：减少
    ext = -1;
    for (int i = 0 ; i < 5; i ++) {
        [self getItem:&title date:&date status:&status ext:ext];
        NSLog(@"title=%@,date=%@,ext=%d",title,date.description,ext);
        if (title == nil || date == nil) {
            ifError = YES;
            break;
        }
        [self.coreDataManger insertTask:title
                                 status:1
                                   date:date
                                project:nil];
        NSArray* days = [self.coreDataManger selectTaskByDay:date status:0];
        if (!days || [days count] != 1) {
            ifError = YES;
            break;
        }
        ext --;
    }*/
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    XCTAssertNotEqual(ifError, YES, @"NSDate Helper is Pass");
}

- (void)testExample
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    BOOL ifErrof = NO;
    XCTAssertNotEqual(ifErrof, YES, @"NSDate Helper is Pass");
}

-(void)getItem:(NSString**)brief date:(NSDate**)date status:(NSNumber**)status ext:(int)ext
{
    NSDate* today = [NSDate date];
    if (ext < 0) {
        *date = [today dateBySubtractingDays:abs(ext)];
    }else{
        *date = [today dateByAddingDays:ext];
    }
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    *brief = [df stringFromDate:*date];
}

@end
