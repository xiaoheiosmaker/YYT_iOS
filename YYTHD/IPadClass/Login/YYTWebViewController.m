//
//  YYTRegisterViewController.m
//  YYTHD
//
//  Created by 崔海成 on 11/12/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "YYTWebViewController.h"

@interface YYTWebViewController ()

@property (nonatomic, strong)NSURL *rootURL;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation YYTWebViewController

- (id)initWithURL:(NSURL *)pageURL
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.rootURL = pageURL;
    }
    return self;
}

- (void)back
{
    [self.webView goBack];
}

- (void)forward
{
    [self.webView goForward];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithURL:[NSURL URLWithString:@"http://www.yinyuetai.com"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.rootURL]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

@end
