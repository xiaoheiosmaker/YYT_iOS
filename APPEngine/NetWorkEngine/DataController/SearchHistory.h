//
//  SearchHistory.h
//  YYTHD
//
//  Created by ssj on 13-11-6.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SearchHistory : NSManagedObject

@property (nonatomic, retain) NSString * searchWord;

@end
