//
//  Alert_Tip.h
//  YYTHD
//
//  Created by ssj on 13-11-8.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertWithTip : UIView
@property (nonatomic, strong)UIImageView *backgroundImageView;
@property (nonatomic, strong)UIImageView *alertImageView;
@property (nonatomic, assign)id owner;
@property (nonatomic, assign)BOOL keyboard;
+ (instancetype)defaultSizeViewWithSuccess:(NSString *)message owner:(id)delegate;
+ (instancetype)defaultSizeViewWithFail:(NSString *)message owner:(id)delegate;
- (void)alertShowAndDisMissAfterTimeInterval:(CGFloat)time;

+ (void)flashSuccessMessage:(NSString *)message;
+ (void)flashFailedMessage:(NSString *)message;

+ (void)flashSuccessMessage:(NSString *)message isKeyboard:(BOOL)isKeyboard;
+ (void)flashFailedMessage:(NSString *)message isKeyboard:(BOOL)isKeyboard;

@end
