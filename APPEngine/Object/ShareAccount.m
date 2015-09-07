//
//  ShareAccount.m
//  YYTHD
//
//  Created by shuilin on 11/2/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "ShareAccount.h"

@implementation ShareAccount

//归档
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    NSNumber* statusNumber = [[NSNumber alloc] initWithInt:self.status];
    
    [aCoder encodeObject:statusNumber forKey:@"statusNumber"];
    [aCoder encodeObject:self.token forKey:@"kToken"];
    [aCoder encodeObject:self.name forKey:@"kName"];
}

//反归档
- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSNumber* statusNumber  = [aDecoder decodeObjectForKey:@"statusNumber"];
    
    self.status = [statusNumber intValue];
    self.token = [aDecoder decodeObjectForKey:@"kToken"];
    self.name = [aDecoder decodeObjectForKey:@"kName"];
    
    return self;
}

@end
