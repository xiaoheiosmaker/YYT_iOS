//
//  PlayHistroyEntity.h
//  YYTHD
//
//  Created by IAN on 13-11-5.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PlayHistoryEntity : NSManagedObject

@property (nonatomic, retain) NSDate * addDate;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * coverAddr;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * keyID;

@end
