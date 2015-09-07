//
//  PullToRefreshView.h
//  YYTHD
//
//  Created by ssj on 13-12-13.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullToRefreshView : UIView{
}

+ (CGSize)defaultSize;
+ (instancetype)defaultSizeView;

//- (UIView *)setCustomViewForState:(SVPullToRefreshState)state;
+ (UIView *)setCustomViewForState:(SVPullToRefreshState)state;
+ (UIView *)setCustomViewWaiteForState:(SVPullToRefreshState)state;
@end
