//
//  YYTAlertView.h
//  YYTHD
//
//  Created by 崔海成 on 2/24/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallbackBlock)();

@interface YYTAlertView : UIView
{
    BOOL isBuilded;
}
@property (nonatomic, weak) UIWindow *oldKeyWindow;
@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic) BOOL success;
@property (nonatomic, strong) NSString *message;
@property (nonatomic) BOOL isConfirmCanelAlert;
@property (nonatomic, copy) CallbackBlock confirmBlock;
@property (nonatomic, copy) CallbackBlock cancelBlock;
+ (void)flashSuccessMessage:(NSString *)message;
+ (void)flashFailureMessage:(NSString *)message;
+ (void)alertMessage:(NSString *)message confirmBlock:(CallbackBlock)confirmBlock;
+ (void)alertMessage:(NSString *)message confirmBlock:(CallbackBlock)confirmBlock cancelBlock:(CallbackBlock)cancelBlock;
- (id)initWithMessage:(NSString *)message;
- (id)initWithMessage:(NSString *)message success:(BOOL)success;
- (id)initWithMessage:(NSString *)message confirmBlock:(CallbackBlock)confirmBlock;
- (id)initWithMessage:(NSString *)message confirmBlock:(CallbackBlock)confirmBlock cancelBlock:(CallbackBlock)cancelBlock;
- (void)show;
- (void)dismiss;
@end
