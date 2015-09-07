//
//  YYTLoginViewController.h
//  YYTHD
//
//  Created by 崔海成 on 2/18/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UserNameType)
{
    kUserNameTypeUnknow,
    kUserNameTypeEmail,
    kUserNameTypePhone
};

@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    UserNameType userNameType;
    NSString *userName;
    NSString *password;
}

@end
