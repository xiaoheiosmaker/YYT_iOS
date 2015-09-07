//
//  SearchHistoryDataController.m
//  YYTHD
//
//  Created by ssj on 13-11-4.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "SearchHistoryDataController.h"
#import "SearchHistory.h"
@implementation SearchHistoryDataController

- (id)init
{
    self = [super init];
    if(self)
    {
        //queue = dispatch_queue_create("com.yinyuetai.searchhistory", NULL);
        queue = dispatch_get_main_queue();
        [self configureHistoryContext];
    }
    return self;
}

- (void)configureHistoryContext{
    NSManagedObjectModel *manageObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:manageObjectModel];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSURL *storeUrl = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:@"SearchHistory.sqlite"]];
    NSError *error;
//    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
//                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if (![storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        NSLog(@"error :%@, %@",error, [error userInfo]);
    }
    self.historyContext = [[NSManagedObjectContext alloc] init];
    [self.historyContext setPersistentStoreCoordinator:storeCoordinator];
}

- (SearchHistory *)createEntityForHistory{
    SearchHistory *searchHistory = [NSEntityDescription insertNewObjectForEntityForName:@"SearchHistory" inManagedObjectContext:self.historyContext];
    return searchHistory;
}

- (void)saveToHistory{
    NSError *error;
    BOOL isSuccess = [self.historyContext save:&error];
    if (!isSuccess) {
        NSLog(@"error :%@, %@",error, [error userInfo]);
    }
}

- (NSArray *)getHistoryArray{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SearchHistory" inManagedObjectContext:self.historyContext];
    [request setEntity:entityDescription];
    NSArray *array = [[NSArray alloc] initWithObjects:nil];
    [request setSortDescriptors:array];
    NSFetchedResultsController *fetch = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.historyContext sectionNameKeyPath:nil cacheName:nil];
    NSError *error;
    if (![fetch performFetch:&error]) {
        return nil;
    }
    NSMutableArray *wordArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (SearchHistory *search in [[fetch.fetchedObjects reverseObjectEnumerator] allObjects]) {
        [wordArray addObject:search.searchWord];
    }
    return wordArray;
}

- (void)clearHistory{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SearchHistory" inManagedObjectContext:self.historyContext];
    [request setEntity:entityDescription];
    NSArray *array = [[NSArray alloc] initWithObjects:nil];
    [request setSortDescriptors:array];
    NSFetchedResultsController *fetch = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.historyContext sectionNameKeyPath:nil cacheName:nil];
    NSError *error;
    if (![fetch performFetch:&error]) {
        return;
    }
    for (SearchHistory *searchHistory in fetch.fetchedObjects) {
        [self.historyContext deleteObject:searchHistory];
    }
    [self saveToHistory];
}

-(NSFetchedResultsController*)getHistoryListWithWord:(NSString*)word{
    
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SearchHistory" inManagedObjectContext:self.historyContext];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"searchWord = %@",word];
    [request setPredicate:predicate];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nil];//不排序
    [request setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController* fetchedController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.historyContext sectionNameKeyPath:nil cacheName:nil];
    
    NSError* error = nil;
    
    BOOL success = [fetchedController performFetch:&error];
    if(!success)//查询失败
    {
        
    }
    
    return fetchedController;
    
}
-(NSFetchedResultsController*)getAllHistoryList{
    
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SearchHistory" inManagedObjectContext:self.historyContext];
    [request setEntity:entityDescription];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nil];//不排序
    [request setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController* fetchedController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.historyContext sectionNameKeyPath:nil cacheName:nil];
    
    NSError* error = nil;
    
    BOOL success = [fetchedController performFetch:&error];
    if(!success)//查询失败
    {
        
    }
    
    return fetchedController;
    
}

- (void)addToHistory:(NSString *)word{
  
    dispatch_async(queue, ^(void){
        
        if ([word isEqualToString:@""]) {
            return ;
        }
        if ([self getHistoryArray].count >= 10) {
            SearchHistory *search = [[[[self getAllHistoryList].fetchedObjects reverseObjectEnumerator] allObjects] lastObject];
            [self.historyContext deleteObject:search];
        }
        NSFetchedResultsController *fetchedController = [self getHistoryListWithWord:word];
        if (fetchedController.fetchedObjects.count>0) {
            SearchHistory *search = [fetchedController.fetchedObjects lastObject];
            [self.historyContext deleteObject:search];
        }
        
        SearchHistory *search = [NSEntityDescription insertNewObjectForEntityForName:@"SearchHistory" inManagedObjectContext:self.historyContext];
        search.searchWord = word;
        [self saveToHistory];
    });
    
    
}

@end
