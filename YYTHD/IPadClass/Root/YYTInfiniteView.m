//
//  YYTInfiniteView.m
//  YYTHD
//
//  Created by 崔海成 on 11/14/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "YYTInfiniteView.h"

@implementation YYTInfiniteView
- (id)init
{
    self = [super init];
    if (self) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.hidesWhenStopped = YES;
        
        NSString *moreContent = @"上拉加载更多";
        UIFont *font = [UIFont systemFontOfSize:17.0];
        CGSize moreContentSize = [moreContent sizeWithFont:font];
        CGRect moreContentRect = CGRectZero;
        moreContentRect.origin = CGPointMake(indicatorView.origin.x + indicatorView.size.width, indicatorView.origin.y);
        moreContentRect.size = moreContentSize;
        UILabel *label = [[UILabel alloc] initWithFrame:moreContentRect];
        
        [self addSubview:indicatorView];
        [self addSubview:label];
        
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}
@end
