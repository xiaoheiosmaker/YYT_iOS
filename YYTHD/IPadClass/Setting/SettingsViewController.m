//
//  SettingsViewController.m
//  YYTHD
//
//  Created by shuilin on 10/24/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsNavigateView.h"
#import "SettingsPaneView.h"
#import "SingleViewGroup.h"
#import "PushDataController.h"
#import "AboutViewController.h"
#import "ShareAssistantController.h"
#import "UserDataController.h"
#import "UIButton+WebCache.h"
#import "YYTUserDetail.h"
#import "YYTAlert.h"
#import "NormalSwitchCell.h"
#import "SearchHistoryDataController.h"
#import "UserManageView.h"
#import "OpenSocialPlatformBind.h"
#import "PlayHistoryDataController.h"
#import "UserGuideViewController.h"
#import "UIColor+Generator.h"
#import "LoginViewController.h"
#import "UMFeedback.h"
#import "UMFeedbackViewController.h"
#import "WeiboSDK.h"
#import "BindingPhoneViewController.h"
#import "YYTAlertView.h"
#import "SystemSupport.h"
#import "BindingAccountViewController.h"

@interface SettingsViewController () <VideoQualityCellDelegate,NormalSwitchCellDelegate,LoginAccountCellDelegate,SettingsNavigateViewDelegate,PushDataControllerDelegate, UITextFieldDelegate>
{
    YYTAlert *alertLogout;
}
@property(retain,nonatomic) SettingsNavigateView* settingsNavigateView;
@property(retain,nonatomic) SettingsPaneView* settingsPaneView;
@property(retain,nonatomic) UIView* loginView;
@property(retain,nonatomic) UIView* aboutView;
@property(strong, nonatomic) UserManageView *userManageView;
@property(retain,nonatomic) SingleViewGroup* singleViewGroup;
@property(retain,nonatomic) AboutViewController* aboutViewController;

- (void)umengToMe;
- (void)freshSettingsNavigateView;
- (void)alertMessage:(NSString *)message;
@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.singleViewGroup = [[SingleViewGroup alloc] init];
        
        BOOL centerPush = [SettingsDataController singleTon].messageOn;
        BOOL subscribePush = [SettingsDataController singleTon].newMvOn;
        
        [[PushDataController singleTon] readyCenterPush:centerPush andSubscribePush:subscribePush];
        [[PushDataController singleTon] addObserver:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDidLogin:) name:YYTDidLogin object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(fetchUserInfo:) name:YYTFetchUserInfo object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDidLogout:) name:YYTDidLogout object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindingStatusChanged:) name:YYTBindingCompletion object:nil];
        
        alertLogout = [[YYTAlert alloc] initWithMessage:@"确定注销?" confirmBlock:^{
            UserDataController* userDataController = [UserDataController sharedInstance];
            [userDataController logoutWithCompletion:^(YYTUserDetail* user, NSError* error)
             {
                 if(error)
                 {
                     [AlertWithTip flashFailedMessage:@"注销失败"];
                 }
                 [self freshSettingsNavigateView];
                 [AlertWithTip flashSuccessMessage:@"退出成功"];
             }];
        }];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YYTDidLogin object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YYTDidLogout object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YYTBindingCompletion object:nil];
    
    [[PushDataController singleTon] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.settingsNavigateView = [[[NSBundle mainBundle] loadNibNamed:@"SettingsNavigateView" owner:self options:nil] lastObject];
    self.settingsNavigateView.delegate = self;
    [self.view addSubview:self.settingsNavigateView];
    
    self.settingsPaneView = [[[NSBundle mainBundle] loadNibNamed:@"SettingsPaneView" owner:self options:nil] lastObject];
    [self.view addSubview:self.settingsPaneView];
    
    self.userManageView = [[[NSBundle mainBundle] loadNibNamed:@"UserManageView" owner:self options:nil] lastObject];
    self.userManageView.controller = self;
    self.userManageView.nicknameTextfield.delegate = self;
    self.userManageView.gridView.rowNumbers = 3;
    self.userManageView.gridView.borderColor = [UIColor yytLineColor];
    [self.view addSubview:self.userManageView];
    
    self.aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    self.aboutView = self.aboutViewController.view;
    [self.view addSubview:self.aboutView];
    
    [self.singleViewGroup addItem:self.settingsPaneView];
    [self.singleViewGroup addItem:self.aboutView];
    [self.singleViewGroup addItem:self.userManageView];
    [self.singleViewGroup selectItem:self.settingsPaneView];
    
    //位置
    CGFloat x,y,width,height;
    
    //左导航栏位置
    x = 10;//边距
    y = 10 + self.topView.frame.origin.y + self.topView.frame.size.height;
    width = self.settingsNavigateView.frame.size.width;
    height = self.settingsNavigateView.frame.size.height;
    
    CGRect rect;
    rect = CGRectMake(x, y, width, height);
    self.settingsNavigateView.frame = rect;
    
    x = 10 + self.settingsNavigateView.origin.x + self.settingsNavigateView.frame.size.width;
    
    //右设置面板位置
    rect = self.settingsPaneView.frame;
    rect.origin.x = x;
    rect.origin.y = y;
    self.settingsPaneView.frame = rect;
    
    //右侧关于界面位置
    rect = self.aboutView.frame;
    rect.origin.x = x;
    rect.origin.y = y;
    self.aboutView.frame = rect;
    
    //账户管理界面位置
    rect = self.userManageView.frame;
    rect.origin.x = x;
    rect.origin.y = y;
    self.userManageView.frame = rect;

    //被通知
    //self.settingsPaneView.videoQualityCell.delegate = self;
    self.settingsPaneView.lockSwitchCell.delegate = self;
    self.settingsPaneView.sinaCell.delegate = self;
    self.settingsPaneView.qqCell.delegate = self;
    self.settingsPaneView.tencentCell.delegate = self;
    self.settingsPaneView.renrenCell.delegate = self;
    self.settingsPaneView.messageTipCell.delegate = self;
    self.settingsPaneView.mvTipCell.delegate = self;
    self.settingsPaneView.netTipCell.delegate = self;
    self.settingsPaneView.userGuide.delegate = self;
    self.settingsPaneView.clearSearchHistory.delegate = self;
    self.settingsPaneView.clearPlayHistory.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self freshSettingsNavigateView];
    if ([UserDataController sharedInstance].isLogin) {
        [[UserDataController sharedInstance] fetchParticularUserInfo];
    }
    
    //获取友盟分享平台的数据
    [self umengToMe];
    
    //显示曾经的设置数据
    [self showSettings];
}

- (void)alertMessage:(NSString *)message
{
    YYTAlert *alert = [[YYTAlert alloc] initSureWithMessage:message delegate:nil];
    [alert showInView:self.view];
}

- (void)freshSettingsNavigateView
{
    UserDataController* userDataController = [UserDataController sharedInstance];
    if(!userDataController.isLogin)
    {
        [self.settingsNavigateView.nickLabel setText:@"音悦台，看好音乐"];
        [self.settingsNavigateView.headButton setBackgroundImage:IMAGE(@"defaultHeadBig") forState:UIControlStateNormal];
        [self.settingsNavigateView.loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [self.settingsNavigateView.singleButtonGroup selectItem:self.settingsNavigateView.settingButton];
        [self.singleViewGroup selectItem:self.settingsPaneView];
        
        self.userManageView.nicknameTextfield.text = @"";
        self.userManageView.emailLabel.text = @"";
        self.userManageView.bindingBtn.hidden = NO;
        self.userManageView.validateBtn.hidden = YES;
        self.userManageView.phoneLabel.text = @"";
        self.userManageView.bindingPhoneBtn.hidden = NO;
        self.userManageView.weiboUserLabel.text = @"";
        self.userManageView.bindingWeiboBtn.hidden = NO;
    }
    else//已经登录
    {
        NSString *unbinding = @"未绑定";
        YYTUserDetail* user = [userDataController currentUser];
        self.userManageView.nicknameTextfield.text = user.nickName;
        BOOL hasEmail = user.email != nil && ![user.email isEqualToString:@""];
        self.userManageView.emailLabel.text = hasEmail ? user.email : unbinding;
        self.userManageView.bindingBtn.hidden = hasEmail;
        if (hasEmail && !user.emailVerified) {
            self.userManageView.validateBtn.frame = self.userManageView.bindingBtn.frame;
            self.userManageView.emailLabel.text = [NSString stringWithFormat:@"%@%@", user.email, @"(邮箱未验证)"];
            self.userManageView.validateBtn.hidden = NO;
        }
        else {
            self.userManageView.validateBtn.hidden = YES;
        }
        if ([user.bind count] > 0) {
            OpenSocialPlatformBind *bind = [user.bind objectAtIndex:0];
            self.userManageView.weiboUserLabel.text = bind.nickName;
            self.userManageView.bindingWeiboBtn.hidden = YES;
        }
        else {
            self.userManageView.weiboUserLabel.text = unbinding;
            self.userManageView.bindingWeiboBtn.hidden = NO;
        }
        BOOL hasPhone = user.phone != nil && ![user.phone isEqualToString:@""];
        self.userManageView.phoneLabel.text = hasPhone ? user.phone : unbinding;
        self.userManageView.bindingPhoneBtn.hidden = hasPhone;
        
        [self.singleViewGroup selectItem:self.userManageView];
        
        [self.settingsNavigateView.nickLabel setText:user.nickName];
        
        [self.settingsNavigateView.headButton setBackgroundImageWithURL:[NSURL URLWithString:user.largeAvatar] forState:UIControlStateNormal placeholderImage:IMAGE(@"defaultHeadBig")];
        
        [self.settingsNavigateView.loginButton setTitle:@"账号管理" forState:UIControlStateNormal];
        [self.settingsNavigateView.singleButtonGroup selectItem:self.settingsNavigateView.loginButton];
    }
    
}

- (void)umengToMe
{
    ShareAssistantController* shareAssistantController = [ShareAssistantController sharedInstance];
    SettingsDataController* dataController = [SettingsDataController singleTon];
    
    ShareAccount* shareAccount;
    OpenPlatformType type;
    
    NSArray* keys = [NSArray arrayWithObjects:kSinaAccountItem,kQQAccountItem,kTencentAccountItem,kRenrenAccountItem,nil];
    for(NSString* key in keys)
    {
        if([key isEqualToString:kSinaAccountItem])
        {
            shareAccount = dataController.sinaAccount;
            type = OP_WEIBO;
        }
        else if([key isEqualToString:kQQAccountItem])
        {
            shareAccount = dataController.qqAccount;
            type = OP_QZONE;
        }
        else if([key isEqualToString:kTencentAccountItem])
        {
            shareAccount = dataController.tencentAccount;
            type = OP_TENCENT;
        }
        else if([key isEqualToString:kRenrenAccountItem])
        {
            shareAccount = dataController.renrenAccount;
            type = OP_RENREN;
        }
        
        BOOL bLogin = [shareAssistantController isOAuthInSocialPlatform:type];
        if(bLogin)
        {
            shareAccount.status = Login_Status;
            shareAccount.name = [shareAssistantController nickNameInSocialPlatform:type];
        }
        else
        {
            shareAccount.status = Logout_Status;
            shareAccount.name = @"";
        }
        
        [dataController saveItem:key];
    }
}

//显示设置
- (void)showSettings
{
    SettingsDataController* dataController = [SettingsDataController singleTon];
    
    //VideoQualityType type = dataController.videoQualityType;
    //self.settingsPaneView.videoQualityCell.type = type;
    
    self.settingsPaneView.lockSwitchCell.switcher.on = dataController.lockOn;
    
    //新浪微博
    if(dataController.sinaAccount.status == Login_Status)
    {
        self.settingsPaneView.sinaCell.statusLabel.text = @"已绑定新浪微博";
        self.settingsPaneView.sinaCell.nickLabel.text = dataController.sinaAccount.name;
        //[self.settingsPaneView.sinaCell.actionButton setTitle:@"注销" forState:UIControlStateNormal];
        self.settingsPaneView.sinaCell.switcher.on = YES;
    }
    else
    {
        self.settingsPaneView.sinaCell.statusLabel.text = @"";
        self.settingsPaneView.sinaCell.nickLabel.text = @"";
        //[self.settingsPaneView.sinaCell.actionButton setTitle:@"绑定" forState:UIControlStateNormal];
        self.settingsPaneView.sinaCell.switcher.on = NO;
    }
    
    //qq空间
    if(dataController.qqAccount.status == Login_Status)
    {
        self.settingsPaneView.qqCell.statusLabel.text = @"已绑定qq空间";
        self.settingsPaneView.qqCell.nickLabel.text = dataController.qqAccount.name;
        //[self.settingsPaneView.qqCell.actionButton setTitle:@"注销" forState:UIControlStateNormal];
        self.settingsPaneView.qqCell.switcher.on = YES;
    }
    else
    {
        self.settingsPaneView.qqCell.statusLabel.text = @"";
        self.settingsPaneView.qqCell.nickLabel.text = @"";
        //[self.settingsPaneView.qqCell.actionButton setTitle:@"绑定" forState:UIControlStateNormal];
        self.settingsPaneView.qqCell.switcher.on = NO;
    }
    
    //腾迅微博
    if(dataController.tencentAccount.status == Login_Status)
    {
        self.settingsPaneView.tencentCell.statusLabel.text = @"已绑定腾讯微博";
        self.settingsPaneView.tencentCell.nickLabel.text = dataController.tencentAccount.name;
        //[self.settingsPaneView.tencentCell.actionButton setTitle:@"注销" forState:UIControlStateNormal];
        self.settingsPaneView.tencentCell.switcher.on = YES;
    }
    else
    {
        self.settingsPaneView.tencentCell.statusLabel.text = @"";
        self.settingsPaneView.tencentCell.nickLabel.text = @"";
        //[self.settingsPaneView.tencentCell.actionButton setTitle:@"绑定" forState:UIControlStateNormal];
        self.settingsPaneView.tencentCell.switcher.on = NO;
    }
    
    //人人网
    if(dataController.renrenAccount.status == Login_Status)
    {
        self.settingsPaneView.renrenCell.statusLabel.text = @"已绑定人人网";
        self.settingsPaneView.renrenCell.nickLabel.text = dataController.renrenAccount.name;
        //[self.settingsPaneView.renrenCell.actionButton setTitle:@"注销" forState:UIControlStateNormal];
        self.settingsPaneView.renrenCell.switcher.on = YES;
    }
    else
    {
        self.settingsPaneView.renrenCell.statusLabel.text = @"";
        self.settingsPaneView.renrenCell.nickLabel.text = @"";
        //[self.settingsPaneView.renrenCell.actionButton setTitle:@"绑定" forState:UIControlStateNormal];
        self.settingsPaneView.renrenCell.switcher.on = NO;
    }
    
    self.settingsPaneView.messageTipCell.switcher.on = dataController.messageOn;
    self.settingsPaneView.mvTipCell.switcher.on = dataController.newMvOn;
    
    self.settingsPaneView.netTipCell.switcher.on = dataController.netOn;
}

//保存设置
- (void)videoQualityCell:(VideoQualityCell *)cell clickedNormalButton:(id)sender
{
    SettingsDataController* dataController = [SettingsDataController singleTon];
    dataController.videoQualityType = Normal_Video;
    [dataController saveItem:kVideoQualityItem];
}

- (void)videoQualityCell:(VideoQualityCell *)cell clicked540Button:(id)sender
{
    SettingsDataController* dataController = [SettingsDataController singleTon];
    dataController.videoQualityType = P540_Video;
    [dataController saveItem:kVideoQualityItem];
}

- (void)normalSwitchCell:(NormalSwitchCell *)cell switched:(BOOL)bOn
{
    SettingsDataController* dataController = [SettingsDataController singleTon];
    if(cell == self.settingsPaneView.lockSwitchCell)
    {
        dataController.lockOn = bOn;
        [dataController saveItem:kLockSwitchItem];
    }
    else if(cell == self.settingsPaneView.messageTipCell)//需要服务器校验
    {
        [[PushDataController singleTon] enableCenterPush:bOn];
    }
    else if(cell == self.settingsPaneView.mvTipCell)
    {
        dataController.newMvOn = bOn;
        [dataController saveItem:kNewMVSwitchItem];
    }
    else if(cell == self.settingsPaneView.saveTipCell)
    {
        
    }
    else if(cell == self.settingsPaneView.netTipCell)
    {
        dataController.netOn = bOn;
        [dataController saveItem:kNetSwitchItem];
    }
}

- (void)clearDataCell:(NormalSwitchCell *)cell{
    if (cell == self.settingsPaneView.clearPlayHistory) {
        //清除历史记录
        YYTAlert *alert = [[YYTAlert alloc] initWithMessage:@"你确定要清除播放历史？" confirmBlock:^{
            PlayHistoryDataController *dataController = [PlayHistoryDataController sharedInstance];
            [dataController clearData];
        }];
        [alert showInView:self.view];
    }else if (cell == self.settingsPaneView.clearSearchHistory) {
        YYTAlert *alert = [[YYTAlert alloc] initWithMessage:@"你确定要清除搜索历史？" confirmBlock:^{
            SearchHistoryDataController *searchData =  [[SearchHistoryDataController alloc] init];
            [searchData clearHistory];
        }];
        [alert showInView:self.view];
        
    }else if (cell == self.settingsPaneView.userGuide){
        //新手引导
        UserGuideViewController *userGuide = [[UserGuideViewController alloc] init];
        [self presentViewController:userGuide animated:YES completion:NULL];
    }
}

- (void)loginAccountCell:(LoginAccountCell *)cell clickedLogin:(id)sender
{
    static BOOL confirm = YES;
    BOOL debinding = !cell.switcher.on;
    if (confirm && debinding) {
        cell.switcher.on = YES;
        YYTAlert *loginAlert = [[YYTAlert alloc] initWithMessage:@"您确定要注销授权的账户吗" confirmBlock:^{
            confirm = NO;
            cell.switcher.on = NO;
            [self loginAccountCell:cell clickedLogin:sender];
        }];
        [loginAlert viewShow];
        return;
    }
    confirm = YES;
    ShareAssistantController* shareAssistantController = [ShareAssistantController sharedInstance];
    
    if(cell == self.settingsPaneView.sinaCell)
    {
        SettingsDataController* dataController = [SettingsDataController singleTon];
        if(dataController.sinaAccount.status == Logout_Status)
        {
            [shareAssistantController bindingOpenPlatform:OP_WEIBO confirm:NO inViewController:nil completion:^(BOOL success, NSError *error)
            {
                [self umengToMe];
                [self showSettings];
            }];
        }
        else
        {
            [shareAssistantController unbindingOpenPlatform:OP_WEIBO completion:^(BOOL success, NSError* error)
            {
                [self umengToMe];
                [self showSettings];
            }];
        }
    }
    else if(cell == self.settingsPaneView.qqCell)
    {
        SettingsDataController* dataController = [SettingsDataController singleTon];
        if(dataController.qqAccount.status == Logout_Status)
        {
            [shareAssistantController bindingOpenPlatform:OP_QZONE confirm:NO inViewController:nil completion:^(BOOL success, NSError *error)
             {
                 [self umengToMe];
                 [self showSettings];
             }];
        }
        else
        {
            [shareAssistantController unbindingOpenPlatform:OP_QZONE completion:^(BOOL success, NSError* error)
             {
                 [self umengToMe];
                 [self showSettings];
             }];
        }
    }
    else if(cell == self.settingsPaneView.tencentCell)
    {
        SettingsDataController* dataController = [SettingsDataController singleTon];
        if(dataController.tencentAccount.status == Logout_Status)
        {
            [shareAssistantController bindingOpenPlatform:OP_TENCENT confirm:NO inViewController:nil completion:^(BOOL success, NSError *error)
             {
                 [self umengToMe];
                 [self showSettings];
             }];
        }
        else
        {
            [shareAssistantController unbindingOpenPlatform:OP_TENCENT completion:^(BOOL success, NSError* error)
             {
                 [self umengToMe];
                 [self showSettings];
             }];
        }
       
    }
    else if(cell == self.settingsPaneView.renrenCell)
    {
        SettingsDataController* dataController = [SettingsDataController singleTon];
        if(dataController.renrenAccount.status == Logout_Status)
        {
            [shareAssistantController bindingOpenPlatform:OP_RENREN confirm:NO inViewController:nil completion:^(BOOL success, NSError *error)
             {
                 [self umengToMe];
                 [self showSettings];
             }];
        }
        else
        {
            [shareAssistantController unbindingOpenPlatform:OP_RENREN completion:^(BOOL success, NSError* error)
             {
                 [self umengToMe];
                 [self showSettings];
             }];
        }
    }
    
    [self showSettings];
}

//响应navigate view事件
- (void) settingsNavigateView:(SettingsNavigateView*) navigateView clickedSetting:(id)sender
{
    [self.singleViewGroup selectItem:self.settingsPaneView];
}

- (void) settingsNavigateView:(SettingsNavigateView*) navigateView clickedComment:(id)sender
{
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d", APP_ID];
    if ([SystemSupport versionPriorTo7])
        str = [NSString stringWithFormat:
                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                     APP_ID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)settingsNavigateView:(SettingsNavigateView *)navigateView clickedFeedback:(id)sender
{
    UMFeedbackViewController *feedbackViewController = [[UMFeedbackViewController alloc] init];
    feedbackViewController.navigationItem.title = @"意见反馈";
    feedbackViewController.appkey = UMENG_APP_KEY;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    navigationController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentModalViewController:navigationController animated:YES];
}

- (void) settingsNavigateView:(SettingsNavigateView*) navigateView clickedAbout:(id)sender
{
    [self.singleViewGroup selectItem:self.aboutView];
}

- (void) settingsNavigateView:(SettingsNavigateView*) navigateView clickedLogin:(id)sender
{
    UserDataController* userDataController = [UserDataController sharedInstance];
    if(!userDataController.isLogin)//未登录显示登录界面
    {
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        CGSize origSize = loginViewController.view.frame.size;
        [self presentViewController:loginViewController animated:NO completion:^{
            UIView *view = loginViewController.view;
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
    else    //点击了账户管理
    {
        [self.settingsNavigateView.singleButtonGroup selectItem:sender];
        [self.singleViewGroup selectItem:self.userManageView];
    }
}
//头像点击事件
- (void) settingsNavigateView:(SettingsNavigateView*) navigateView clickedHead:(id)sender
{
    
}

//
- (void)pushDataController:(PushDataController *)aDataController enableCenterPushWithError:(NSError *)error
{
    SettingsDataController* dataController = [SettingsDataController singleTon];
    if(error == nil)//同步成功
    {
        dataController.messageOn = [aDataController bOnCenterPush];
//        [self alertMessage:@"success"];
        [dataController saveItem:kMessageSwitchItem];
    }
    else
    {
        [self alertMessage:@"设置消息提醒失败"];
    }
    //刷新真实数据
    self.settingsPaneView.messageTipCell.switcher.on = dataController.messageOn;
}

- (void)pushDataController:(PushDataController *)aDataController enableSubscribePushWithError:(NSError *)error
{
    SettingsDataController* dataController = [SettingsDataController singleTon];
    if(error == nil)//同步成功
    {
        dataController.newMvOn = [aDataController bOnSubscribePush];
        [dataController saveItem:kNewMVSwitchItem];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"newMvOn" object:nil];
    }
    else
    {
        [self alertMessage:@"设置订阅艺人新MV提醒失败"];
    }
    
    //刷新真实数据
    self.settingsPaneView.mvTipCell.switcher.on = dataController.newMvOn;
}

//通知
- (void)userDidLogin:(NSNotification *)notification
{
    //NSLog(@"登录成功");
    [self freshSettingsNavigateView];
}

- (void)fetchUserInfo:(NSNotification *)notification
{
    [self freshSettingsNavigateView];
}

- (void)userDidLogout:(NSNotification *)notification
{
    //NSLog(@"注销成功");
    [self freshSettingsNavigateView];
}

- (void)bindingStatusChanged:(NSNotification *)notification
{
    [self umengToMe];
    [self showSettings];
}

// 账户设置
- (void)modifyNickname:(id)sender {
    UITextField *textfield = self.userManageView.nicknameTextfield;
    UIButton *button = sender ?: self.userManageView.modifyBtn;
    BOOL editing = textfield.enabled;
    if (!editing) {
        textfield.enabled = YES;
        textfield.backgroundColor = [UIColor yytBackgroundColor];
        [textfield becomeFirstResponder];
        [button setImage:[UIImage imageNamed:@"cancel_btn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"cancel_btn_h"] forState:UIControlStateHighlighted];
    }
    else {
        textfield.enabled = NO;
        textfield.backgroundColor = [UIColor clearColor];
        textfield.borderStyle = UITextBorderStyleNone;
        if (sender == self.userManageView.modifyBtn) {
            textfield.text = [[UserDataController sharedInstance] currentUser].nickName;
        }
        [button setImage:[UIImage imageNamed:@"modify_btn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"modify_btn_h"] forState:UIControlStateHighlighted];
    }
    
}

- (void)bindingAccount:(id)sender {
    BindingAccountViewController *bindingAccountViewController = [[BindingAccountViewController alloc] init];
    bindingAccountViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    CGSize origSize = bindingAccountViewController.view.size;
    [self presentViewController:bindingAccountViewController animated:NO completion:^{
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

- (void)alertTitle:(NSString *)title message:(NSString *)message
{
    [YYTAlertView alertMessage:message confirmBlock:nil];
}

- (void)validateEmail:(id)sender {
    NSString *email = [UserDataController sharedInstance].currentUser.email;
    [[UserDataController sharedInstance] sendVerficationToEmail:email withCompletion:^(OperationResult *result, NSError *err) {
        if (err) {
            [self alertTitle:@"发送邮箱验证失败" message:[err yytErrorMessage]];
        }
        else {
            NSString *message = [NSString stringWithFormat:@"已向你的邮箱(%@)发送了一封验证邮件，请查收(别忘了检查垃圾箱)", email];
            [self alertTitle:@"验证邮件发送成功" message:message];
        }
    }];
}

- (void)bindingPhone:(id)sender {
    BindingPhoneViewController *bindingPhoneViewController = [[BindingPhoneViewController alloc] init];
    bindingPhoneViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    CGSize origSize = bindingPhoneViewController.view.frame.size;
    [self presentViewController:bindingPhoneViewController animated:NO completion:^{
        UIView *view = bindingPhoneViewController.view;
        UIView *superView = view.superview;
        superView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
        NSArray *subViews = superView.subviews;
        for (UIView *subView in subViews) {
            if (subView != view) {
                subView.hidden = YES;
            }
        }
        CGPoint curCenter = superView.center;
        superView.frame = CGRectMake(0, 0, origSize.height, origSize.width);
        superView.center = curCenter;
    }];
}

- (void)bindingWeibo:(id)sender {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WEIBO_CALLBACK_URL;
    request.scope = @"all";
    request.userInfo = @{};
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = YES;
    [WeiboSDK sendRequest:request];
}

- (void)logout:(id)sender {
    [alertLogout showInView:self.view];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *newNickname = textField.text;
    newNickname = [newNickname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    BOOL invalidation = [newNickname isEqualToString:@""] || [newNickname length] > 30;
    [textField resignFirstResponder];
    if (invalidation) {
        YYTAlert *alert = [[YYTAlert alloc] initWithMessage:@"昵称不能为空，并且不能超过30个字符" confirmBlock:^{
            [textField becomeFirstResponder];
        }];
        [alert showInView:self.view];
    }
    else {
        [self modifyNickname:nil];
        YYTUserDetail *user = [[UserDataController sharedInstance] currentUser];
        if (![newNickname isEqualToString:user.nickName])
        {
            NSDictionary *newInfo = @{@"nickname": newNickname, @"birthday":user.birthday, @"gender":user.gender};
            __weak SettingsViewController *weakSelf = self;
            [[UserDataController sharedInstance] changeUserInfo:newInfo completion:^(BOOL success, NSError *error) {
                [weakSelf changeUserInfoCompletion:success error:error];
            }];
        }
    }
    return YES;
}

- (void)changeUserInfoCompletion:(BOOL)success error:(NSError *)error
{
    if (success) {
        [[UserDataController sharedInstance] currentUser].nickName = self.userManageView.nicknameTextfield.text;
        [AlertWithTip flashSuccessMessage:@"用户昵称已修改"];
    }
    else
    {
        [AlertWithTip flashFailedMessage:[error yytErrorMessage]];
    }
    [self freshSettingsNavigateView];
}

@end
