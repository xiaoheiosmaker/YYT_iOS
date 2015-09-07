//
//  PlatformSelectViewController.m
//  YYTHD
//
//  Created by 崔海成 on 12/2/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "PlatformSelectViewController.h"

@interface PlatformSelectViewController ()
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *qzoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *tencentBtn;
@property (weak, nonatomic) IBOutlet UIButton *renrenBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatTimelineBtn;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
- (void)setupBtnView:(UIButton *)btn;

- (IBAction)shareToWeibo:(id)sender;
- (IBAction)shareToQzone:(id)sender;
- (IBAction)shareToTencent:(id)sender;
- (IBAction)shareToRenren:(id)sender;
- (IBAction)shareToWechatTimeline:(id)sender;

@end

@implementation PlatformSelectViewController

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
    // Do any additional setup after loading the view from its nib.
    self.contentSizeForViewInPopover = self.view.size;
    self.view.backgroundColor = [UIColor clearColor];
    self.shareLabel.textColor = [UIColor whiteColor];
    [self setupBtnView:self.weiboBtn];
    [self setupBtnView:self.qzoneBtn];
    [self setupBtnView:self.tencentBtn];
    [self setupBtnView:self.renrenBtn];
    [self setupBtnView:self.wechatTimelineBtn];
}

- (void)setupBtnView:(UIButton *)btn
{
    UIImage *img = [UIImage imageNamed:@"quality_btn"];
    CGSize size = img.size;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(btn.origin.x, btn.origin.y, size.width, size.height);
    btn.center = CGPointMake(self.view.width / 2, btn.center.y);
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    img = [UIImage imageNamed:@"quality_btn_h"];
    [btn setBackgroundImage:img forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareToWeibo:(id)sender {
    [self platformSelected:OP_WEIBO];
}

- (IBAction)shareToQzone:(id)sender {
    [self platformSelected:OP_QZONE];
}

- (IBAction)shareToTencent:(id)sender {
    [self platformSelected:OP_TENCENT];
}

- (IBAction)shareToRenren:(id)sender {
    [self platformSelected:OP_RENREN];
}

- (IBAction)shareToWechatTimeline:(id)sender {
    [self platformSelected:OP_WECHATTIMELINE];
}

- (void)platformSelected:(OpenPlatformType)opType
{
    [self.delegate selectOpenPlatform:opType];
}

@end
