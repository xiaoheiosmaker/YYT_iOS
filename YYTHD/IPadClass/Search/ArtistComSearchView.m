//
//  ArtistComSearchView.m
//  YYTHD
//
//  Created by ssj on 13-11-2.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "ArtistComSearchView.h"
#import "MVSearchCondition.h"
#define OptionBaseTag 100
@implementation ArtistComSearchView

- (id)initWithFrame:(CGRect)frame condition:(MVSearchCondition *)condition
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _itemSpacing = 10;
        _itemSize = CGSizeMake(55, 28);
        _condition = condition;
        self.backgroundColor = [UIColor clearColor];
        //生成选项BTN
        NSArray *titleArray = [condition optionNames];
        NSInteger index = 0;
        for (NSString *title in titleArray) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(optionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = index+OptionBaseTag;
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitleColor:[UIColor yytLightGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor yytGreenColor] forState:UIControlStateSelected];
//            [btn setBackgroundImage:IMAGE(@"BackGround_Green") forState:UIControlStateSelected];
            //选中默认
            if (index == condition.selectedIndex) {
                btn.selected = YES;
            }
            [self addSubview:btn];
            ++index;
        }
    }
    return self;
}

- (void)setItemSize:(CGSize)itemSize
{
    if (!CGSizeEqualToSize(_itemSize, itemSize)) {
        _itemSize = itemSize;
        [self setNeedsLayout];
    }
}

- (void)setItemSpacing:(NSInteger)itemSpacing
{
    if (_itemSpacing != itemSpacing) {
        _itemSpacing = itemSpacing;
        [self setNeedsLayout];
    }
}

//根据itemSize,itemSpacing重新排版
- (void)layoutSubviews
{
    //[super layoutSubviews];
    
    CGFloat itemWidth = _itemSize.width;
    CGFloat itemHeight = _itemSize.height;
    
    CGFloat x = _itemSpacing;
    CGFloat y = (CGRectGetHeight(self.frame)-itemHeight)/2;
    
    NSArray *subviews = [self subviews];
    for (int i=0; i<subviews.count; ++i) {
        UIView *view = [self viewWithTag:i+OptionBaseTag];
        view.frame = CGRectMake(x, y, itemWidth, itemHeight);
        x += (itemWidth+_itemSpacing);
    }
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 100, itemHeight)];
//    label.text = self.title;
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    [self addSubview:label];
}

- (void)optionBtnClicked:(id)sender
{
    BOOL allowSelected = YES;
    NSInteger index = [sender tag] - OptionBaseTag;
    
    //询问是否允许选中
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(conditionView:shouldSelectOptionAtIndex:)]) {
        allowSelected = [self.actionDelegate conditionView:self shouldSelectOptionAtIndex:index];
    }
    
    if (!allowSelected) {
        return;
    }
    
    //选中选项
    NSInteger perIndex = [_condition selectedIndex];
    UIButton *perBtn = (UIButton *)[self viewWithTag:perIndex+OptionBaseTag];
    [perBtn setSelected:NO];
    [sender setSelected:YES];
    [_condition selectOptionAtIndex:index];
    
    //回调代理
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(conditionViewDidSelectedOption:)]) {
        [self.actionDelegate conditionViewDidSelectedOption:self];
    }
}

@end

