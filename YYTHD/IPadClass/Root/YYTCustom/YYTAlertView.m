//
//  YYTAlertView.m
//  YYTHD
//
//  Created by 崔海成 on 2/24/14.
//  Copyright (c) 2014 btxkenshin. All rights reserved.
//

#import "YYTAlertView.h"
#define IMAEG_BORDER_WIDTH 6
const UIWindowLevel UIWindowLevelYYTAlert = 1999.0;

@interface UIWindow (YYTAlertView)
- (UIViewController *)currentViewController;
@end

@implementation UIWindow (YYTAlertView)

- (UIViewController *)currentViewController
{
    UIViewController *viewController = self.rootViewController;
    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }
    return viewController;
}

@end

@interface YYTAlertViewController : UIViewController
@property (nonatomic, strong) YYTAlertView *alertView;
@property (nonatomic, weak) IBOutlet UIView *boxView;
@end

@implementation YYTAlertViewController
- (void)loadView
{
    self.view = self.alertView;
    self.boxView = [[self.view subviews] lastObject];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGFloat oldCenterY = self.boxView.centerY;
    self.boxView.centerY = -1 * self.boxView.size.height;
    
    __weak YYTAlertViewController *weakSelf = self;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.boxView.centerY = oldCenterY + 30;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            weakSelf.boxView.centerY = oldCenterY;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    UIViewController *viewController = [self.alertView.oldKeyWindow currentViewController];
    if (viewController) {
        return [viewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
    return YES;
}

- (BOOL)shouldAutorotate
{
    UIViewController *viewController = [self.alertView.oldKeyWindow currentViewController];
    if (viewController) {
        return [viewController shouldAutorotate];
    }
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    UIViewController *viewController = [self.alertView.oldKeyWindow currentViewController];
    if (viewController) {
        return [viewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskAll;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass([YYTAlertViewController class]));
}
@end

@implementation YYTAlertView

+ (void)flashSuccessMessage:(NSString *)message
{
    YYTAlertView *alertView = [[self alloc] initWithMessage:message success:YES];
    [alertView buildFlashUI];
    [alertView show];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:alertView selector:@selector(close:) userInfo:nil repeats:NO];
}

+ (void)flashFailureMessage:(NSString *)message
{
    YYTAlertView *alertView = [[self alloc] initWithMessage:message success:NO];
    [alertView buildFlashUI];
    [alertView show];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:alertView selector:@selector(close:) userInfo:nil repeats:NO];
}

+ (void)alertMessage:(NSString *)message confirmBlock:(CallbackBlock)confirmBlock
{
    YYTAlertView *alertView = [[self alloc] initWithMessage:message confirmBlock:confirmBlock];
    [alertView buildAlertUI];
    [alertView show];
}

+ (void)alertMessage:(NSString *)message confirmBlock:(CallbackBlock)confirmBlock cancelBlock:(CallbackBlock)cancelBlock
{
    YYTAlertView *alertView = [[self alloc] initWithMessage:message confirmBlock:confirmBlock cancelBlock:cancelBlock];
    [alertView buildAlertUI];
    [alertView show];
}

- (id)initWithMessage:(NSString *)message
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.message = message;
    }
    return self;
}

- (id)initWithMessage:(NSString *)message success:(BOOL)success
{
    self = [self initWithMessage:message];
    if (self) {
        self.success = success;
    }
    return self;
}

- (id)initWithMessage:(NSString *)message confirmBlock:(CallbackBlock)confirmBlock
{
    self = [self initWithMessage:message];
    if (self) {
        self.confirmBlock = confirmBlock;
    }
    return self;
}

- (id)initWithMessage:(NSString *)message confirmBlock:(CallbackBlock)confirmBlock cancelBlock:(CallbackBlock)cancelBlock
{
    self = [self initWithMessage:message];
    if (self) {
        self.confirmBlock = confirmBlock;
        self.cancelBlock = cancelBlock;
        self.isConfirmCanelAlert = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    NSException *exception = [NSException exceptionWithName:@"无法初始化" reason:@"请使用initWithMessage:success:" userInfo:nil];
    @throw exception;
}

- (void)buildFlashUI
{
    isBuilded = YES;
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    self.frame = CGRectMake(0, 0, 1024, 768);
    
    UIView *boxView = [self buildBoxView];
    [self addSubview:boxView];
    
    UIImage *messageImage = self.success ? [UIImage imageNamed:@"Alert_Success"] : [UIImage imageNamed:@"Alert_Fail"];
    UIImageView *messageImageView = [[UIImageView alloc] initWithImage:messageImage];
    [boxView addSubview:messageImageView];
    
    // 图片中的消息区域大小, 测量Alert_Success/Alert_Fail得来
    CGSize messageSizeInImage = CGSizeMake(243, 96);
    UILabel *messageLabel = [self messageLabelWithFrame:CGRectMake(IMAEG_BORDER_WIDTH, IMAEG_BORDER_WIDTH, messageSizeInImage.width, messageSizeInImage.height)];
    messageLabel.text = self.message;
    [boxView addSubview:messageLabel];
    
    boxView.frame = CGRectMake(0, 0, messageImage.size.width, messageImage.size.height);
    boxView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
}

- (void)buildAlertUI
{
    isBuilded = YES;
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    self.frame = CGRectMake(0, 0, 1024, 768);
    
    UIView *boxView = [self buildBoxView];
    [self addSubview:boxView];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"AlertBackground"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [boxView addSubview:backgroundImageView];
    
    // 图片中的消息区域大小, 测量AlertBackground得来
    CGSize messageSizeInImage = CGSizeMake(410, 151);
    UILabel *messageLabel = [self messageLabelWithFrame:CGRectMake(IMAEG_BORDER_WIDTH, IMAEG_BORDER_WIDTH, messageSizeInImage.width, messageSizeInImage.height)];
    messageLabel.text = self.message;
    [boxView addSubview:messageLabel];
    
    // 图片中的按钮区域大小, 测量AlertBackground得来
    CGRect buttonsRectInImage = CGRectMake(6, 156, 410, 72);
    if (self.isConfirmCanelAlert) {
        UIButton *cancelButton = [self cancelButton];
        UIButton *confirmButton = [self confirmButton];
        
        CGSize buttonSize = confirmButton.size;
        CGFloat horizontalGap = (buttonsRectInImage.size.width - buttonSize.width * 2) / 3.0;
        CGFloat verticalGap = (buttonsRectInImage.size.height - buttonSize.height) / 2.0;
        
        cancelButton.frame = CGRectMake(buttonsRectInImage.origin.x + horizontalGap, buttonsRectInImage.origin.y + verticalGap, buttonSize.width, buttonSize.height);
        confirmButton.frame = CGRectMake(cancelButton.frame.origin.x + buttonSize.width + horizontalGap, cancelButton.frame.origin.y, buttonSize.width, buttonSize.height);
        
        [boxView addSubview:cancelButton];
        [boxView addSubview:confirmButton];
    }
    else {
        UIButton *confirmButton = [self confirmButton];
        CGSize buttonSize = confirmButton.size;
        CGFloat horizontalGap = (buttonsRectInImage.size.width - buttonSize.width) / 2.0;
        CGFloat verticalGap = (buttonsRectInImage.size.height - buttonSize.height) / 2.0;
        confirmButton.frame = CGRectMake(buttonsRectInImage.origin.x + horizontalGap, buttonsRectInImage.origin.y + verticalGap, buttonSize.width, buttonSize.height);
        [boxView addSubview:confirmButton];
    }
    
    boxView.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
    boxView.center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
}

- (UIButton *)confirmButton
{
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage = [UIImage imageNamed:@"binding_sure"];
    UIImage *highlightImage = [UIImage imageNamed:@"binding_sure_h"];
    confirmButton.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    [confirmButton setImage:normalImage forState:UIControlStateNormal];
    [confirmButton setImage:highlightImage forState:UIControlStateHighlighted];
    [confirmButton addTarget:self action:@selector(runConfirmBlock:) forControlEvents:UIControlEventTouchUpInside];
    return confirmButton;
}

- (UIButton *)cancelButton
{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalImage = [UIImage imageNamed:@"MV_Detail_Cancel"];
    UIImage *highlightImage = [UIImage imageNamed:@"MV_Detail_Cancel_Sel"];
    cancelButton.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    [cancelButton setImage:normalImage forState:UIControlStateNormal];
    [cancelButton setImage:highlightImage forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(runCancelBlock:) forControlEvents:UIControlEventTouchUpInside];
    return cancelButton;
}

- (void)runConfirmBlock:(id)sender
{
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    [self dismiss];
}

- (void)runCancelBlock:(id)sender
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismiss];
}

- (UIView *)buildBoxView
{
    UIView *boxView = [[UIView alloc] init];
    boxView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    return boxView;
}

- (UILabel *)messageLabelWithFrame:(CGRect)frame
{
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.frame = frame;
    messageLabel.font = [UIFont systemFontOfSize:15.0];
    messageLabel.numberOfLines = 2;
    return messageLabel;
}

- (void)show
{
    NSAssert(isBuilded, @"需要构建界面, 请使用类方法");
    
    self.oldKeyWindow = [UIApplication sharedApplication].keyWindow;
    if (!self.alertWindow) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        window.windowLevel = UIWindowLevelYYTAlert;
        YYTAlertViewController *alertViewController = [[YYTAlertViewController alloc] init];
        alertViewController.alertView = self;
        window.rootViewController = alertViewController;
        self.alertWindow = window;
    }
    
    [self.alertWindow makeKeyAndVisible];
}

- (void)close:(NSTimer *)timer
{
    [self dismiss];
}

- (void)dismiss
{
    [self.alertWindow removeFromSuperview];
    self.alertWindow = nil;
    UIWindow *window = self.oldKeyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows[0];
    }
    [window makeKeyWindow];
    window.hidden = NO;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass([YYTAlertView class]));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
