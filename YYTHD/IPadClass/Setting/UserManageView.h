//
//  UserManageView.h
//  YYTHD
//
//  Created by ssj on 13-12-26.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"

@interface UserManageView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet GridView *gridView;
@property (weak, nonatomic) id controller;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextfield;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *bindingBtn;
@property (weak, nonatomic) IBOutlet UIButton *validateBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *bindingPhoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *weiboUserLabel;
@property (weak, nonatomic) IBOutlet UIButton *bindingWeiboBtn;

@end
