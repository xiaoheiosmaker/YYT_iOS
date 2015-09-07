//
//  YYTLoginInfo.m
//  YYTHD
//
//  Created by 崔海成 on 10/22/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "YYTLoginInfo.h"
#import <NSValueTransformer+MTLPredefinedTransformerAdditions.h>

@implementation YYTLoginInfo
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}


+ (NSValueTransformer *)userJSONTransformer{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[YYTUserDetail class]];
}

//归档
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    NSNumber* statusNumber = [[NSNumber alloc] initWithInt:self.isLogin];
    [aCoder encodeObject:statusNumber forKey:@"statusNumber"];
    
    [aCoder encodeObject:self.user forKey:@"user"];
    [aCoder encodeObject:self.remark forKey:@"remark"];
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.token_type forKey:@"token_type"];
    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [aCoder encodeObject:self.refresh_token forKey:@"refresh_token"];
}

//反归档
- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSNumber* statusNumber = [aDecoder decodeObjectForKey:@"statusNumber"];
    self.isLogin = [statusNumber intValue];
    
    self.user = [aDecoder decodeObjectForKey:@"user"];
    self.remark = [aDecoder decodeObjectForKey:@"remark"];
    self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
    self.token_type = [aDecoder decodeObjectForKey:@"token_type"];
    self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
    self.refresh_token = [aDecoder decodeObjectForKey:@"refresh_token"];
    
    return self;
}

@end
