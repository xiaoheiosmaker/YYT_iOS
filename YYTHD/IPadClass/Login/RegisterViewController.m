//
//  RegisterViewController.m
//  YYTHD
//
//  Created by 崔海成 on 2/19/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import "RegisterViewController.h"
#import "CustomPlaceholderTextField.h"
#import "NSString+ValidInput.h"
#import "UserDataController.h"
#import "YYTLoginInfo.h"
#import "YYTAlertView.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet CustomPlaceholderTextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet CustomPlaceholderTextField *emailTextField;
@property (weak, nonatomic) IBOutlet CustomPlaceholderTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *cleanNickNameButton;
@property (weak, nonatomic) IBOutlet UIButton *cleanEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *cleanPasswordButton;

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nickNameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.cleanNickNameButton.hidden = YES;
    self.cleanEmailButton.hidden = YES;
    self.cleanPasswordButton.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

- (IBAction)close:(id)sender {
    [self.view endEditing:YES];
    [self.presentingViewController dismissModalViewControllerAnimated:NO];
}

- (IBAction)clearNickNameTextField:(id)sender {
    self.nickNameTextField.text = @"";
}

- (IBAction)clearEmailTextField:(id)sender {
    self.emailTextField.text = @"";
}

- (IBAction)clearPasswordTextField:(id)sender {
    self.passwordTextField.text = @"";
}

- (BOOL)validateNickName
{
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    int length = [nickName lengthOfBytesUsingEncoding:encoding];
    if (length == 0 || length > 30) {
        return NO;
    }
    else {
        return YES;
    }
}

- (void)alertMessage:(NSString *)message
{
    [YYTAlertView alertMessage:message confirmBlock:nil];
}

- (IBAction)register:(id)sender {
    [self.view endEditing:YES];
    if (![self validateNickName]) {
        if (nickName == nil || [nickName isEqualToString:@""]) {
            [self alertMessage:@"请填写您喜欢的昵称"];
        }
        else {
            [self alertMessage:@"昵称过长，不能超过30个英文或15个汉字"];
        }
        return;
    }
    
    if (![email isValidEmail]) {
        [self alertMessage:@"邮箱格式不正确"];
        return;
    }
    
    if (![password isValidPassword]) {
        [self alertMessage:@"密码长度必须在4-20个字符之间"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UserDataController sharedInstance] registerWithMail:email nickName:nickName password:password completionBlock:^(YYTUserDetail *detail, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (err) {
            [self alertMessage:[err yytErrorMessage]];
        }
        else {
            [self login];
        }
    }];
}

- (void)login
{
    UIView *presentingView = self.presentingViewController.view;
    [MBProgressHUD showHUDAddedTo:presentingView animated:YES];
    
    [self.presentingViewController dismissModalViewControllerAnimated:NO];
    
    [[UserDataController sharedInstance] loginForUser:email password:password completionBlock:^(YYTLoginInfo *info, NSError *err) {
        [MBProgressHUD hideHUDForView:presentingView animated:YES];
        if (err) {
            [self alertMessage:[err yytErrorMessage]];
        }
        else {
            [YYTAlertView flashSuccessMessage:@"登录成功"];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.nickNameTextField) {
        self.cleanNickNameButton.hidden = NO;
    }
    
    if (textField == self.emailTextField)
    {
        self.cleanEmailButton.hidden = NO;
    }
    
    if (textField == self.passwordTextField)
    {
        self.cleanPasswordButton.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.nickNameTextField) {
        nickName = self.nickNameTextField.text;
        self.cleanNickNameButton.hidden = YES;
    }
    
    if (textField == self.emailTextField)
    {
        email = self.emailTextField.text;
        self.cleanEmailButton.hidden = YES;
    }
    
    if (textField == self.passwordTextField)
    {
        password = self.passwordTextField.text;
        self.cleanPasswordButton.hidden = YES;
    }
}

@end
