//
//  NSDictionary+DealNull.h
//  YYTHD
//
//  Created by btxkenshin on 10/17/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DealNull)


//default:NO
- (BOOL)getBoolValueForKey:(NSString *)key;
- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

//default:0
- (int)getIntValueForKey:(NSString *)key;
- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue;

//default:0
- (time_t)getTimeValueForKey:(NSString *)key;
- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue;

//default:0
- (long long)getLongLongValueForKey:(NSString *)key;
- (long long)getLongLongValueForKey:(NSString *)key defaultValue:(long long)defaultValue;

//default:@""
- (NSString *)getStringValueForKey:(NSString *)key;
- (NSString *)getStringValueForKeyCaseInsensitive:(NSString *)key;
- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

- (NSNumber *)getNumberValueForKey:(NSString *)key;
- (NSNumber *)getNumberValueForKey:(NSString *)key defaultValue:(int)defaultValue;

- (NSURL *)getURLValueForKey:(NSString *)key;
- (NSURL *)getURLValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;


@end
