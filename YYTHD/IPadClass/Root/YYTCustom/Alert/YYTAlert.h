//
//  SendMailView.h
//  YYTHD
//
//  Created by ssj on 13-11-23.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YYTAlertDelegate;
@interface YYTAlert : UIView
@property (weak, nonatomic) IBOutlet UIButton *sendMailBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIButton *sendMailAgainBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *strLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (weak, nonatomic) IBOutlet UIButton *alertSureBtn;
@property (weak, nonatomic) id<YYTAlertDelegate>delegate;

- (void)showInView:(UIView *)container;
- (void)viewShow;
- (void)viewDismiss;
- (id)initWithMessage:(NSString *)message delegate:(id)delegate;
- (id)initSureWithMessage:(NSString *)message delegate:(id)delegate;
- (id)initWithMessage:(NSString *)message confirmBlock:(void (^)())confirmBlock;
@end


@protocol YYTAlertDelegate <NSObject>
@optional
- (void)sendMail:(YYTAlert*)yytAlertView;
- (void)clickSure:(YYTAlert *)yytAlertView;

@end