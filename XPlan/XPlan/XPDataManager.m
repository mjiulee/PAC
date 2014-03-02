//
//  XPDataManager.m
//  XPlan
//
//  Created by mjlee on 14-2-22.
//  Copyright (c) 2014年 mjlee. All rights reserved.
//

#import "XPDataManager.h"
#import "NSDate+Conversions.h"

@interface XPDataManager(){
}
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation XPDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - CoreData
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
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
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    //这里的URLForResource:@"lich" 的url名字（lich）要和你建立datamodel时候取的名字是一样的，至于怎么建datamodel很多教程讲的很清楚
#if IfCoreDataDebug
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"XPlanModel" withExtension:@"momd"];
#else
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"XPlanModel" withExtension:@"momd"];
#endif
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
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
#if IfCoreDataDebug
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XPlanModel.sqlite"];
#else
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XPlanModel.sqlite"];
#endif
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
#pragma mark - test 
-(BOOL)insertTest:(NSString*)title date:(NSDate*)adate
{
    NSManagedObjectContext *context = [self managedObjectContext];
    TestModel* newtest  = [NSEntityDescription insertNewObjectForEntityForName:@"TestModel"
                                                       inManagedObjectContext:context];
    
    do
    {
        if (!newtest){
            break;
        }
        [newtest setValue:title forKey:@"title"];
        [newtest setValue:adate forKey:@"date"];
        NSError *error;
        if(![context save:&error]){
            NSLog(@"Task Add fail：%@",[error localizedDescription]);
            break;
        }else{
            NSLog(@"Task Add succes");
        }
        return YES;
    } while (NO);
    return NO;
}

-(BOOL)queryTest:(int)page size:(int)asize
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setFetchLimit:asize];
    [fetchRequest setFetchOffset:page];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TestModel"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError* error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (TestModel *info in fetchedObjects) {
        NSLog(@"title:%@", [info valueForKey:@"title"]);
        NSLog(@"date:%@", [info valueForKey:@"date"]);
    }
    return YES;
}

#pragma mark - task-list-curd
-(void)insertTask:(NSString*)brief
           status:(int)status
             date:(NSDate*)adate
          project:(ProjectModel*)project;
{
   NSManagedObjectContext *context = [self managedObjectContext];
   TaskModel* newTask  = [NSEntityDescription insertNewObjectForEntityForName:@"TaskModel"
                                                      inManagedObjectContext:context];
    do
    {
        if (!newTask){
            break;
        }
        newTask.brief = brief;
        newTask.create_date = adate;
        newTask.status= [NSNumber numberWithInteger:status];
        newTask.finish_date = nil;
        newTask.project = nil;
        
        NSError *error;
        if(![context save:&error]){
            NSLog(@"Task Add fail：%@",[error localizedDescription]);
            break;
        }
    } while (NO);
}

-(void)updateTask:(TaskModel*)task2update
            brief:(NSString*)brief
           status:(int)status
          project:(ProjectModel*)project
{
    NSManagedObjectContext *context = [self managedObjectContext];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"brief=%@",task2update.brief];
    //首先建立一个request,这里相当于sqlite中的查询条件，具体格式参考苹果文档
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"TaskModel"
                                   inManagedObjectContext:context]];
    [request setPredicate:predicate];

    NSError *error = nil;
    //这里获取到的是一个数组，你需要取出你要更新的那个obj
    NSArray *result = [context executeFetchRequest:request error:&error];
    for (TaskModel *info in result){
        info.brief = brief;
        info.status= [NSNumber numberWithInteger:status];
        if ([context save:&error]) {
            NSLog(@"更新成功");
        }else{
            NSLog(@"更新失败");
        }
    }
}
//-(void)deleteTask:(NSNumber*)taskId{
//    
//}
//
-(NSArray*)selectTaskByDay:(NSDate*)day
{
    NSManagedObjectContext *context = [self managedObjectContext];
    // 查询条件
    NSDate* dayBegin = [day beginingOfDay];
    NSDate* dayEnd   = [day endOfDay];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(create_date >= %@) AND (create_date <= %@)", dayBegin,dayEnd];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"TaskModel"
                                   inManagedObjectContext:context]];
    [request setPredicate:predicate];

    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    NSLog(@"result=%@",result.description);
    return result;
}

#pragma mark - project-list-curd
-(void)insertProject:(NSString*)name
{
    NSManagedObjectContext *context = [self managedObjectContext];
    ProjectModel* project  = [NSEntityDescription insertNewObjectForEntityForName:@"ProjectModel"
                                                        inManagedObjectContext:context];
    do
    {
        if (!project){
            break;
        }
        project.name = name;
        NSError *error;
        if(![context save:&error]){
            NSLog(@"Project Add fail：%@",[error localizedDescription]);
            break;
        }
    } while (NO);
}

-(NSArray*)selectProject:(NSInteger)page size:(NSInteger)size
{
    NSManagedObjectContext *context = [self managedObjectContext];
    // 查询条件
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"ProjectModel"
                                   inManagedObjectContext:context]];
    [request setFetchLimit:size];
    [request setFetchOffset:page];

    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    return result;
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
