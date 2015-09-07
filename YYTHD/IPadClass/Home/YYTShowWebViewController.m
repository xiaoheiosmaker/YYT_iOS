//
//  YYTShowWebViewController.m
//  YYTHD
//
//  Created by ssj on 13-11-12.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTShowWebViewController.h"

@interface YYTShowWebViewController (){
    UIWebView *_webView;
    BOOL isBackToHome;
}

@end

@implementation YYTShowWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resetTopView:YES];
    [self.topView isShowTimeButton:NO];
    [self.topView isShowTextField:NO];
    [self.topView isShowSideButton:NO];
    self.topView.unReadCountLabel.hidden = YES;
    self.topView.unReadImageView.hidden = YES;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(400, 22, 600,20)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self.topView addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.centerX = self.topView.centerX;
    // Do any additional setup after loading the view from its nib.
}

- (void)resetTopView:(BOOL)isRoot{
    [super resetTopView:isRoot];
    CGRect refreshBtnFrame = CGRectMake(1024 - 80, (kTopBarHeight - 45) / 2, 80, 50);
    _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_refreshBtn setImage:IMAGE(@"refresh") forState:UIControlStateNormal];
    [_refreshBtn setImage:IMAGE(@"refresh_sel") forState:UIControlStateHighlighted];
    _refreshBtn.frame = refreshBtnFrame;
    [_refreshBtn addTarget:self action:@selector(refreshBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:_refreshBtn];
    

    
    
    CGRect backBtnFrame = CGRectMake(-20, (kTopBarHeight - 45) / 2, 80, 50);
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:IMAGE(@"navi_back") forState:UIControlStateNormal];
    [_backBtn setImage:IMAGE(@"navi_back_h") forState:UIControlStateHighlighted];
    _backBtn.frame = backBtnFrame;
    [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:_backBtn];
}

- (void)refreshBtnClicked:(id)sender{
    [_webView reload];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[request.URL absoluteString] hasPrefix:@"https://itunes"]) {
        if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
            [[UIApplication sharedApplication] openURL:request.URL];
            return NO;
        }
    }
    if ([[request.URL absoluteString] hasPrefix:@"http://itunes"]) {
        if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
            [[UIApplication sharedApplication] openURL:request.URL];
            return NO;
        }
    }
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    UILabel *titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setText:title];
    self.navigationItem.titleView = titleLabel;
    
}

- (void)refreshWebPage
{
    [_webView reload];
}

- (void)loadRequestWithURL:(NSURL *)url
{
    if (_webView == nil) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 80, 1024-250, 865)];
            
        }
        else
        {
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, 1024-250, 885)];
        }
        _webView.scalesPageToFit = YES;
        _webView.userInteractionEnabled = YES;
        _webView.delegate = self;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_webView];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

- (void)loadRequestWithURL:(NSURL *)url backToHomePage:(BOOL)isBack{
    if (_webView == nil) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] applicationFrame].size.height + 20)];
            
        }
        else
        {
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] applicationFrame].size.height)];
        }
        _webView.scalesPageToFit = YES;
        _webView.userInteractionEnabled = YES;
        _webView.delegate = self;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_webView];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
	isBackToHome = isBack;
}
- (void)backBtnClicked:(id)sender{
    
//    if (_webView.canGoBack) {
//        [_webView goBack];
//    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
    
//    if (isBackToHome == NO)
//    {
//        NSArray *viewControllers = self.navigationController.viewControllers;
//        if ([viewControllers count] > 1) {
//            if (viewControllers.count-2>0)
//            {
//                SearchViewController *viewController = (SearchViewController*)[viewControllers objectAtIndex:viewControllers.count-2];
//                [self.navigationController popToViewController:viewController animated:YES];
//            }
//        }
//        else
//        {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        isBackToHome = YES;
//        
//    }else{
//        
////        NSArray *viewControllers = self.navigationController.viewControllers;
//        [self.navigationController popToRootViewControllerAnimated:YES];
////        if ([viewControllers count] > 1) {
////            UIViewController *viewController = [viewControllers objectAtIndex:1];
////            [self.navigationController popToViewController:viewController animated:YES];
////        }
////        else
////        {
////            [self.navigationController popViewControllerAnimated:YES];
////        }
//    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
