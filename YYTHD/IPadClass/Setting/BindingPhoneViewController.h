//
//  BindingPhoneViewController.h
//  YYTHD
//
//  Created by 崔海成 on 2/21/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindingPhoneViewController : UIViewController <UITextFieldDelegate>
{
    NSString *phone;
    NSString *validCode;
    int time;
    NSTimer *validCodetimer;
}
@end
