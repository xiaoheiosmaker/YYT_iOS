//
//  YYTLoginView.h
//  YYTHD
//
//  Created by 崔海成 on 11/21/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YYTLoginViewDelegate;

@interface YYTLoginView : UIView <UITextFieldDelegate>
@property (weak, nonatomic) id <YYTLoginViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *userEmailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@protocol YYTLoginViewDelegate <NSObject>

- (void)loginView:(YYTLoginView *)loginView loginWithEmail:(NSString *)emailString password:(NSString *)password;
- (void)registerFromLoginView:(YYTLoginView *)loginView;
- (void)weiboLoginFromLoginView:(YYTLoginView *)loginView;
- (void)forgotPasswordFromLoginView:(YYTLoginView *)loginView;
- (void)registerByPhone:(YYTLoginView *)loginView;

@end
