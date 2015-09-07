//
//  MVChannelListView.h
//  YYTHD
//
//  Created by IAN on 13-10-18.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MVChannel;
@protocol MVChannelListViewDelegate;


@interface MVChannelChooseView : UIView

@property (nonatomic, assign) id <MVChannelListViewDelegate> delegate;
@property (nonatomic, assign)BOOL editing;
- (NSArray *)selectedChannelArray;

- (id)initWithFrame:(CGRect)frame channelList:(NSArray *)array;

@end


@protocol MVChannelListViewDelegate <NSObject>

@optional
//询问代理是否可以编辑列表
- (BOOL)channelListViewShouldBeEdited:(MVChannelChooseView *)channelListView;

//选中某个频道
- (void)channelListView:(MVChannelChooseView *)channelListView didSelectedChannel:(MVChannel *)channel;

//结束编辑，保存数组
- (void)channelListView:(MVChannelChooseView *)channelListView didFinishEditingWithSubscribeChannels:(NSArray *)channels;

@end