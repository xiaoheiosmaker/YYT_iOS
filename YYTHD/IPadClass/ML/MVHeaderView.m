//
//  MVHeaderView.m
//  YYTHD
//
//  Created by 崔海成 on 12/16/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "MVHeaderView.h"
@interface MVHeaderView()
@property (nonatomic, weak)UILabel *amountLabel;
@end

@implementation MVHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setAmountOfMV:(NSUInteger)amountOfMV
{
    self.amountLabel.text = [@(amountOfMV) stringValue];
}

- (void)setup
{
    UIFont *font = [UIFont systemFontOfSize:15.0];
    NSString *prefixText = @"这个悦单里共有 ";
    NSString *amountText = @"80";   // 最大数据作为边界值
    NSString *suffixText = @" 首MV";
    CGSize prefixSize;
    CGSize amountSize;
    CGSize suffixSize;
    if ([SystemSupport versionPriorTo7]) {
        prefixSize = [prefixText sizeWithFont:font];
        amountSize = [amountText sizeWithFont:font];
        suffixSize = [suffixText sizeWithFont:font];
    }
    else {
        NSDictionary *dictionary = @{NSFontAttributeName:font};
        prefixSize = [prefixText sizeWithAttributes:dictionary];
        amountSize = [amountText sizeWithAttributes:dictionary];
        suffixSize = [suffixText sizeWithAttributes:dictionary];
    }
    CGRect frame = CGRectMake(0, 0, prefixSize.width, prefixSize.height);
    UILabel *prefixLabel = [[UILabel alloc] initWithFrame:frame];
    prefixLabel.textColor = [UIColor yytDarkGrayColor];
    prefixLabel.backgroundColor = [UIColor clearColor];
    prefixLabel.font = font;
    prefixLabel.text = prefixText;
    frame = CGRectMake(frame.origin.x + frame.size.width, 0, amountSize.width, amountSize.height);
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:frame];
    amountLabel.textColor = [UIColor yytGreenColor];
    amountLabel.backgroundColor = [UIColor clearColor];
    amountLabel.font = font;
    amountLabel.textAlignment = NSTextAlignmentCenter;
    amountLabel.text = @"";     // 获取真实数据后修改
    frame = CGRectMake(frame.origin.x + frame.size.width, 0, suffixSize.width, suffixSize.height);
    UILabel *suffixLabel = [[UILabel alloc] initWithFrame:frame];
    suffixLabel.textColor = [UIColor yytDarkGrayColor];
    suffixLabel.backgroundColor = [UIColor clearColor];
    suffixLabel.font = font;
    suffixLabel.text = suffixText;
    CGFloat horizontalGap = 6.0;
    frame = CGRectMake(0, 0, frame.origin.x + frame.size.width, frame.size.height + horizontalGap);
    self.frame = frame;
    [self addSubview:prefixLabel];
    [self addSubview:amountLabel];
    [self addSubview:suffixLabel];
    self.amountLabel = amountLabel;
}

@end
