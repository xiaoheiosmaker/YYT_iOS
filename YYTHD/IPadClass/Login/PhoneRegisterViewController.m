//
//  PhoneReigsterViewController.m
//  YYTHD
//
//  Created by 崔海成 on 2/19/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import "PhoneRegisterViewController.h"
#import "CustomPlaceholderTextField.h"
#import "NSString+ValidInput.h"
#import "UserDataController.h"
#import "VerificationCodeResult.h"
#import "YYTAlertView.h"

@interface PhoneRegisterViewController ()
@property (weak, nonatomic) IBOutlet CustomPlaceholderTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *validCodeBtn;
@property (weak, nonatomic) IBOutlet CustomPlaceholderTextField *validCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *timeTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *cleanPhoneButton;
@property (weak, nonatomic) IBOutlet UIButton *cleanValidCodeButton;

@end

@implementation PhoneRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass([PhoneRegisterViewController class]));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.phoneTextField.delegate = self;
    self.validCodeTextField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.cleanPhoneButton.hidden = YES;
    self.cleanValidCodeButton.hidden = YES;
    self.timeTipLabel.hidden = YES;
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
    if (validCodeTimer) {
        [validCodeTimer invalidate];
        validCodeTimer = nil;
    }
    [self.view endEditing:YES];
    [self.presentingViewController dismissModalViewControllerAnimated:NO];
}

- (IBAction)cleanPhoneTextField:(id)sender {
    self.phoneTextField.text = @"";
}
- (IBAction)cleanValidCodeTextField:(id)sender {
    self.validCodeTextField.text = @"";
}

- (void)alertTitle:(NSString *)title Message:(NSString *)message
{
    [YYTAlertView alertMessage:message confirmBlock:nil];
}

- (IBAction)fetchValidCode:(id)sender {
    [self.view endEditing:YES];
    NSString *failTitle = @"获取验证码失败";
    if (![phone isValidPhone]) {
        [self alertTitle:failTitle Message:@"手机号码格式不正确"];
        return;
    }
    UIButton *validCodeBtn = sender;
    validCodeBtn.enabled = NO;
    [[UserDataController sharedInstance] fetchSMSVerificationCodeToPhone:phone opertaionType:kVerificationCodeRegister productId:[NSNumber numberWithInt:1] withCompletion:^(VerificationCodeResult *codeResult, NSError *err) {
        if (err) {
            validCodeBtn.enabled = YES;
            [self alertTitle:failTitle Message:[err yytErrorMessage]];
        }
        else {
            time = [codeResult.actionInterval  intValue];
            [self updateTimeTip];
            [self alertTitle:@"获取验证码成功" Message:@"已经成功发送验证码，请查收"];
        }
    }];
}

- (void)updateTimeTip
{
    validCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fireTimer:) userInfo:nil repeats:YES];
    [validCodeTimer fire];
}

- (void)fireTimer:(NSTimer *)timer
{
    if (time == 0) {
        [validCodeTimer invalidate];
        validCodeTimer = nil;
        self.validCodeBtn.enabled = YES;
        self.timeTipLabel.hidden = YES;
        return;
    }
    
    if (self.timeTipLabel.hidden)
        self.timeTipLabel.hidden = NO;
    NSString *tipMessage = [NSString stringWithFormat:@"%2d秒后可重新获取验证码", time];
    self.timeTipLabel.text = tipMessage;
    
    time -= 1;
}

- (IBAction)register:(id)sender {
    [self.view endEditing:YES];
    if (![phone isValidPhone]) {
        [self alertTitle:@"注册失败" Message:@"手机号码格式不正确"];
        return;
    }
    
    if (validCode == nil || [validCode isEqualToString:@""]) {
        [self alertTitle:@"注册失败" Message:@"验证码不能为空"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UserDataController sharedInstance] registerWithPhone:phone verficationCode:validCode withCompletion:^(YYTLoginInfo *info, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (err) {
            [self alertTitle:@"注册失败" Message:[err yytErrorMessage]];
        }
        else {
            if (validCodeTimer) {
                [validCodeTimer invalidate];
                validCodeTimer = nil;
            }
            [self.presentingViewController dismissModalViewControllerAnimated:NO];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.phoneTextField)
    {
        self.cleanPhoneButton.hidden = NO;
    }
    
    if (textField == self.validCodeTextField)
    {
        self.cleanValidCodeButton.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.phoneTextField)
    {
        phone = self.phoneTextField.text;
        self.cleanPhoneButton.hidden = YES;
    }
    
    if (textField == self.validCodeTextField)
    {
        validCode = self.validCodeTextField.text;
        self.cleanValidCodeButton.hidden = YES;
    }
}
@end
