//
//  YYTLoginViewController.m
//  YYTHD
//
//  Created by 崔海成 on 2/18/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomPlaceholderTextField.h"
#import "NSString+ValidInput.h"
#import "CommonWebView.h"
#import "WeiboSDK.h"
#import "RegisterViewController.h"
#import "PhoneRegisterViewController.h"
#import "UserDataController.h"
#import "YYTLoginInfo.h"
#import "YYTAlertView.h"
#import "ShareAssistantController.h"
#import "BindingAccountViewController.h"

void bindingAccount()
{
    BindingAccountViewController *bindingAccountViewController = [[BindingAccountViewController alloc] init];
    bindingAccountViewController.cancelBlock = ^{
        [[UserDataController sharedInstance] logoutWithCompletion:^(YYTUserDetail *user, NSError *error) {
            
        }];
    };
    bindingAccountViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    CGSize origSize = bindingAccountViewController.view.size;
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:bindingAccountViewController animated:NO completion:^{
        UIView *view = bindingAccountViewController.view;
        UIView *superView = view.superview;
        superView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        NSArray *subViews = [superView subviews];
        for (UIView *subView in subViews) {
            if (subView != view) {
                subView.hidden = YES;
            }
        }
        CGPoint currCenter = superView.center;
        superView.frame = CGRectMake(0, 0, origSize.height, origSize.width);
        superView.center = currCenter;
    }];
}

void loginByOpenPlatform(OpenPlatformType opType, NSString *umName, NSString *serviceName)
{
    ShareAssistantController *shareAssistor = [ShareAssistantController sharedInstance];
    [shareAssistor bindingOpenPlatform:opType confirm:NO inViewController:nil completion:^(BOOL success, NSError *err) {
        if (success) {
            UMSocialAccountEntity *socialAccountEntity = [[UMSocialAccountManager socialAccountDictionary] objectForKey:umName];
            const char *accessToken = [socialAccountEntity.accessToken UTF8String];
            [[UserDataController sharedInstance] loginForOpenPlatform:serviceName userID:socialAccountEntity.usid accessToken:[NSString stringWithUTF8String:accessToken] completionBlock:^(YYTLoginInfo *loginInfo, NSError *loginError) {
                BOOL needBinding = loginInfo.user.email == nil;
                if (needBinding)
                    bindingAccount();
                else
                    [YYTAlertView flashSuccessMessage:@"登录成功"];
            }];
        }
        else {
            [YYTAlertView flashFailureMessage:[err yytErrorMessage]];
        }
    }];
}

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet CustomPlaceholderTextField *userTextField;
@property (weak, nonatomic) IBOutlet CustomPlaceholderTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *cleanUserButton;
@property (weak, nonatomic) IBOutlet UIButton *cleanPasswordButton;

@end

@implementation LoginViewController

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
    
    self.userTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.userTextField)
    {
        self.cleanUserButton.hidden = NO;
    }
    
    if (textField == self.passwordTextField)
    {
        self.cleanPasswordButton.hidden = NO;
    }
}

- (BOOL)validateUserNameWithError:(NSError **)error
{
    if ([userName isValidPhone]) {
        userNameType = kUserNameTypePhone;
        NSLog(@"%@ is phone", userName);
        return YES;
    }
    else if ([userName isValidEmail]) {
        userNameType = kUserNameTypeEmail;
        NSLog(@"%@ is email", userName);
        return YES;
    }
    else {
        *error = [NSError yytOperErrorWithMessage:@"用户邮箱或手机号格式不正确"];
        return NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.userTextField)
    {
        userName = textField.text;
        self.cleanUserButton.hidden = YES;
    }
    
    if (textField == self.passwordTextField)
    {
        password = textField.text;
        self.cleanPasswordButton.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.cleanUserButton.hidden = YES;
    self.cleanPasswordButton.hidden = YES;
    userNameType = kUserNameTypeUnknow;
}

- (IBAction)close:(id)sender {
    [self.view endEditing:YES];
    [self.presentingViewController dismissModalViewControllerAnimated:NO];
}

- (IBAction)cleanUserTextField:(id)sender {
    self.userTextField.text = @"";
}

- (IBAction)cleanPasswordTextField:(id)sender {
    self.passwordTextField.text = @"";
}

- (void)alertMessage:(NSString *)alertMessage
{
    [YYTAlertView alertMessage:alertMessage confirmBlock:nil];
}

- (IBAction)login:(id)sender {
    [self.view endEditing:YES];
    
    NSError *error = nil;
    if (![self validateUserNameWithError:&error]) {
        [self alertMessage:[error yytErrorMessage]];
        return;
    }
    if (![password isValidPassword]) {
        [self alertMessage:@"密码长度必须在4-20个字符之间"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UserDataController sharedInstance] loginForUser:userName password:password completionBlock:^(YYTLoginInfo *info, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (err) {
            [self alertMessage:[err yytErrorMessage]];
        }
        else {
            [self.presentingViewController dismissModalViewControllerAnimated:NO];
            [YYTAlertView flashSuccessMessage:@"登录成功"];
        }
    }];
}

- (IBAction)findPassword:(id)sender {
    [MobClick event:@"FindPass" label:@"找回密码使用频数"];
    UIViewController *presentingViewController = self.presentingViewController;
    [presentingViewController dismissModalViewControllerAnimated:NO];
    CommonWebView *findPasswordWebView = [[CommonWebView alloc] initWithURLString:@"http://login.yinyuetai.com/forgot-password" frame:presentingViewController.view.bounds];
    [presentingViewController.view addSubview:findPasswordWebView];
}

- (IBAction)registerUseEmail:(id)sender {
    UIViewController *presentingViewController = self.presentingViewController;
    [presentingViewController dismissModalViewControllerAnimated:NO];
    
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    registerViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    CGSize origSize = registerViewController.view.frame.size;
    [presentingViewController presentViewController:registerViewController animated:NO completion:^{
        UIView *view = registerViewController.view;
        UIView *superView = view.superview;
        superView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        NSArray *subViews = [superView subviews];
        for (UIView *subView in subViews) {
            if (subView != view)
                subView.hidden = YES;
        }
        CGPoint curCenter = superView.center;
        superView.frame = CGRectMake(0, 0, origSize.height, origSize.width);
        superView.center = curCenter;
    }];
}

- (IBAction)registerUsePhone:(id)sender {
    UIViewController *presentingViewController = self.presentingViewController;
    [presentingViewController dismissModalViewControllerAnimated:NO];
    
    PhoneRegisterViewController *phoneRegisterViewController = [[PhoneRegisterViewController alloc] initWithNibName:@"PhoneRegisterViewController" bundle:nil];
    phoneRegisterViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    CGSize origSize = phoneRegisterViewController.view.frame.size;
    [presentingViewController presentViewController:phoneRegisterViewController animated:NO completion:^{
        UIView *view = phoneRegisterViewController.view;
        UIView *superView = view.superview;
        superView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        NSArray *subViews = [superView subviews];
        for (UIView *subView in subViews) {
            if (subView != view)
                subView.hidden = YES;
        }
        CGPoint curCenter = superView.center;
        superView.frame = CGRectMake(0, 0, origSize.height, origSize.width);
        superView.center = curCenter;
    }];
}

- (IBAction)loginUseWeibo:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        loginByOpenPlatform(OP_WEIBO, @"sina", @"SINA");
    }];
            
}

- (IBAction)loginUseRenren:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        loginByOpenPlatform(OP_RENREN, @"renren", @"RENREN");
    }];
}

- (IBAction)loginUseQzone:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        loginByOpenPlatform(OP_QZONE, @"qzone", @"QQ");
    }];
}

- (void)dealloc
{
    NSLog(@"%@ is dealloc", NSStringFromClass([LoginViewController class]));
}

@end
