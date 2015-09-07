//
//  BindingPhoneViewController.m
//  YYTHD
//
//  Created by 崔海成 on 2/21/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import "BindingPhoneViewController.h"
#import "CustomPlaceholderTextField.h"
#import "NSString+ValidInput.h"
#import "UserDataController.h"
#import "VerificationCodeResult.h"
#import "YYTAlertView.h"

@interface BindingPhoneViewController ()
@property (weak, nonatomic) IBOutlet CustomPlaceholderTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *validCodeBtn;
@property (weak, nonatomic) IBOutlet CustomPlaceholderTextField *validCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *cleanPhoneButton;
@property (weak, nonatomic) IBOutlet UIButton *cleanValidCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *timeTipLabel;

@end

@implementation BindingPhoneViewController

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
    NSLog(@"%@ dealloc", NSStringFromClass([BindingPhoneViewController class]));
    
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)close:(id)sender {
    if (validCodetimer) {
        [validCodetimer invalidate];
        validCodetimer = nil;
    }
    
    [self.view endEditing:YES];
    [self.presentingViewController dismissModalViewControllerAnimated:NO];
}
- (IBAction)sendValidCode:(id)sender {
    [self.view endEditing:YES];
    NSString *failTitle = @"获取验证码失败";
    if (![phone isValidPhone]) {
        [self alertTitle:failTitle message:@"请输入正确的手机号码"];
        return;
    }
    UIButton *validCodeBtn = sender;
    validCodeBtn.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UserDataController sharedInstance] fetchSMSVerificationCodeToPhone:phone opertaionType:kVerificationCodeBind productId:[NSNumber numberWithInt:1] withCompletion:^(VerificationCodeResult *result, NSError *err) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (err) {
            validCodeBtn.enabled = YES;
            [self alertTitle:failTitle message:[err yytErrorMessage]];
        }
        else {
            time = [result.actionInterval intValue];
            [self updateTimeTip];
            [self alertTitle:@"获取验证码成功" message:@"已经成功发送验证码，请查收"];
        }
    }];
}

- (void)updateTimeTip
{
    validCodetimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fireTimer:) userInfo:nil repeats:YES];
    [validCodetimer fire];
}

- (void)fireTimer:(NSTimer *)timer
{
    if (time == 0) {
        [timer invalidate];
        timer = nil;
        self.timeTipLabel.hidden = YES;
        self.validCodeBtn.enabled = YES;
        return;
    }
    
    if (self.timeTipLabel.hidden)
        self.timeTipLabel.hidden = NO;
    NSString *tipMessage = [NSString stringWithFormat:@"%2d秒后可重新获取验证码", time];
    self.timeTipLabel.text = tipMessage;
    
    time -= 1;
}

- (IBAction)cleanPhoneTextFied:(id)sender {
    self.phoneTextField.text = @"";
}
- (IBAction)cleanValidCodeTextField:(id)sender {
    self.validCodeTextField.text = @"";
}

- (void)alertTitle:(NSString *)title message:(NSString *)message
{
    [YYTAlertView alertMessage:message confirmBlock:nil];
}

- (IBAction)binding:(id)sender {
    [self.view endEditing:YES];
    NSString *failTitle = @"绑定手机失败";
    if (![phone isValidPhone]) {
        [self alertTitle:failTitle message:@"手机号码不正确"];
        return;
    }
    if (validCode == nil || [validCode isEqualToString:@""]) {
        [self alertTitle:failTitle message:@"验证码不能为空"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UserDataController sharedInstance] bindingPhone:phone verficationCode:validCode productID:[NSNumber numberWithInt:1] withCompletion:^(YYTLoginInfo *info, NSError *err) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (err) {
            [self alertTitle:failTitle message:[err yytErrorMessage]];
        }
        else {
            if (validCodetimer) {
                [validCodetimer invalidate];
                validCodetimer = nil;
            }
            [self alertTitle:@"成功绑定手机" message:@"绑定密保手机成功"];
            [self.presentingViewController dismissModalViewControllerAnimated:NO];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.phoneTextField) {
        self.cleanPhoneButton.hidden = NO;
    }
    
    if (textField == self.validCodeTextField) {
        self.cleanValidCodeButton.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.phoneTextField) {
        phone = self.phoneTextField.text;
        self.cleanPhoneButton.hidden = YES;
    }
    
    if (textField == self.validCodeTextField) {
        validCode = self.validCodeTextField.text;
        self.cleanValidCodeButton.hidden = YES;
    }
}

@end
