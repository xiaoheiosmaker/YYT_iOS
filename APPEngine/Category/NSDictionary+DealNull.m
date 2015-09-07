//
//  NSDictionary+DealNull.m
//  YYTHD
//
//  Created by btxkenshin on 10/17/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "NSDictionary+DealNull.h"

@implementation NSDictionary (DealNull)


- (BOOL)getBoolValueForKey:(NSString *)key
{
	return [self getBoolValueForKey:key defaultValue:NO];
}
- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue
{
    return [self objectForKey:key] == [NSNull null] ? defaultValue
    : [[self objectForKey:key] boolValue];
}



- (int)getIntValueForKey:(NSString *)key
{
	return [self getIntValueForKey:key defaultValue:0];
}
- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue
{
	return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] intValue];
}

- (time_t)getTimeValueForKey:(NSString *)key
{
	return [self getTimeValueForKey:key defaultValue:0];
}
- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue
{
	NSString *stringTime   = [self objectForKey:key];
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
	struct tm created;
    time_t now;
    time(&now);
    
	if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		return mktime(&created);
	}
	return defaultValue;
}

- (long long)getLongLongValueForKey:(NSString *)key
{
	return [self getLongLongValueForKey:key defaultValue:0];
}
- (long long)getLongLongValueForKey:(NSString *)key defaultValue:(long long)defaultValue
{
	return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] longLongValue];
}

- (NSString *)getStringValueForKey:(NSString *)key
{
	return [self getStringValueForKey:key defaultValue:@""];
}

- (NSString *)getStringValueForKeyCaseInsensitive:(NSString *)key
{
	if ([self objectForKey:key] == nil) {
		return [self getStringValueForKey:[key uppercaseString] defaultValue:@""];
	}else {
		return [self getStringValueForKey:key defaultValue:@""];
	}
}

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
	if([self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null]){
		return defaultValue;
	}else {
		if ([[self objectForKey:key] isKindOfClass:[NSNumber class]]) {
			return [[self objectForKey:key] stringValue];
		}else {
			return [self objectForKey:key];
		}
        
	}
    
    //	return [self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null]
    //				? defaultValue : (NSString *)[self objectForKey:key];
}

- (NSNumber *)getNumberValueForKey:(NSString *)key
{
	return [self getNumberValueForKey:key defaultValue:0];
}
- (NSNumber *)getNumberValueForKey:(NSString *)key defaultValue:(int)defaultValue
{
	int iValue = [self getIntValueForKey:key defaultValue:defaultValue];
	return [NSNumber numberWithInt:iValue];
}

- (NSURL *)getURLValueForKey:(NSString *)key
{
	return [self getURLValueForKey:key defaultValue:@""];
}

- (NSURL *)getURLValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
	return [NSURL URLWithString:[self getStringValueForKey:key defaultValue:defaultValue]];
}


@end
