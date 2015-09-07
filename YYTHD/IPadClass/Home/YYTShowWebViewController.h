//
//  YYTShowWebViewController.h
//  YYTHD
//
//  Created by ssj on 13-11-12.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface YYTShowWebViewController : BaseViewController<UIWebViewDelegate>{

}
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *refreshBtn;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;

- (void)loadRequestWithURL:(NSURL *)url;

- (void)loadRequestWithURL:(NSURL *)url backToHomePage:(BOOL)isBack;

- (void)refreshWebPage;
@end
