//
//  YueDanDataControl.h
//  YYTHD
//
//  Created by 崔海成 on 10/11/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLList.h"
typedef void (^OperationCompletionBlock)(BOOL, NSError *);
typedef void (^FetchMLListCompletionBlock)(NSArray *, NSError *);
typedef void (^FetchMLItemCompletionBlock)(MLItem *, NSError *);

@class MLItem;
@interface MLDataController : NSObject
{
    MLList *_pMLList;
}
+ (MLDataController *)sharedObject;
- (void)fetchPickMLListForRange:(NSRange)range
                     completion:(FetchMLListCompletionBlock)completionBlock;
- (void)fetchMLDetailForID:(NSNumber *)keyID
                completion:(FetchMLItemCompletionBlock)completionBlock;
- (NSArray *)fetchOwnMLListForRange:(NSRange)range
                    completion:(FetchMLListCompletionBlock)completionBlock;
- (void)fetchFavoriteMLList:(NSRange)range
                 completion:(FetchMLListCompletionBlock)completionBlock;
- (void)addFavoriteWithID:(NSNumber *)keyID
               completion:(OperationCompletionBlock)completionBlock;
- (void)deleteFavoriteML:(MLItem *)item completionBlock:(void (^)(NSArray *, NSError *))completion;
- (void)deleteOwnML:(MLItem *)item completionBlock:(void (^)(NSArray *, NSError *))completion;
- (void)uploadCoverImage:(UIImage *)img completionBlock:(void (^)(NSString *imageURL, NSError *error))completion;
- (void)createMLWithTitle:(NSString *)title
                 category:(NSString *)category
                     tags:(NSString *)tags
              description:(NSString *)description
         headImgURLString:(NSString *)URLString
                     vids:(NSString *)vids
          completionBlock:(FetchMLItemCompletionBlock)completionBlock;
- (void)createMLWithTitle:(NSString *)title
          completionBlock:(FetchMLItemCompletionBlock)completionBlock;
- (void)updateMLWithID:(NSNumber *)keyID
                 title:(NSString *)title
               descrip:(NSString *)descrip
             headImage:(NSString *)headImg
       backgroundImage:(NSString *)bgImg
             videoData:(NSArray *)videos
            completion:(OperationCompletionBlock)completionBlock;
- (void)addMV:(NSNumber *)mvID
         toML:(NSNumber *)mlID
   completion:(OperationCompletionBlock)completionBlock;
@end
