//
//  MVChannelButton.h
//  YYTHD
//
//  Created by IAN on 13-10-21.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MVChannel;

@interface MVChannelButton : UIButton

+ (MVChannelButton *)channelButton;

- (void)setValueWithMVChannel:(MVChannel *)channel;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, getter = isGray, assign) BOOL gray;

@end
