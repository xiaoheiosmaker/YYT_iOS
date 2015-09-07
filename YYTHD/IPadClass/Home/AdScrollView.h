//
//  NewsFocalView.h
//  IphoneCDCM
//
//  Created by kin shin on 11-11-1.
//  Copyright 2011 espnstar.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "CustomPageControl.h"

#define Height_FocalImageView 400
#define Height_FocalPageControl 50

@protocol AdScrollViewDelegate;

@interface AdScrollView : UIView<UIScrollViewDelegate> {
	UIScrollView *_scrollView;
	UIPageControl *_pageControl;
	UILabel *_title;
	
	NSTimer *_secondTimer;
	int _pageTotal;
    
    UIView *_indicatorView;
}

@property (nonatomic, weak) id<AdScrollViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *focals;

-(void)timerBegin;

- (void)invalidateTimer;
- (void)resetAdScrollView:(NSArray *)data;


@end


@protocol AdScrollViewDelegate<NSObject>


@required
- (void)adScrollViewClickedAtIndex:(int)index;

@end
