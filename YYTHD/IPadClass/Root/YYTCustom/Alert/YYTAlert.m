//
//  SendMailView.m
//  YYTHD
//
//  Created by ssj on 13-11-23.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTAlert.h"
#import "UserDataController.h"
#import "YYTLoginInfo.h"


@implementation YYTAlert
{
    void (^_confirmBlock)();
}

- (void)awakeFromNib{
    NSString *email = [UserDataController sharedInstance].loginInfo.user.email;
    self.contentLabel.text = email;
    self.backgroundView.alpha = 0;
    self.commentView.centerY -=372;
    if (email == NULL) {
        self.strLabel.text = @"暂无法评论，您的开放平台账号还没有绑定音悦台账号并验证邮箱，请在设置界面进行绑定";
        self.strLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.hidden = YES;
        self.mailLabel.hidden = YES;
        self.strLabel.hidden = NO;
        self.sendMailAgainBtn.hidden = YES;
        self.sendMailBtn.hidden = YES;
        self.closeBtn.hidden = YES;
        self.sureBtn.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.alertSureBtn.hidden = NO;
    }else{
        self.strLabel.text = @"您好像还没有进行邮箱验证。为不影响部分功能的使用，请先进行邮箱验证";
        self.strLabel.textAlignment = NSTextAlignmentLeft;
        self.sendMailAgainBtn.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.sureBtn.hidden = YES;
        self.alertSureBtn.hidden = YES;
    }
    self.contentLabel.textColor = [UIColor yytGreenColor];
    self.mailLabel.textColor = [UIColor yytDarkGrayColor];
    self.strLabel.textColor = [UIColor yytDarkGrayColor];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithMessage:(NSString *)message confirmBlock:(void (^)())confirmBlock
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"YYTAlert" owner:nil options:nil] lastObject];
    _confirmBlock = confirmBlock;
    if (self) {
        self.strLabel.text = message;
        self.strLabel.textAlignment = NSTextAlignmentCenter;
        self.delegate = nil;
        self.contentLabel.hidden = YES;
        self.mailLabel.hidden = YES;
        self.strLabel.hidden = NO;
        self.sendMailAgainBtn.hidden = YES;
        self.sendMailBtn.hidden = YES;
        self.closeBtn.hidden = YES;
        self.sureBtn.hidden = NO;
        self.cancelBtn.hidden = NO;
        self.alertSureBtn.hidden = YES;
    }
    return self;
}

- (id)initWithMessage:(NSString *)message delegate:(id)delegate{
    self = [[[NSBundle mainBundle] loadNibNamed:@"YYTAlert" owner:delegate options:nil] lastObject];
    if (self) {
        self.strLabel.textAlignment = NSTextAlignmentCenter;
        self.strLabel.text = message;
        self.delegate = delegate;
        self.contentLabel.hidden = YES;
        self.mailLabel.hidden = YES;
        self.strLabel.hidden = NO;
        self.sendMailAgainBtn.hidden = YES;
        self.sendMailBtn.hidden = YES;
        self.closeBtn.hidden = YES;
        self.sureBtn.hidden = NO;
        self.cancelBtn.hidden = NO;
        self.alertSureBtn.hidden = YES;
    }
    return self;
}

- (id)initSureWithMessage:(NSString *)message delegate:(id)delegate{
    self = [[[NSBundle mainBundle] loadNibNamed:@"YYTAlert" owner:delegate options:nil] lastObject];
    if (self) {
        self.strLabel.textAlignment = NSTextAlignmentCenter;
        self.strLabel.text = message;
        self.delegate = delegate;
        self.contentLabel.hidden = YES;
        self.mailLabel.hidden = YES;
        self.strLabel.hidden = NO;
        self.sendMailAgainBtn.hidden = YES;
        self.sendMailBtn.hidden = YES;
        self.closeBtn.hidden = YES;
        self.sureBtn.hidden = YES;
        self.cancelBtn.hidden = YES;
        self.alertSureBtn.hidden = NO;
    }
    return self;
}

- (IBAction)MailBtnClicked:(id)sender {
    self.sendMailAgainBtn.hidden = NO;
    self.sendMailBtn.hidden = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(sendMail:)]) {
        [_delegate sendMail:self];
    }
}
- (IBAction)alertSureBtnClicked:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            self.commentView.centerY -= 422;
        }
        
    }];
}
- (IBAction)closeBtnClicked:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            self.commentView.centerY -= 422;
        }
        
    }];
}
- (IBAction)sureBtnClicked:(id)sender {
//    self.hidden = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(clickSure:)]) {
        [_delegate clickSure:self];
    }
    if (_confirmBlock) {
        _confirmBlock();
        [self removeFromSuperview];
        self.commentView.centerY -= 422;
    }
}

- (void)showInView:(UIView *)container
{
    [container addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.commentView.centerY += 452;
        self.backgroundView.alpha = 0.5;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.commentView.centerY -= 30;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)viewShow{
     UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    [controller.view addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.commentView.centerY += 452;
        self.backgroundView.alpha = 0.5;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.commentView.centerY -= 30;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)viewDismiss{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            self.commentView.centerY -= 422;
        }
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
