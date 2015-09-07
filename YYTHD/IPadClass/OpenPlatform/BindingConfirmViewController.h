//
//  BindingViewController.h
//  YYTHD
//
//  Created by 崔海成 on 11/7/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindingConfirmViewController : UIViewController

- (id)initWithConfirmBlock:(void (^)())confirm;

@end
