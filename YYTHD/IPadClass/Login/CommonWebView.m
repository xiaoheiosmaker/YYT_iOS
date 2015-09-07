//
//  RegisterView.m
//  YYTHD
//
//  Created by 崔海成 on 11/12/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "CommonWebView.h"
@implementation CommonWebView
{
    UIWebView *_webView;
}
- (id)initWithURLString:(NSString *)URLString frame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    if (self) {
        NSURL *registerURL = [NSURL URLWithString:URLString];
        [_webView loadRequest:[NSURLRequest requestWithURL:registerURL]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.autoresizesSubviews = YES;
        
        CGRect webFrame = CGRectMake(0, 0, 800, 600);
        CGFloat borderWidth = 20.0;
        CGRect borderFrame = CGRectMake(0, 0, webFrame.size.width + borderWidth, webFrame.size.height + borderWidth);
        UIView *borderView = [[UIView alloc] initWithFrame:borderFrame];
        borderView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        borderView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        [self addSubview:borderView];
        
        _webView = [[UIWebView alloc] initWithFrame:webFrame];
        _webView.delegate = self;
        _webView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        _webView.scalesPageToFit = YES;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_webView];
        
        UIImage *closeBtnIcon = [UIImage imageNamed:@"register_close"];
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn setImage:closeBtnIcon forState:UIControlStateNormal];
        closeBtn.frame = CGRectMake(borderView.origin.x, borderView.origin.y, closeBtnIcon.size.width, closeBtnIcon.size.height);
        [self addSubview:closeBtn];
    }
    return self;
}

- (void)closeBtnClicked:(id)sender
{
    [self removeFromSuperview];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *currentURLString = [NSString stringWithFormat:@"%@", webView.request.URL];
    // 因为现在的实现是注册页面ajax实现的，如果页面URL跳转表明注册成功
    if ([currentURLString isEqualToString:@"http://login.yinyuetai.com/reg_step3?callback="]) {
        [self removeFromSuperview];
        [UIAlertView alertViewWithTitle:@"注册成功" message:@"你在音悦台成功的注册了，请登录吧"];
    }
}

@end
