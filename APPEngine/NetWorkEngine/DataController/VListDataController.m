//
//  VListDataController.m
//  YYTHD
//
//  Created by sunsujun on 13-10-15.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "VListDataController.h"
#import "VListItem.h"
#import "VAreaItem.h"
#import "VListYearItem.h"

@interface VListDataController ()
@property (nonatomic, strong) NSMutableDictionary *areaDict;



@end

@implementation VListDataController{
    
}

- (id)init
{
    self = [super init];
    if(self)
    {
        self.areaDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (void)getCodeWithAreaName:(NSString *)areaName success:(void (^)(VListDataController *, NSString *))success failure:(void (^)(VListDataController *, NSError *))failure{
    
    __weak VListDataController *weekSelf = self;
    [[YYTClient sharedInstance] getPath:URL_VChart_Areas parameters:Nil success:^(id content, id responseObject) {
//        NSLog(@"---%@",responseObject);
        NSArray *areaArray = (NSArray*)responseObject;
        for (int i = 0; i < areaArray.count; i++) {
            NSError *error;
            VAreaItem *vItem = [MTLJSONAdapter modelOfClass:[VAreaItem class] fromJSONDictionary:areaArray[i] error:&error];
            [self.areaDict setObject:vItem.code forKey:vItem.areaName];
        }
        NSString *code = weekSelf.areaDict[areaName];
        success(weekSelf, code);
    } failure:^(id content, NSError *error) {
        failure(self,error);
    }];
}

-(void)getAllVListDateWithArea:(NSString *)areaName success:(void (^)(VListDataController *, NSMutableArray *))success failure:(void (^)(VListDataController *, NSError *))failure{
    //NSLog(@"areaName%@",areaName);
    __weak VListDataController *weakSelf = self;
	[self getCodeWithAreaName:areaName success:^(VListDataController *VListController, NSString *code) {
        NSDictionary *params = [NSDictionary dictionaryWithObject:code forKey:@"area"];
        [[YYTClient sharedInstance] getPath:URL_VChart_Calendar_Period parameters:params success:^(id content, id responseObject) {
            NSError *error;
            NSMutableArray * itemArray = [[NSMutableArray alloc] initWithCapacity:0];
            NSArray *resultArray = (NSArray *)responseObject;
            for (int i = 0; i < resultArray.count; i++) {
                VListYearItem *vYearItem = [MTLJSONAdapter modelOfClass:[VListYearItem class] fromJSONDictionary:[resultArray objectAtIndex:i] error:&error];
                [itemArray addObject:vYearItem];
                NSLog(@"year === %@",vYearItem.year);
            }
            success(weakSelf,itemArray);
        } failure:^(id content, NSError *error) {
            NSLog(@"MVCalendar Error :%@",error);
    
        }];
    } failure:failure];
}

- (void)getSelectVListParams:(NSDictionary *)params success:(void (^)(VListDataController *,VListItem *))success failure:(void (^)(VListDataController *, NSError *))failure{
    __weak VListDataController *weakSelf = self;
    
    [self getCodeWithAreaName:[params objectForKey:@"area"] success:^(VListDataController *vListDataController, NSString *code) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:code,@"area",[params objectForKey:@"datecode"],@"datecode", nil];
        [[YYTClient sharedInstance] getPath:URL_VChart_Show parameters:dict success:^(id content, id responseObject) {
            NSError *error;
            VListItem *vItem = [MTLJSONAdapter modelOfClass:[VListItem class] fromJSONDictionary:responseObject error:&error];
            success(weakSelf,vItem);
        } failure:^(id content, NSError *error) {
            failure(weakSelf,error);
            NSLog(@"error : %@",error);
        }];
    } failure:failure];
    
}


- (void)getSpecialVideoByRange:(NSRange)range success:(void (^)(VListDataController *, NSArray *))success failure:(void (^)(VListDataController *, NSError *))failure{
    __weak VListDataController *weakSelf = self;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",range.location], @"offset", [NSString stringWithFormat:@"%d",range.length],@"size", nil];
    [[YYTClient sharedInstance] getPath:URL_VChart_SpecilList parameters:params success:^(id content, id responseObject) {
        NSMutableArray *specialArray = [NSMutableArray arrayWithCapacity:0];
        [[responseObject objectForKey:@"videos"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSError *error;
            MVItem *mvItem = [MTLJSONAdapter modelOfClass:[MVItem class] fromJSONDictionary:obj error:&error];
            [specialArray addObject:mvItem];
        }];
        success(weakSelf,specialArray);
    } failure:^(id content, NSError *error) {
        failure(weakSelf,error);
    }];
    
}


@end
