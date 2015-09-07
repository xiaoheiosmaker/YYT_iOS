//
//  OPSelectView.m
//  YYTHD
//
//  Created by 崔海成 on 12/19/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "OPSelectView.h"
#import "ShareAssistantController.h"

@implementation OPSelectView

- (id)initWithFrame:(CGRect)frame
{
    // frame width: 329 height: 330
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat border = 10;
        CGRect subFrame = CGRectMake(border, border, 309, 30);
        UIFont *font = [UIFont systemFontOfSize:12];
        UILabel *label = [[UILabel alloc] initWithFrame:subFrame];
        label.font = font;
        label.textColor = [UIColor colorWithWhite:1 alpha:0.5];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"请选择分享到：";
        [self addSubview:label];
        
        CGFloat gap = 10;
        subFrame.origin.y = subFrame.origin.y + subFrame.size.height + gap;
        subFrame.size.height = 46;
        UIButton *button = [self createButtonUseLabel:@"新浪微博" frame:subFrame action:@selector(shareToWeibo:)];
        [self addSubview:button];
        
        subFrame.origin.y = subFrame.origin.y + subFrame.size.height + gap;
        button = [self createButtonUseLabel:@"QQ空间" frame:subFrame action:@selector(shareToQzone:)];
        [self addSubview:button];
        
        subFrame.origin.y = subFrame.origin.y + subFrame.size.height + gap;
        button = [self createButtonUseLabel:@"腾讯微博" frame:subFrame action:@selector(shareToTencent:)];
        [self addSubview:button];
        
        subFrame.origin.y = subFrame.origin.y + subFrame.size.height + gap;
        button = [self createButtonUseLabel:@"人人网" frame:subFrame action:@selector(shareToRenren:)];
        [self addSubview:button];
        
        subFrame.origin.y = subFrame.origin.y + subFrame.size.height + gap;
        button = [self createButtonUseLabel:@"微信朋友圈" frame:subFrame action:@selector(shareToWechatTimeline:)];
        [self addSubview:button];
    }
    return self;
}

- (UIButton * )createButtonUseLabel:(NSString *)label frame:(CGRect)frame action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    UIImage *image = [UIImage imageNamed:@"quality_btn"];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"quality_btn_h"];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button setTitle:label forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)shareToWeibo:(id)sender
{
    SEL selector = @selector(share:to:);
    if ([self.controller respondsToSelector:selector]) {
        [self.controller performSelector:selector
                              withObject:sender
                              withObject:[NSNumber numberWithInt:OP_WEIBO]];
    }
}

- (void)shareToQzone:(id)sender
{
    SEL selector = @selector(share:to:);
    if ([self.controller respondsToSelector:selector]) {
        [self.controller performSelector:selector
                              withObject:sender
                              withObject:[NSNumber numberWithInt:OP_QZONE]];
    }
}

- (void)shareToTencent:(id)sender
{
    SEL selector = @selector(share:to:);
    if ([self.controller respondsToSelector:selector]) {
        [self.controller performSelector:selector
                              withObject:sender
                              withObject:[NSNumber numberWithInt:OP_TENCENT]];
    }
}

- (void)shareToRenren:(id)sender
{
    SEL selector = @selector(share:to:);
    if ([self.controller respondsToSelector:selector]) {
        [self.controller performSelector:selector
                              withObject:sender
                              withObject:[NSNumber numberWithInt:OP_RENREN]];
    }
}

- (void)shareToWechatTimeline:(id)sender
{
    SEL selector = @selector(share:to:);
    if ([self.controller respondsToSelector:selector]) {
        [self.controller performSelector:selector
                              withObject:sender
                              withObject:[NSNumber numberWithInt:OP_WECHATTIMELINE]];
    }
}

@end
