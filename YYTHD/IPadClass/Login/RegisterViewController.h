//
//  RegisterViewController.h
//  YYTHD
//
//  Created by 崔海成 on 2/19/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>
{
    NSString *nickName;
    NSString *email;
    NSString *password;
}
@end
