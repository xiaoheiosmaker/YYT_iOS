//
//  BindingAccountViewController.m
//  YYTHD
//
//  Created by 崔海成 on 3/7/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import "BindingAccountViewController.h"
#import "CustomPlaceholderTextField.h"
#import "NSString+ValidInput.h"
#import "UserDataController.h"
#import "YYTAlertView.h"

@interface BindingAccountViewController () <UITextFieldDelegate>
{
    BOOL needRegisterAccount;
}

@property (weak, nonatomic) IBOutlet UIButton *clearEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *clearPasswordButton;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet CustomPlaceholderTextField *emailTextField;
@property (weak, nonatomic) IBOutlet CustomPlaceholderTextField *passwordTextField;

@end

@implementation BindingAccountViewController

- (id)initWithCancelBlock:(CancelBlock)cancelBlock
{
    self = [super initWithNibName:NSStringFromClass([BindingAccountViewController class])  bundle:nil];
    if (self) {
        needRegisterAccount = NO;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithCancelBlock:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearEmailButton.hidden = YES;
    self.clearPasswordButton.hidden = YES;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)directlyBinding:(UIButton *)sender {
    self.selectImageView.center = CGPointMake(sender.center.x, self.selectImageView.center.y);
    self.passwordTextField.secureTextEntry = YES;
    needRegisterAccount = NO;
}

- (IBAction)registerBinding:(UIButton *)sender {
    self.selectImageView.center = CGPointMake(sender.center.x, self.selectImageView.center.y);
    self.passwordTextField.secureTextEntry = NO;
    needRegisterAccount = YES;
}

- (IBAction)cleanEmailField:(id)sender {
    self.emailTextField.text = @"";
}

- (IBAction)cleanPasswordField:(id)sender {
    self.passwordTextField.text = @"";
}

- (IBAction)binding:(id)sender {
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (![email isValidEmail]) {
        [YYTAlertView alertMessage:@"邮箱格式不正确" confirmBlock:nil];
        return;
    }
    
    if (![password isValidPassword]) {
        [YYTAlertView alertMessage:@"密码长度必须在4-20个字符之间" confirmBlock:nil];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak BindingAccountViewController *weakSelf = self;
    [[UserDataController sharedInstance] bindingEmail:email password:password isExist:!needRegisterAccount completionBlock:^(BOOL success, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success) {
            [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:^{
                [YYTAlertView flashSuccessMessage:@"绑定成功"];
            }];
        }
        else {
            [YYTAlertView flashSuccessMessage:[error yytErrorMessage]];
        }
    }];
}

- (IBAction)abort:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.emailTextField) {
        self.clearEmailButton.hidden = NO;
    }
    
    if (textField == self.passwordTextField) {
        self.clearPasswordButton.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.emailTextField) {
        self.clearEmailButton.hidden = YES;
    }
    
    if (textField == self.passwordTextField) {
        self.clearPasswordButton.hidden = YES;
    }
}

@end
