//
//  CallendarItemView.m
//  YYTHD
//
//  Created by ssj on 13-10-17.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "CalendarItemView.h"
#import "YYTUILabel.h"

@implementation CalendarItemView

- (void)awakeFromNib{
    //    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    self.monthLabel.textColor = [UIColor colorWithWhite:1 alpha:0.9];
    [self.firstBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
    [self.secondBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
    [self.thirdBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
    [self.fourthBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
    [self.fifthBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (IBAction)firBtnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarItemViewBtnClick:)]) {
        [self.delegate calendarItemViewBtnClick:btn.tag];
    }
    
}
- (IBAction)secondClick:(id)sender {
     UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarItemViewBtnClick:)]) {
        [self.delegate calendarItemViewBtnClick:btn.tag];
    }
    
}
- (IBAction)thirdClicked:(id)sender {
     UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarItemViewBtnClick:)]) {
        [self.delegate calendarItemViewBtnClick:btn.tag];
    }
}
- (IBAction)fourthClickde:(id)sender {
     UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarItemViewBtnClick:)]) {
        [self.delegate calendarItemViewBtnClick:btn.tag];
    }
}
- (IBAction)fifthclicked:(id)sender {
     UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarItemViewBtnClick:)]) {
        [self.delegate calendarItemViewBtnClick:btn.tag];
    }
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
