//
//  Alert_Tip.m
//  YYTHD
//
//  Created by ssj on 13-11-8.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "AlertWithTip.h"
#import "AppDelegate.h"

@implementation AlertWithTip

+ (void)flashSuccessMessage:(NSString *)message
{
//    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    AlertWithTip *alert = [AlertWithTip defaultSizeViewWithSuccess:message owner:ShareApp.window];
    [alert alertShowAndDisMissAfterTimeInterval:1.5f];
}

+ (void)flashFailedMessage:(NSString *)message
{
//    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    AlertWithTip *alert = [AlertWithTip defaultSizeViewWithFail:message owner:ShareApp.window];
    [alert alertShowAndDisMissAfterTimeInterval:1.5f];
}
+ (void)flashSuccessMessage:(NSString *)message isKeyboard:(BOOL)isKeyboard{
    AlertWithTip *alert = [AlertWithTip defaultSizeViewWithSuccess:message owner:ShareApp.window];
    alert.keyboard = isKeyboard;
    [alert alertShowAndDisMissAfterTimeInterval:1.5f];
}

+ (void)flashFailedMessage:(NSString *)message isKeyboard:(BOOL)isKeyboard{
    AlertWithTip *alert = [AlertWithTip defaultSizeViewWithFail:message owner:ShareApp.window];
    alert.keyboard = isKeyboard;
    [alert alertShowAndDisMissAfterTimeInterval:1.5f];
}


- (id)initWithFrame:(CGRect)frame message:(NSString *)message isSussess:(BOOL)isSuccess delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.owner = delegate;
        self.keyboard = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        imageView.backgroundColor = [UIColor clearColor];
        self.backgroundImageView = imageView;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundImageView];
        self.backgroundImageView.userInteractionEnabled = NO;
        
        self.alertImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1024/2 + 150,768/2-30, 353, 106)];
        self.alertImageView.center = CGPointMake(1024/2, 768/2-20);
        [self addSubview:self.alertImageView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5,5, 240, 96)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = message;
        label.textColor = [UIColor yytDarkGrayColor];
        label.font = [UIFont systemFontOfSize:12];
        if (message.length < 6) {
            label.font = [UIFont systemFontOfSize:14];
        }
        label.backgroundColor = [UIColor clearColor];
        [self.alertImageView addSubview:label];
        if (isSuccess) {
            UIImage *image = IMAGE(@"Alert_Success");
            self.alertImageView.image = image;
        }else{
            UIImage *image = IMAGE(@"Alert_Fail");
             self.alertImageView.image = image;
        }
    }
    return self;
}

- (void)alertShowAndDisMissAfterTimeInterval:(CGFloat)time{
    int y = 0;
    if (self.keyboard) {
        y = 0;
    }else{
        y = 200;
    }
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight){
        self.transform = CGAffineTransformMakeRotation(M_PI/2);
        self.centerX += -150 + y;
        self.centerY += 78 + 50;
    }else{
        self.transform = CGAffineTransformMakeRotation(-M_PI/2);
        self.centerX += -110 - y;
        self.centerY += 78 + 50;
    }
    self.alpha = 0;
    [ShareApp.window addSubview:self];
    
//    [vc.view addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(closeAlert:) userInfo:self repeats:NO];
        }
    }];
    
}
- (void)closeAlert:(NSTimer*)timer {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    
//    [(UIAlertView*) timer.userInfo  dismissWithClickedButtonIndex:0 animated:YES];
}
+ (instancetype)defaultSizeViewWithSuccess:(NSString *)message owner:(id)delegate
{
    CGRect defaultFrame = CGRectZero;
    defaultFrame.size = [self defaultSize];
    return [[self alloc] initWithFrame:defaultFrame message:message isSussess:YES delegate:delegate];
}

+ (instancetype)defaultSizeViewWithFail:(NSString *)message owner:(id)delegate{
    CGRect defaultFrame = CGRectZero;
    defaultFrame.size = [self defaultSize];
    return [[self alloc] initWithFrame:defaultFrame message:message isSussess:NO delegate:delegate];
}

+ (CGSize)defaultSize
{
    return CGSizeMake(1024, 768);
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
