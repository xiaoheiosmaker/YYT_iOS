//
//  UIViewController+LoadingHUD.m
//  YYTHD
//
//  Created by IAN on 14-1-10.
//  Copyright (c) 2014年 btxkenshin. All rights reserved.
//

#import "UIViewController+LoadingHUD.h"

@implementation UIViewController (LoadingHUD)

- (void)showLoading
{
    UIEdgeInsets edge = UIEdgeInsetsMake(82, 0, 0, 0);
    CGRect frame = UIEdgeInsetsInsetRect(self.view.bounds, edge);
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:frame];
    [self.view addSubview:hud];
	[hud show:YES];
}

- (void)hideLoading
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //[_loadingView removeFromSuperview];
}

@end
