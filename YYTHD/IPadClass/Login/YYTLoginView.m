//
//  YYTLoginView.m
//  YYTHD
//
//  Created by 崔海成 on 11/21/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "YYTLoginView.h"
#import "YYTAlert.h"
@interface YYTLoginView()
@property (weak, nonatomic) IBOutlet UIButton *clearUserEmailFieldBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearPasswordFieldBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic) BOOL keyboardShown;
- (void)hideKeyboard;
- (void)alertMessage:(NSString *)alertMessage;
@end

@implementation YYTLoginView
@synthesize keyboardShown;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.clearUserEmailFieldBtn.hidden = YES;
    self.clearPasswordFieldBtn.hidden = YES;
    UIColor *color = [UIColor colorWithWhite:1.0 alpha:0.3];
    self.userEmailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的登录邮箱" attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的密码" attributes:@{NSForegroundColorAttributeName: color}];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

- (IBAction)clearUserEmailBtnClicked:(id)sender {
    self.userEmailField.text = @"";
}
- (IBAction)clearPasswordBtnClicked:(id)sender {
    self.passwordField.text = @"";
}
- (IBAction)loginBtnClicked:(id)sender {
    [self hideKeyboard];
    NSString *emailString = self.userEmailField.text;
    NSString *passwordString = self.passwordField.text;
    NSRange range = [emailString rangeOfString:@"@"];
    BOOL emailValid = [emailString length] > 3 && range.location != NSNotFound;
    BOOL passwordValid = [passwordString length] >= 4 && [passwordString length] <= 20;
    if (emailValid && passwordValid) {
        [self.delegate loginView:self loginWithEmail:self.userEmailField.text password:self.passwordField.text];
    }
    else {
        if (!emailValid) {
            [self alertMessage:@"用户邮箱格式错误"];
        }
        else if (!passwordValid) {
            [self alertMessage:@"用户密码长度必须在4～20之间"];
        }
    }
}

- (void)alertMessage:(NSString *)alertMessage
{
    YYTAlert *alert = [[YYTAlert alloc] initSureWithMessage:alertMessage delegate:nil];
    [alert showInView:self];
}

- (IBAction)forgotPasswordBtnClicked:(id)sender {
    [self hideKeyboard];
    [self.delegate forgotPasswordFromLoginView:self];
}
- (IBAction)registerBtnClicked:(id)sender {
    [self hideKeyboard];
    [self.delegate registerFromLoginView:self];
}

// 注册手机帐号
- (IBAction)registeByPhone:(id)sender
{
    [self hideKeyboard];
    [self.delegate registerByPhone:self];
}

- (IBAction)weiboLoginBtnClicked:(id)sender {
    [self hideKeyboard];
    [self.delegate weiboLoginFromLoginView:self];
}
- (IBAction)closeBtnClicked:(id)sender {
    [self hideKeyboard];
    self.userEmailField.text = @"";
    self.passwordField.text = @"";
    [self removeFromSuperview];
}

- (void)hideKeyboard
{
    if ([self.userEmailField isFirstResponder]) {
        [self.userEmailField resignFirstResponder];
    }
    if ([self.passwordField isFirstResponder]) {
        [self.passwordField resignFirstResponder];
    }
}

#pragma mark - Observer method
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (self.superview && !self.keyboardShown) {
        self.keyboardShown = YES;
        CGPoint center = CGPointMake(self.contentView.center.x, self.contentView.center.y - 80);
        [UIView beginAnimations:@"MoveLogin" context:nil];
        [UIView setAnimationDelay:0.2];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.contentView.center = center;
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (self.superview && self.keyboardShown) {
        self.keyboardShown = NO;
        CGPoint center = CGPointMake(self.contentView.center.x, self.contentView.center.y + 80);
        [UIView beginAnimations:@"MoveLogin" context:nil];
        [UIView setAnimationDelay:0.2];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.contentView.center = center;
        [UIView commitAnimations];
    }
}

#pragma mark - UITextFieldDelegate method
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.userEmailField) {
        self.clearUserEmailFieldBtn.hidden = NO;
    }
    else if (textField == self.passwordField) {
        self.clearPasswordFieldBtn.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.userEmailField) {
        self.clearUserEmailFieldBtn.hidden = YES;
    }
    else if (textField == self.passwordField) {
        self.clearPasswordFieldBtn.hidden = YES;
    }
}

@end
