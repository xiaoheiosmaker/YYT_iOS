//
//  YYTRegisterBindingView.h
//  YYTHD
//
//  Created by 崔海成 on 12/30/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYTRegisterView : UIView
@property (nonatomic, weak) id controller;
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *completionBtn;
@end
