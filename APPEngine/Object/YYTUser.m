//
//  YYTUser.m
//  YYTHD
//
//  Created by IAN on 13-10-14.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTUser.h"

@implementation YYTUser
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

//归档
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.description forKey:@"description"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.smallAvatar forKey:@"smallAvatar"];
    [aCoder encodeObject:self.largeAvatar forKey:@"largeAvatar"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.createdAt forKey:@"createdAt"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.bindStatus forKey:@"bindStatus"];
}

//反归档
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.uid = [aDecoder decodeObjectForKey:@"uid"];
    self.email = [aDecoder decodeObjectForKey:@"email"];
    self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
    self.description = [aDecoder decodeObjectForKey:@"description"];
    self.gender = [aDecoder decodeObjectForKey:@"gender"];
    self.smallAvatar = [aDecoder decodeObjectForKey:@"smallAvatar"];
    self.largeAvatar = [aDecoder decodeObjectForKey:@"largeAvatar"];
    self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
    self.location = [aDecoder decodeObjectForKey:@"location"];
    self.createdAt = [aDecoder decodeObjectForKey:@"createdAt"];
    self.phone = [aDecoder decodeObjectForKey:@"phone"];
    self.bindStatus = [aDecoder decodeObjectForKey:@"bindStatus"];
    
    NSLog(@"反归档NSURL : %@",self.largeAvatar);
    
    return self;
}

@end
