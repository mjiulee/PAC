//
//  XPDataManager.m
//  XPlan
//
//  Created by mjlee on 14-2-22.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPDataManager.h"

@interface XPDataManager(){
}
@property (nonatomic, strong, readonly) NSManagedObjectContext *coreDataObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *coreDataObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation XPDataManager
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - CoreData
//相当与持久化方法
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.coreDataObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"coreData:Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
//初始化context对象
- (NSManagedObjectContext *)managedObjectContext
{
    if (_coreDataObjectContext != nil)
    {
        return _coreDataObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _coreDataObjectContext = [[NSManagedObjectContext alloc] init];
        [_coreDataObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _coreDataObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_coreDataObjectModel != nil)
    {
        return _coreDataObjectModel;
    }
    //这里的URLForResource:@"lich" 的url名字（lich）要和你建立datamodel时候取的名字是一样的，至于怎么建datamodel很多教程讲的很清楚
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"XPTarskDb" withExtension:@"momd"];
    _coreDataObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _coreDataObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    //这个地方的.sqlite名字没有限制，就是一个数据库文件的名字
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XPTarskDb.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
                                                             URL:storeURL
                                                         options:nil
                                                           error:&error])
    {
        NSLog(@"coreData:Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory
/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Data CURD
#pragma mark - task-list-curd
-(BOOL)insertTask:(XPT_Task*)task
{
   NSManagedObjectContext *context = [self managedObjectContext];
   XPT_Task* newTask  = [NSEntityDescription insertNewObjectForEntityForName:XPT_Task_SqlTable
                                                      inManagedObjectContext:context];
    do
    {
        if (!newTask){
            break;
        }
        newTask.taskcontent = task.taskcontent;
        newTask.create_date = task.create_date;;
        newTask.done_date   = task.done_date;
        newTask.ifdone      = task.ifdone;
        newTask.update_date = task.update_date;
        newTask.priority    = task.priority;
        newTask.notify_time = task.notify_time;
        
        NSError *error;
        if(![context save:&error]){
            NSLog(@"Task Add fail：%@",[error localizedDescription]);
            break;
        }
        return YES;
    } while (NO);
    return NO;
}
-(void)updateTask:(XPT_Task*)task{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectID = %d",task.objectID];
    //首先建立一个request,这里相当于sqlite中的查询条件，具体格式参考苹果文档
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:XPT_Task_SqlTable inManagedObjectContext:context]];
    [request setPredicate:predicate];

    NSError *error = nil;
    //这里获取到的是一个数组，你需要取出你要更新的那个obj
    NSArray *result = [context executeFetchRequest:request error:&error];
    for (XPT_Task *info in result){
        info.taskcontent = task.taskcontent;
        info.create_date = task.create_date;;
        info.done_date   = task.done_date;
        info.ifdone      = task.ifdone;
        info.update_date = task.update_date;
        info.priority    = task.priority;
        info.notify_time = task.notify_time;
        break;
    }

    //保存, 更新成功
    if ([context save:&error]) {
        NSLog(@"更新成功");
    }
}
-(void)deleteTask:(NSNumber*)taskId{
    
}

-(NSArray*)selectTaskByDay:(NSDate*)day
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // 查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"create_date=%@",day];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:XPT_Task_SqlTable
                                   inManagedObjectContext:context]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    return result;
}

#pragma mark - project-list-curd
-(void)insertProject:(NSDictionary*)projectDict{
    
}

-(void)updateProject:(XPT_Project *)project
{
    
}

-(void)deleteProject:(NSNumber*)pId
{
    
}



/*
- (void)insertCoreData:(NSMutableArray*)dataArray
{
    NSManagedObjectContext *context = [self managedObjectContext];
    /*for (News *info in dataArray) {
        News *newsInfo = [NSEntityDescription insertNewObjectForEntityForName:TableName inManagedObjectContext:context];
        newsInfo.newsid = info.newsid;
        newsInfo.title = info.title;
        newsInfo.imgurl = info.imgurl;
        newsInfo.descr = info.descr;
        newsInfo.islook = info.islook;
        
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }
    }
}

//查询
- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)currentPage
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    
    /*
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setFetchLimit:pageSize];
    [fetchRequest setFetchOffset:currentPage];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (News *info in fetchedObjects) {
        NSLog(@"id:%@", info.newsid);
        NSLog(@"title:%@", info.title);
        [resultArray addObject:info];
    }
    return resultArray;
}

//删除
-(void)deleteData
{
    /*NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}
//更新
- (void)updateData:(NSString*)newsId  withIsLook:(NSString*)islook
{
    /*NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"newsid like[cd] %@",newsId];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:TableName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
    for (News *info in result) {
        info.islook = islook;
    }
    
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}
*/
@end
