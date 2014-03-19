//
//  XPHistoryTaskDataHelper.m
//  XPlan
//
//  Created by mjlee on 14-3-18.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPHistoryTaskDataHelper.h"
#import "XPDataManager.h"

@implementation XPHistoryTaskDataHelper
-(id)init{
    self = [super init];
    if (self) {
        NSMutableArray*listNormal    = [[NSMutableArray alloc] init];
        NSMutableArray*listImportant = [[NSMutableArray alloc] init];
        NSMutableArray*listFinished  = [[NSMutableArray alloc] init];
        self.listNormal = listNormal;
        self.listImportant = listImportant;
        self.listFinished  = listFinished;
        
        XPDataManager* dmg = [XPAppDelegate shareInstance].coreDataMgr;
        {
            NSArray* tary = [dmg selectTaskByStatus:0];
            if (tary && [tary count]) {
                [self.listNormal setArray:tary];
            }
        }
        
        {
            NSArray* tary = [dmg selectTaskByStatus:1];
            if (tary && [tary count]) {
                [self.listImportant setArray:tary];
            }
        }
        
        {
            NSArray* tary = [dmg selectTaskByStatus:2];
            if (tary && [tary count]) {
                [self.listFinished setArray:tary];
            }
        }
    }
    return self;
}
@end
