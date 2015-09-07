//
//  YYTScrollView.h
//  YYTHD
//
//  Created by ssj on 13-12-23.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YYTScrollViewDelegate;

@interface YYTScrollView : UIView<UIScrollViewDelegate>{
    NSTimer *timer;
    int scrollDragingCount;
}
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,assign,setter = setDelegate:) id<YYTScrollViewDelegate> delegate;

- (void)reloadData;
- (void)setContentViewWithItems:(NSArray *)imageArray;
- (void)stopCycle;
- (void)startCycle;
@end

@protocol YYTScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(YYTScrollView *)csView atIndex:(NSInteger)index;

@end