//
//  MVChannelListView.m
//  YYTHD
//
//  Created by IAN on 13-10-18.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "MVChannelChooseView.h"
#import "MVChannel.h"
#import "MVChannelButton.h"
#import "ExButton.h"

#define kChannelBtnBaseTag 100
#define kChannelItemWidth 80 //包含边距

@interface MVChannelChooseView ()
{
    NSMutableArray *_subsChannelList; //已订阅频道
    NSArray *_channelList; //所有频道列表
    
    UIScrollView *_subsChannelView;
    UIScrollView *_unSubsChannelView;
    
    MVChannelButton *_selectedBtn;
    
    UIButton *_editBtn;
}

@end


@implementation MVChannelChooseView

- (id)initWithFrame:(CGRect)frame channelList:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        
        _subsChannelList = [NSMutableArray array];
        _channelList = [array copy];
        
        _subsChannelView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_subsChannelView];
        
        CGRect frame2 = frame;
        frame2.origin.y = CGRectGetHeight(frame);
        _unSubsChannelView = [[UIScrollView alloc] initWithFrame:frame2];
        [self addSubview:_unSubsChannelView];
        
        //CGFloat centerX1 = itemWidth/2;
        //CGFloat centerX2 = centerX1;
        //CGFloat centerY = CGRectGetHeight(frame)/2;
        
        NSInteger i = 0;
        for (MVChannel *channel in array) {
            MVChannelButton *btn = [MVChannelButton channelButton];
            [btn setValueWithMVChannel:channel];
            [btn addTarget:self action:@selector(channelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                [btn setSelected:YES]; //选中第一项
                _selectedBtn = btn;
            }
            btn.index = i++;
            
            if ([channel subscribed]) {
                [_subsChannelList addObject:channel];
                btn.tag = [[_subsChannelView subviews] count]+kChannelBtnBaseTag;
                [_subsChannelView addSubview:btn];
            } else {
                [btn setGray:YES]; //变灰
                btn.tag = [[_unSubsChannelView subviews] count]+kChannelBtnBaseTag;
                [_unSubsChannelView addSubview:btn];
            }
        }
        
        //在订阅频道最后添加编辑按钮
        ExButton *editBtn = [[ExButton alloc] initWithFrame:CGRectMake(0, 0, 62, 80)];
        [editBtn setNormalImage:[UIImage imageNamed:@"channelAdd"] highlightedImage:[UIImage imageNamed:@"channelAdd_h"]];
        [editBtn setExSelectedImage:[UIImage imageNamed:@"channelSure"] highlightedImage:[UIImage imageNamed:@"channelSure_h"]];
        [editBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 18, 0)];
        [editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        editBtn.tag = [[_subsChannelView subviews] count]+kChannelBtnBaseTag;
        [_subsChannelView addSubview:editBtn];
        _editBtn = editBtn;
        
        [self layoutScrollView:_subsChannelView];
        [self layoutScrollView:_unSubsChannelView];
        
        _subsChannelView.backgroundColor = [UIColor yytTransparentBlackColor];
        _unSubsChannelView.backgroundColor = [UIColor yytTransparentBlackColor];
    }
    return self;
}

- (NSArray *)selectedChannelArray
{
    MVChannel *channel = [_channelList objectAtIndex:_selectedBtn.index];
    return @[channel];
    /*
    if ([channel.channelID integerValue] > 0) {
        return @[channel];
    }
    
    return [_subsChannelList copy];
     */
}


#pragma mark - Btn Actions
- (void)channelBtnClicked:(id)sender
{
    //BOOL isSelected = [sender isSelected];
    NSInteger index = [sender index];
    
    MVChannelButton *channelBtn = (MVChannelButton *)sender;
    if ([sender isDescendantOfView:_subsChannelView]) {
        //上排按钮点击
        if (self.editing) {
            //编辑状态，取消订阅
            MVChannel *channel = [_channelList objectAtIndex:channelBtn.index];
            if ([[channel channelID] integerValue] < 0) {
                //全部按钮，不响应编辑
                return;
            }
            
            //1.变灰
            [channelBtn setGray:YES];
            
            //2.移动到下排
            [channelBtn removeFromSuperview];
            //channelBtn.tag = [[_unSubsChannelView subviews] count]+kChannelBtnBaseTag;
            [_unSubsChannelView addSubview:channelBtn];
            
            [self layoutScrollView:_subsChannelView];
            [self layoutScrollView:_unSubsChannelView];
            
            //3.取消订阅
            [self unSubscibeChannelAtIndex:index];
        } else {
            //非编辑状态，选中频道
            UIButton *btn = _selectedBtn;
            [btn setSelected:NO];
            [sender setSelected:YES];
            _selectedBtn = sender;
            [self chooseChannelAtIndex:index];
        }
    } else {
        //下排按钮点击，添加订阅
        //1.彩色
        [channelBtn setGray:NO];
        
        //2.移动到上排
        [channelBtn removeFromSuperview];
        [_subsChannelView addSubview:channelBtn];
        [_subsChannelView insertSubview:channelBtn belowSubview:_editBtn];
        
        [self layoutScrollView:_subsChannelView];
        [self layoutScrollView:_unSubsChannelView];
        
        //3.添加订阅
        [self subscribeChannelAtIndex:index];
    }
    
}

- (void)editBtnClicked:(ExButton *)sender
{
    if (![self editable]) {
        return;
    }
    
    BOOL shouldFinished = [sender exSelected];
    self.editing = !shouldFinished;
    [sender setExSelected:!shouldFinished];
    
    //change frame
    CGFloat height = CGRectGetHeight(self.frame);
    if (shouldFinished) {
        height /= 2;
    }
    else {
        height *= 2;
    }
    
    CGRect frame = self.frame;
    frame.size.height = height;
    [UIView animateWithDuration:0.35f
                     animations:^{
                         self.frame = frame;
                     }
                     completion:NULL];
    
    if (shouldFinished) {
        //call delegate
        if (self.delegate && [self.delegate respondsToSelector:@selector(channelListView:didFinishEditingWithSubscribeChannels:)]) {
            NSArray *array = [_subsChannelList safeSubarrayWithRange:NSMakeRange(1, _subsChannelList.count-1)];
            [self.delegate channelListView:self didFinishEditingWithSubscribeChannels:array];
        }
    }
}

#pragma mark - private methods
- (BOOL)editable
{
    BOOL editable = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(channelListViewShouldBeEdited:)]) {
        editable = [self.delegate channelListViewShouldBeEdited:self];
    }
    return editable;
}

- (void)chooseChannelAtIndex:(NSInteger)index
{
    //call delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(channelListView:didSelectedChannel:)]) {
        MVChannel *channel = [_channelList objectAtIndex:index];
        [self.delegate channelListView:self didSelectedChannel:channel];
    }
}

- (void)subscribeChannelAtIndex:(NSInteger)index
{
    MVChannel *channel = [_channelList objectAtIndex:index];
    [_subsChannelList addObject:channel];
}

- (void)unSubscibeChannelAtIndex:(NSInteger)index
{
    MVChannel *channel = [_channelList objectAtIndex:index];
    [_subsChannelList removeObject:channel];
}

- (void)layoutScrollView:(UIScrollView *)scrollView
{
    CGFloat x = kChannelItemWidth/2;
    CGFloat y = CGRectGetHeight(scrollView.frame)/2;
    int i = 0;    
    for (UIView *view in [scrollView subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.center = CGPointMake(x+i*kChannelItemWidth, y);
            ++i;
        }
    }

    scrollView.contentSize = CGSizeMake(kChannelItemWidth*i, CGRectGetHeight(scrollView.frame));
    [scrollView setNeedsDisplay];
}

@end
