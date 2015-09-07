//
//  YYTRegisterBindingView.m
//  YYTHD
//
//  Created by 崔海成 on 12/30/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "YYTRegisterView.h"
#import "UIView+FindViewThatIsFirstResponder.h"
@interface YYTRegisterView() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *clearNicknameBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearEmailBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearPasswordBtn;

@end

@implementation YYTRegisterView

- (void)awakeFromNib
{
    self.nicknameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.clearNicknameBtn.hidden = YES;
    self.clearEmailBtn.hidden = YES;
    self.clearPasswordBtn.hidden = YES;
}
- (IBAction)clearNickname:(id)sender {
    self.nicknameTextField.text = @"";
}
- (IBAction)clearEmail:(id)sender {
    self.emailTextField.text = @"";
}
- (IBAction)clearPassword:(id)sender {
    self.passwordTextField.text = @"";
}

- (IBAction)register:(id)sender {
    if ([self.controller respondsToSelector:@selector(register:)]) {
        if (![self validateUserInput]) return;
        [self.controller register:sender];
    }
}

- (BOOL)validateUserInput
{
    NSString *nickname = self.nicknameTextField.text;
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    nickname = [nickname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [self validateNickname:nickname] && [self validateEmail:email] && [self validatePassword:password];
}

- (BOOL)validateNickname:(NSString *)nickname
{
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    int bytesLength = [nickname lengthOfBytesUsingEncoding:encoding];
    if (bytesLength == 0) {
        [self alertMessage:@"请填写您喜欢的昵称"];
        return NO;
    }
    if (bytesLength > 30) {
        [self alertMessage:@"昵称过长，不能超过30个英文或15个汉字"];
        return NO;
    }
    return YES;
}

-(BOOL)validateEmail:(NSString*)email
{
    BOOL result = YES;
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        /*
         *使用compare option 来设定比较规则，如
         *NSCaseInsensitiveSearch是不区分大小写
         *NSLiteralSearch 进行完全比较,区分大小写
         *NSNumericSearch 只比较定符串的个数，而不比较字符串的字面值
         */
        NSRange range1 = [email rangeOfString:@"@"
                                      options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                result = NO;
        }
        
        //取得域名部分
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                result = NO;
        }
    }
    else {
        result = NO;
    }
    if (!result) {
        [self alertMessage:@"您输入的邮箱不符合规范"];
    }
    return result;
}

- (BOOL)validatePassword:(NSString *)password
{
    int length = [password length];
    if (length < 4) {
        [self alertMessage:@"密码长度不足"];
        return NO;
    }
    if (length > 20) {
        [self alertMessage:@"密码过长，不能超过4-20个字符"];
        return NO;
    }
    return YES;
}

- (void)alertMessage:(NSString *)message
{
    [[self firstResponder] resignFirstResponder];
    YYTAlert *alert = [[YYTAlert alloc] initSureWithMessage:message delegate:nil];
    [alert showInView:self.superview.superview];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.nicknameTextField) {
        self.clearNicknameBtn.hidden = NO;
    }
    else if (textField == self.emailTextField) {
        self.clearEmailBtn.hidden = NO;
    }
    else if (textField == self.passwordTextField) {
        self.clearPasswordBtn.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.nicknameTextField) {
        self.clearNicknameBtn.hidden = YES;
    }
    else if (textField == self.emailTextField) {
        self.clearEmailBtn.hidden = YES;
    }
    else if (textField == self.passwordTextField) {
        self.clearPasswordBtn.hidden = YES;
    }
}

@end
