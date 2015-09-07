//
//  NSString+ValidInput.h
//  YYTHD
//
//  Created by 崔海成 on 2/18/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ValidInput)
- (BOOL)isValidPhone;
- (BOOL)isValidEmail;
- (BOOL)isValidPassword;
@end
