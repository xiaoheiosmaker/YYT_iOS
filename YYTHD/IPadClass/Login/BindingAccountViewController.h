//
//  BindingAccountViewController.h
//  YYTHD
//
//  Created by 崔海成 on 3/7/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelBlock)();

@interface BindingAccountViewController : UIViewController
@property (nonatomic, copy)CancelBlock cancelBlock;
- initWithCancelBlock:(CancelBlock)cancelBlock;
@end
