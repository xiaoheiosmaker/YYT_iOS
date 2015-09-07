//
//  CombinationView.m
//  YYTHD
//
//  Created by ssj on 13-10-30.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "CombinationView.h"

@implementation CombinationView

- (void)awakeFromNib{
    
}

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
- (IBAction)combinationBtnClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn == button) {
                btn.selected = YES;
            }else{
                btn.selected = NO;
            }
        }else{
        }
    }
    NSLog(@"%@",button.titleLabel.text);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Official",@"官方版",@"Concert",@"演唱会",@"Live",@"现场版",@"Fans",@"饭团视频",@"Subtitles",@"字幕版",@"Others",@"竖屏版", nil];
    NSString *condition = [dict objectForKey:button.titleLabel.text];
    if (self.delegate && [self.delegate respondsToSelector:@selector(comBtnClicked:)]) {
        [self.delegate comBtnClicked:condition];
    }
}

@end
