//
//  HomDataControl.m
//  YYTHD
//
//  Created by btxkenshin on 10/14/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "HomeDataController.h"
#import "MVItem.h"
#import "FontPageItem.h"
#import "MVDataController.h"

@interface HomeDataController ()

@end

@implementation HomeDataController

- (void)loadFontPage:(void (^)(NSArray *list, NSError *err))block
{
    __weak HomeDataController *wself = self;
    [[YYTClient sharedInstance] getPath:URL_FONTPAGE parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HomeDataController *sself = wself;
        if (sself) {
            NSArray *datalist = responseObject;
            
            NSMutableArray *listTemp = [NSMutableArray array];
            [datalist enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                //TTDINFO(@"obj:%@",obj);
                NSError *error = nil;
                [listTemp addObject:[MTLJSONAdapter modelOfClass:FontPageItem.class fromJSONDictionary:obj error:&error]];
            }];
            sself.listFrontPage = listTemp;
            
            block(sself.listFrontPage,nil);
        }else{
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

//mv首播
- (void)loadMVPremiere:(void (^)(NSArray *list, NSError *err))block
{
    [self loadMVPremiere:block areaType:MVPremiereAreaTypeALL];
}

- (void)loadMVPremiere:(void (^)(NSArray *list, NSError *err))block areaType:(MVPremiereAreaType)areaType;
{
    NSString *areaCode = [self areaCodeFromType:areaType];
    
    MVDataController *dataController = [MVDataController sharedDataController];
    [dataController loadMVListWithAreaCode:areaCode
                                     range:NSMakeRange(0, 9)
                                completion:^(NSArray * mvList, NSError *error) {
                                    block(mvList, error);
                                }];
}

- (NSString *)areaCodeFromType:(MVPremiereAreaType)areaType
{
    NSString *areaCode = nil;
    switch (areaType) {
        case MVPremiereAreaTypeALL:
            areaCode = @"ALL";
            break;
        case MVPremiereAreaTypeMainland:
            areaCode = @"ML";
            break;
        case MVPremiereAreaTypeHK:
            areaCode = @"HT";
            break;
        case MVPremiereAreaTypeEU:
            areaCode = @"US";
            break;
        case MVPremiereAreaTypeSK:
            areaCode = @"KR";
            break;
        case MVPremiereAreaTypeJP:
            areaCode = @"JP";
            break;
        default:
            areaCode = @"ALL";
            break;
    }
    
    return areaCode;
}

@end
