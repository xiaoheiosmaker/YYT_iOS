
//
//  ComSearchView.m
//  YYTHD
//
//  Created by ssj on 13-11-1.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "ComSearchView.h"

@implementation ComSearchView

- (void)awakeFromNib{
     self.params = [[NSMutableDictionary alloc] initWithCapacity:0];
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
- (IBAction)areaBtnClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSDictionary *areaDict = [NSDictionary dictionaryWithObjectsAndKeys:@"ML",@"内地",@"HT",@"港台",@"US",@"欧美",@"KR",@"韩国",@"JP",@"日本",@"ACG",@"二次元",@"Other",@"其他",@"",@"全部", nil];
    NSString *area;
    for (UIView *view in self.areaView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn == button) {
                button.selected = YES;
            }else{
                button.selected = NO;
            }
            area = [areaDict objectForKey:button.titleLabel.text];
        }else{
        }
    }
    [self.params setValue:area forKey:@"area"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(comSerachClicked:)]) {
        [self.delegate comSerachClicked:self.params];
    }

}
- (IBAction)artistBtnClicked:(id)sender {
     UIButton *button = (UIButton *)sender;
    NSDictionary *artistDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Female",@"女艺人",@"Male",@"男艺人",@"Band",@"乐队组合",@"Other",@"其他",@"",@"全部", nil];
    
    NSString *artist;
    for (UIView *view in self.artistView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn == button) {
                button.selected = YES;
            }else{
                button.selected = NO;
            }
            artist = [artistDict objectForKey:button.titleLabel.text];
        }else{
        }
    }
    [self.params setValue:artist forKey:@"singerType"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(comSerachClicked:)]) {
        [self.delegate comSerachClicked:self.params];
    }

}
+ (instancetype)defaultSizeView
{
    CGRect defaultFrame = CGRectZero;
    defaultFrame.size = [self defaultSize];
    
    return [[self alloc] initWithFrame:defaultFrame];
}

+ (CGSize)defaultSize
{
    return CGSizeMake(1024, 120);
}

@end
