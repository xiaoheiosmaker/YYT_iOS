//
//  SettingsNavigateView.m
//  YYTHD
//
//  Created by shuilin on 10/24/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "SettingsNavigateView.h"
#import "UserDataController.h"

@interface SettingsNavigateView ()
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
- (IBAction)clickSettingButton:(id)sender;
- (IBAction)clickCommentButton:(id)sender;
- (IBAction)clickAboutButton:(id)sender;
- (IBAction)clickLoginButton:(id)sender;
- (IBAction)clickHeadButton:(id)sender;
- (IBAction)clickFeedbackButton:(id)sender;
@end

@implementation SettingsNavigateView

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
    self.singleButtonGroup = [[SingleButtonGroup alloc] init];
    
    UIView *lineView;
    CGRect frame = self.settingButton.bounds;
    CGFloat lineHeight = [UIScreen mainScreen].scale > 1.0 ? 0.5 : 1;
    frame = CGRectMake(0, 0, frame.size.width, lineHeight);
    NSUInteger autoResizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    lineView = [[UIView alloc] initWithFrame:frame];
    lineView.autoresizingMask = autoResizingMask;
    lineView.backgroundColor = [UIColor yytLineColor];
    [self.settingButton addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:frame];
    lineView.autoresizingMask = autoResizingMask;
    lineView.backgroundColor = [UIColor yytLineColor];
    [self.commentButton addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:frame];
    lineView.autoresizingMask = autoResizingMask;
    lineView.backgroundColor = [UIColor yytLineColor];
    [self.feedbackButton addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:frame];
    lineView.autoresizingMask = autoResizingMask;
    lineView.backgroundColor = [UIColor yytLineColor];
    [self.aboutButton addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:frame];
    lineView.autoresizingMask = autoResizingMask;
    lineView.backgroundColor = [UIColor yytLineColor];
    [self.loginButton addSubview:lineView];
    
    UIImage *image = [UIImage imageNamed:@"contentBackground"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.backgroundImageView.image = image;
    self.headButton.layer.cornerRadius = 50;
    self.headButton.clipsToBounds = YES;
    self.settingButton.selected = YES;
    self.headButton.userInteractionEnabled = NO;//点击头像暂不响应事件
    [self.singleButtonGroup.items addObject:self.settingButton];
    [self.singleButtonGroup.items addObject:self.loginButton];
    [self.singleButtonGroup.items addObject:self.aboutButton];
    
    if ([UserDataController sharedInstance].isLogin) {
        [self.loginButton setTitle:@"账号管理" forState:UIControlStateNormal];
    }else{
        [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    }
    
}

- (IBAction)clickFeedbackButton:(id)sender
{
    [self.delegate settingsNavigateView:self clickedFeedback:sender];
}

- (IBAction)clickSettingButton:(id)sender
{
    self.settingButton.selected = NO;
    [self.singleButtonGroup selectItem:sender];
    [self.delegate settingsNavigateView:self clickedSetting:sender];
}

- (IBAction)clickCommentButton:(id)sender
{
    [self.singleButtonGroup selectItem:sender];
    [self.delegate settingsNavigateView:self clickedComment:sender];
}

- (IBAction)clickAboutButton:(id)sender
{
    self.aboutButton.selected = NO;
    [self.singleButtonGroup selectItem:sender];
    [self.delegate settingsNavigateView:self clickedAbout:self];
}

- (IBAction)clickLoginButton:(id)sender
{
    [self.delegate settingsNavigateView:self clickedLogin:sender];
}

- (IBAction)clickHeadButton:(id)sender
{
    [self.delegate settingsNavigateView:self clickedHead:sender];
}


@end
