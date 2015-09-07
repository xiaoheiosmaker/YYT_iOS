//
//  SettingsPaneView.m
//  YYTHD
//
//  Created by shuilin on 10/24/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "SettingsPaneView.h"

@interface SettingsPaneView ()
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property(retain,nonatomic) IBOutlet UIView* anchorView1;
@property(retain,nonatomic) IBOutlet UIView* anchorView2;
@property(retain,nonatomic) IBOutlet UIView* anchorView3;
@property(retain,nonatomic) IBOutlet UIView* anchorView4;
@end

@implementation SettingsPaneView

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
    CGFloat x,y;
    CGFloat width,height;
    CGRect rect;
    
    //＊缓存设置
    //self.videoQualityCell = [[[NSBundle mainBundle] loadNibNamed:@"VideoQualityCell" owner:self options:nil] lastObject];
    //[self addSubview:self.videoQualityCell];
    UIImage *image = [UIImage imageNamed:@"contentBackground"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    self.backgroundImageView.image = image;
    
    self.clearPlayHistory = [[[NSBundle mainBundle] loadNibNamed:@"NormalSwitchCell" owner:self options:nil] lastObject];
    [self addSubview:self.clearPlayHistory];
    self.clearPlayHistory.leftLabel.text = @"清除播放历史";
    self.clearPlayHistory.switcher.hidden = YES;
    self.clearPlayHistory.clearButton.hidden = NO;
    
    self.clearSearchHistory = [[[NSBundle mainBundle] loadNibNamed:@"NormalSwitchCell" owner:self options:nil] lastObject];
    [self addSubview:self.clearSearchHistory];
    self.clearSearchHistory.leftLabel.text = @"清除搜索历史";
    self.clearSearchHistory.switcher.hidden = YES;
    self.clearSearchHistory.clearButton.hidden = NO;
    
    self.lockSwitchCell = [[[NSBundle mainBundle] loadNibNamed:@"NormalSwitchCell" owner:self options:nil] lastObject];
    [self addSubview:self.lockSwitchCell];
    self.lockSwitchCell.leftLabel.text = @"缓存时禁止自动锁屏";
    
    //＊共享设置
    self.sinaCell = [[[NSBundle mainBundle] loadNibNamed:@"LoginAccountCell" owner:self options:nil] lastObject];
    [self addSubview:self.sinaCell];
    self.sinaCell.titleLabel.text = @"新浪微博";
    
    self.qqCell = [[[NSBundle mainBundle] loadNibNamed:@"LoginAccountCell" owner:self options:nil] lastObject];
    [self addSubview:self.qqCell];
    self.qqCell.titleLabel.text = @"qq空间";
    
    self.tencentCell = [[[NSBundle mainBundle] loadNibNamed:@"LoginAccountCell" owner:self options:nil] lastObject];
    [self addSubview:self.tencentCell];
    self.tencentCell.titleLabel.text = @"腾讯微博";
    
    self.renrenCell = [[[NSBundle mainBundle] loadNibNamed:@"LoginAccountCell" owner:self options:nil] lastObject];
    [self addSubview:self.renrenCell];
    self.renrenCell.titleLabel.text = @"人人网";
    
    //*消息提醒
    self.messageTipCell = [[[NSBundle mainBundle] loadNibNamed:@"NormalSwitchCell" owner:self options:nil] lastObject];
    [self addSubview:self.messageTipCell];
    self.messageTipCell.leftLabel.text = @"当有新的音悦台消息时提醒我";
    
    self.mvTipCell = [[[NSBundle mainBundle] loadNibNamed:@"NormalSwitchCell" owner:self options:nil] lastObject];
    [self addSubview:self.mvTipCell];
    self.mvTipCell.leftLabel.text = @"当订阅艺人有新的MV时提醒我";
    
   

    
    //*网络
    /*self.saveTipCell = [[[NSBundle mainBundle] loadNibNamed:@"NormalSwitchCell" owner:self options:nil] lastObject];
    [self addSubview:self.saveTipCell];
    self.saveTipCell.leftLabel.text = @"在3G下播放或缓存MV";
    */
    
    self.netTipCell = [[[NSBundle mainBundle] loadNibNamed:@"NormalSwitchCell" owner:self options:nil] lastObject];
    [self addSubview:self.netTipCell];
    self.netTipCell.leftLabel.text = @"使用3G网络时提醒我";
    
    
    self.userGuide = [[[NSBundle mainBundle] loadNibNamed:@"NormalSwitchCell" owner:self options:nil] lastObject];
    [self addSubview:self.userGuide];
    self.userGuide.leftLabel.text = @"新手引导";
    self.userGuide.switcher.hidden = YES;
    self.userGuide.clearButton.hidden = NO;
    [self.userGuide.clearButton setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [self.userGuide.clearButton setImage:[UIImage imageNamed:@"check_sel"] forState:UIControlStateHighlighted];
    
    //清晰度位置
    x = self.anchorView1.origin.x;
    y = self.anchorView1.origin.y;
    
    /*width = self.videoQualityCell.frame.size.width;
    height = self.videoQualityCell.frame.size.height;
    rect = CGRectMake(x, y, width, height);
    self.videoQualityCell.frame = rect;*/

    //缓存时禁止自动锁屏位置
    //y = y + height;
    width = self.lockSwitchCell.frame.size.width;
    height = self.lockSwitchCell.frame.size.height;
    rect = CGRectMake(x, y, width, height);
    self.lockSwitchCell.frame = rect;
    //第一行背景图调整一下
    rect = self.lockSwitchCell.backImageView.frame;
    rect.origin.y += 1;
    rect.size.height -= 1;
    self.lockSwitchCell.backImageView.frame = rect;
    
    y = y + height;
    width = self.clearPlayHistory.frame.size.width;
    height = self.clearPlayHistory.frame.size.height;
    rect = CGRectMake(x, y, width, height);
    self.clearPlayHistory.frame = rect;
    
    y = y + height;
    width = self.clearSearchHistory.frame.size.width;
    height = self.clearSearchHistory.frame.size.height;
    rect = CGRectMake(x, y, width, height);
    self.clearSearchHistory.frame = rect;
    
    //新浪微博位置
    x = self.anchorView3.origin.x;
    y = self.anchorView3.origin.y;
    width = self.sinaCell.frame.size.width;
    height = self.sinaCell.frame.size.height;
    rect = CGRectMake(x, y, width, height);
    self.sinaCell.frame = rect;
    //第一行背景图调整一下
    rect = self.sinaCell.backImageView.frame;
    rect.origin.y += 1;
    rect.size.height -= 1;
    self.sinaCell.backImageView.frame = rect;
    
    //qq空间位置
    y = y + height;
    width = self.qqCell.frame.size.width;
    height = self.qqCell.frame.size.height;
    rect = CGRectMake(x, y, width, height);
    self.qqCell.frame = rect;
    
    //腾讯微博位置
    y = y + height;
    width = self.tencentCell.frame.size.width;
    height = self.tencentCell.frame.size.height;
    rect = CGRectMake(x, y, width, height);
    self.tencentCell.frame = rect;
    
    //人人网位置
    y = y + height;
    width = self.renrenCell.frame.size.width;
    height = self.renrenCell.frame.size.height;
    rect = CGRectMake(x, y, width, height);
    self.renrenCell.frame = rect;
    
    //
    x = self.anchorView2.origin.x;
    y = self.anchorView2.origin.y;
    width = self.messageTipCell.frame.size.width;
    height = self.messageTipCell.frame.size.height;
    rect = CGRectMake(x, y, width, height);
    self.messageTipCell.frame = rect;
    //第一行背景图调整一下
    rect = self.messageTipCell.backImageView.frame;
    rect.origin.y += 1;
    rect.size.height -= 1;
    self.messageTipCell.backImageView.frame = rect;
    
    //
    y = y + height;
    width = self.mvTipCell.frame.size.width;
    height = self.mvTipCell.frame.size.height;
    rect = CGRectMake(x, y, width, height);
    self.mvTipCell.frame = rect;
    
    //
    x = self.anchorView4.origin.x;
    y = self.anchorView4.origin.y;
    /*width = self.saveTipCell.frame.size.width;
    height = self.saveTipCell.frame.size.height;
    rect = CGRectMake(x, y, width, height);
    self.saveTipCell.frame = rect;
    
    //
    y = y + height;*/
    width = self.netTipCell.frame.size.width;
    height = self.netTipCell.frame.size.height;
    rect = CGRectMake(x, y, width, height);
    self.netTipCell.frame = rect;
    //第一行背景图调整一下
    rect = self.netTipCell.backImageView.frame;
    rect.origin.y += 1;
    rect.size.height -= 1;
    self.netTipCell.backImageView.frame = rect;
    
    y = y + height;
    width = self.netTipCell.frame.size.width;
    height = self.netTipCell.frame.size.height;
    rect = CGRectMake(x, y, width, height);
    self.userGuide.frame = rect;
    
}

@end
