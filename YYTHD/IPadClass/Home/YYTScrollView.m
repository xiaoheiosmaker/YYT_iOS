//
//  YYTScrollView.m
//  YYTHD
//
//  Created by ssj on 13-12-23.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTScrollView.h"
#import "FontPageItem.h"
#import "PageDetaiView.h"

@implementation YYTScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
        self.imageArray = [[NSArray alloc] init];
    }
    return self;
}
- (void)awakeFromNib
{
    [self setup];
}

- (void)setup{

    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    CGRect rect = self.bounds;
    rect.origin.y = rect.size.height - 30;
    rect.size.height = 30;
    _pageControl = [[UIPageControl alloc] initWithFrame:rect];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.currentPage = 0;
    [_pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];
}

- (void)setContentViewWithItems:(NSArray *)imageArray{
    [self stopCycle];
    for (UIView *imageView in self.scrollView.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            [imageView removeFromSuperview];
        }
    }
    if (imageArray && imageArray.count == 0) {
        return;
    }else{
        self.pageControl.numberOfPages = [imageArray count];
        self.imageArray = imageArray;
        for (int i = 0; i < imageArray.count; i++) {
            FontPageItem *pageItem  = [imageArray objectAtIndex:i];
            UIImageView *pageView = [self setContentViewWithPageItem:pageItem];
            pageView.userInteractionEnabled = YES;
            pageView.left = (i + 1) * self.scrollView.width;
            [self.scrollView addSubview:pageView];
            
            UITapGestureRecognizer *handleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [pageView addGestureRecognizer:handleTap];
        }
        
        FontPageItem *pageItem = [imageArray lastObject];
        UIImageView *pageView = [self setContentViewWithPageItem:pageItem];
        pageView.left = 0;
        [self.scrollView addSubview:pageView];
        
        pageItem = [imageArray objectAtIndex:0];
        pageView = [self setContentViewWithPageItem:pageItem];
        pageView.left = self.scrollView.width * (imageArray.count + 1);
        [self.scrollView addSubview:pageView];
        
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.width * (imageArray.count + 2), self.scrollView.height)];
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.width, 0, self.scrollView.width, self.scrollView.height) animated:NO];
        [self startCycle];
    }
}

- (void)handleTap:(UIGestureRecognizer *)handleTap{
//    NSLog(@"tap == %d",_pageControl.currentPage);
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_pageControl.currentPage];
    }
}

- (UIImageView *)setContentViewWithPageItem:(FontPageItem *)pageItem{
    UIImageView *pageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
    __weak YYTScrollView *weakSelf = self;
    __weak UIImageView *imageView = pageView;
//    [pageView setImageWithURL:pageItem.posterPic placeholderImage:nil];
    [pageView setImageWithURL:pageItem.posterPic placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        CGRect frame = weakSelf.scrollView.bounds;
        UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_ shadow"]];
        CGPoint center = shadow.center;
        center.y = CGRectGetHeight(frame)-center.y;
        shadow.center = center;
        [imageView addSubview:shadow];
        PageDetaiView *pageDetailView = [[PageDetaiView alloc] initWithFrame:CGRectMake(10, 340, 260, 125)];
        [pageDetailView setContentWithFontPageItem:pageItem];
        [imageView addSubview:pageDetailView];
    }];
    return pageView;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pagewidth/([self.imageArray count]+2))/pagewidth)+1;
    page --;
    self.pageControl.currentPage = page;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self stopCycle];
    scrollDragingCount++;
    NSString *eventName = [NSString stringWithFormat:@"滑动%d次",scrollDragingCount];
    if (scrollDragingCount<10) {
        [MobClick event:@"HomePage" label:eventName];
    }
//添加曝光事件
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[self startCycle];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int currentPage = floor((self.scrollView.contentOffset.x - pagewidth/ ([self.imageArray count]+2)) / pagewidth) + 1;
    if (currentPage==0)
    {
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.width * [self.imageArray count],0,self.scrollView.width,self.scrollView.height) animated:NO];
    }
    else if (currentPage==([self.imageArray count]+1))
    {
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.width,0,self.scrollView.width,self.scrollView.height) animated:NO];
    }
}

- (void)startCycle{
    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
}

- (void)stopCycle{
    [timer invalidate];
}
- (void)turnPage
{
    int page = self.pageControl.currentPage;
    CATransition *transtion = [CATransition animation];
    transtion.duration = 0.5;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transtion setType:kCATransitionPush];
    [transtion setSubtype:kCATransitionFromRight];
    [_scrollView.layer addAnimation:transtion forKey:@"animationKey"];
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.width*(page+1),0,self.scrollView.width,self.scrollView.height) animated:NO];
//    可以添加曝光事件
}

- (void)runTimePage{
    int page = self.pageControl.currentPage;
    page++;
    page = page > self.imageArray.count - 1? 0 : page ;
    self.pageControl.currentPage = page;
    [self turnPage];
}


- (void)reloadData{
    
}

@end
