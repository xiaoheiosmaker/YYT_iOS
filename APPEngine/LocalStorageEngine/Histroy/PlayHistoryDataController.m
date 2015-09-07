//
//  HistoryDataController.m
//  YYTHD
//
//  Created by IAN on 13-11-4.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "PlayHistoryDataController.h"
#import "PlayHistoryEntity.h"
#import "PlayHistoryEntity+Addition.h"
#import "MVItem.h"
#import "MLItem.h"
#import "MLAuthor.h"
#import "AppDelegate.h"

#define kHistoryEntitiesShowsCount 20
#define kHistoryEntitiesMaxCount 20

@interface PlayHistoryDataController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *mvResultsController;
@property (nonatomic, strong) NSFetchedResultsController *mlResultsController;
@property (nonatomic, strong, readonly) NSArray *sortDescriptors;

- (NSManagedObjectContext *)managedObjectContext;
- (void)saveContext;

@end


@implementation PlayHistoryDataController

@synthesize sortDescriptors = _sortDescriptors;

static PlayHistoryDataController *_sharedInstance = nil;
+ (PlayHistoryDataController *)sharedInstance
{
    if (_sharedInstance == nil) {
        _sharedInstance = [[self alloc] init];
    }
    return _sharedInstance;
}

+ (void)releaseSharedInstance
{
    _sharedInstance = nil;
}

- (void)dealloc
{
    [self clearOldHistoryWithController:self.mvResultsController];
    [self clearOldHistoryWithController:self.mlResultsController];
}

- (id)init
{
    if (self = [super init]) {
        [self performFetch];
    }
    return self;
}

#pragma mark - Public
- (NSUInteger)numberOfObjectsWithPlayHistoryType:(PlayHistoryType)type
{
    NSFetchedResultsController *resultController = [self resultControllerWithType:type];
    if ([[resultController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[resultController sections] objectAtIndex:0];
        NSUInteger count = [sectionInfo numberOfObjects];
        if (count > kHistoryEntitiesShowsCount) {
            return kHistoryEntitiesShowsCount;
        }
        return count;
    }
    
    return 0;
}


- (PlayHistoryEntity *)playHistoryEntityAtIndex:(NSInteger)index withType:(PlayHistoryType)type
{
    NSFetchedResultsController *resultController = [self resultControllerWithType:type];
    if (resultController) {
        PlayHistoryEntity *entity = [resultController objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        return entity;
    }
    
    return nil;
}

- (void)addMVItem:(MVItem *)mvItem
{
    PlayHistoryEntity *entity = nil;
    entity = [self getHistoryEntityWithMVItem:mvItem];
    if (entity == nil) {
        entity = [NSEntityDescription insertNewObjectForEntityForName:YYTPlayHistoryEntityName inManagedObjectContext:self.managedObjectContext];
        entity.keyID = mvItem.keyID;
        entity.title = mvItem.title;
        entity.artist = mvItem.artistName;
        entity.coverAddr = [mvItem.coverImageURL absoluteString];
        entity.type = [NSNumber numberWithInteger:PlayHistoryMVType];
    }
    entity.addDate = [NSDate date];
    [self saveContext];
}

- (void)addMLItem:(MLItem *)mlItem
{
    PlayHistoryEntity *entity = nil;
    entity = [self getHistoryEntityWithMLItem:mlItem];
    if (entity == nil) {
        entity = [NSEntityDescription insertNewObjectForEntityForName:YYTPlayHistoryEntityName inManagedObjectContext:self.managedObjectContext];
        entity.keyID = mlItem.keyID;
        entity.title = mlItem.title;
        entity.artist = mlItem.author.nickName;
        entity.coverAddr = [mlItem.coverPic description];
        entity.type = [NSNumber numberWithInteger:PlayHistoryMLType];
    }
    entity.addDate = [NSDate date];
    [self saveContext];
}

- (void)clearData
{
    [self clearMLHistory];
    [self clearMVHistory];
}

- (void)reloadData
{
    [self performFetch];
}

- (void)clearMVHistory
{
    NSFetchedResultsController *resultController = self.mvResultsController;
    NSArray *fetchedObjects = [resultController fetchedObjects];
    [self deleteObjectsInArray:fetchedObjects];
}

- (void)clearMLHistory
{
    NSFetchedResultsController *resultController = self.mlResultsController;
    NSArray *fetchedObjects = [resultController fetchedObjects];
    [self deleteObjectsInArray:fetchedObjects];
}

- (void)deleteObjectsInArray:(NSArray *)array
{
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.managedObjectContext deleteObject:obj];
    }];
    [self saveContext];
}

#pragma mark - Private Actions
- (PlayHistoryEntity *)getHistoryEntityWithMVItem:(MVItem *)mvItem
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:YYTPlayHistoryEntityName];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type==%d && keyID==%@",PlayHistoryMVType,mvItem.keyID];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%s ERROR: %@",__func__,error);
    }
    
    if ([result count] > 0) {
        return [result objectAtIndex:0];
    }
    
    return nil;
}

- (PlayHistoryEntity *)getHistoryEntityWithMLItem:(MLItem *)mlItem
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:YYTPlayHistoryEntityName];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type==%d && keyID==%@",PlayHistoryMLType,mlItem.keyID];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%s ERROR: %@",__func__,error);
    }
    
    if ([result count] > 0) {
        return [result objectAtIndex:0];
    }
    
    return nil;
}


- (NSFetchedResultsController *)resultControllerWithType:(PlayHistoryType)type
{
    NSFetchedResultsController *resultController = nil;
    switch (type) {
        case PlayHistoryMVType:
            resultController = self.mvResultsController;
            break;
        case PlayHistoryMLType:
            resultController = self.mlResultsController;
        default:
            break;
    }
    return resultController;
}


#pragma mark - Custom Getter
//按添加日期的排序
- (NSArray *)sortDescriptors
{
    if (_sortDescriptors == nil) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"addDate" ascending:NO];
        _sortDescriptors = @[sortDescriptor];
    }
    
    return _sortDescriptors;
}

//搜索结果控制器
- (NSFetchedResultsController *)mvResultsController
{
    if (_mvResultsController == nil) {
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:YYTPlayHistoryEntityName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type==%d",PlayHistoryMVType];
        [request setPredicate:predicate];
        [request setSortDescriptors:self.sortDescriptors];
        
        NSFetchedResultsController *resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        resultsController.delegate = self;
        _mvResultsController = resultsController;
    }
    
    return _mvResultsController;
}

- (NSFetchedResultsController *)mlResultsController
{
    if (_mlResultsController == nil) {
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:YYTPlayHistoryEntityName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %d",PlayHistoryMLType];
        [request setPredicate:predicate];
        [request setSortDescriptors:self.sortDescriptors];
        
        NSFetchedResultsController *resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        resultsController.delegate = self;
        _mlResultsController = resultsController;
    }
    
    return _mlResultsController;
}

//从获取AppDelegate中CoreData相关信息
- (NSManagedObjectContext *)managedObjectContext
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}

#pragma mark - handle Data
- (void)performFetch
{
    NSError *mvError = nil;
    [self.mvResultsController performFetch:&mvError];
    
    NSError *mlError = nil;
    [self.mlResultsController performFetch:&mlError];
    
    if (mvError || mlError) {
        NSLog(@"error:[%@],[%@]",mvError,mlError);
    }
}

- (void)clearOldHistoryWithController:(NSFetchedResultsController *)controller
{
    NSInteger entitiesCount = [controller.fetchedObjects count];
    if (entitiesCount > kHistoryEntitiesMaxCount) {
        NSArray *oldEntities = [controller.fetchedObjects subarrayWithRange:NSMakeRange(kHistoryEntitiesMaxCount, entitiesCount-kHistoryEntitiesMaxCount)];
        [oldEntities makeObjectsPerformSelector:@selector(deleteFromContext:) withObject:self.managedObjectContext];
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        TTDCONDITIONLOG(error, @"%@",error);
    }
}


- (void)saveContext
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate saveContext];
}

/*
#pragma mark - NSFetchedResultsControllerDelegate
//当搜索结果发生改变时，会调用下面的方法
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"before :%d",(int)[self numberOfObjectsWithPlayHistoryType:PlayHistoryMVType]);
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"after :%d",(int)[self numberOfObjectsWithPlayHistoryType:PlayHistoryMVType]);
}
*/

@end
