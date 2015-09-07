//
//  NewsFocalView.m
//  IphoneCDCM
//
//  Created by kin shin on 11-11-1.
//  Copyright 2011 espnstar.com.cn. All rights reserved.
//

#import "AdScrollView.h"

#import "UIButton+WebCache.h"
#import "MVItem.h"
#import "FontPageItem.h"
//#import "TransferTouchImageView.h"

#define AdWidth IPHONE_HEIGHT

#define kTagBgView 301

@implementation AdScrollView

@synthesize delegate;
@synthesize focals;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		
		CGRect rectScrollView = CGRectMake(0, 0, AdWidth, Height_FocalImageView);
		_scrollView = [[UIScrollView alloc] initWithFrame:rectScrollView];
		_scrollView.delegate = self;
		[_scrollView setCanCancelContentTouches:NO];
		_scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
		_scrollView.clipsToBounds = YES;
		_scrollView.pagingEnabled = YES;
		_scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
		[self addSubview:_scrollView];
        
        TTDINFO(@"---%@",NSStringFromCGRect(frame));
        
        
        //底部滚动条
        UIView *indicatorBgView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_FocalImageView-3, AdWidth, 3)];
        indicatorBgView.backgroundColor = COLORA(157, 157, 155, 0.2);
        //indicatorBgView.backgroundColor = COLOR(157, 157, 155);
        [self addSubview:indicatorBgView];
        
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_FocalImageView-3, 10, 3)];
        _indicatorView.backgroundColor = COLOR(103, 215, 255);
        [self addSubview:_indicatorView];
        
		
		UIView *controlView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_FocalImageView-Height_FocalPageControl, AdWidth, Height_FocalPageControl)];
		//controlView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        controlView.backgroundColor = [UIColor clearColor];
		[self addSubview:controlView];
		
		
        /*
        //增加点点 
        _pageControl = [[CustomPageControl alloc] initWithFrame:CGRectMake(0, 20, AdWidth, 20) ];
        _pageControl.backgroundColor = [UIColor blackColor];  //设置背景颜色 不设置默认是黑色 
        _pageControl.numberOfPages = 0;
        _pageControl.currentPage = 0;
        _pageControl.otherColour = [UIColor whiteColor];    //其他点的颜色 
        _pageControl.currentColor = [UIColor colorWithRed:29/255.0 green:133/255.0 blue:194/255.0 alpha:1.0];  //当前点的颜色 
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.controlSize = 10;  //点的大小 
        //_pageControl.controlSpacing = 20;  //点的间距 
        */
        
		_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 20, AdWidth, 5)];
		_pageControl.backgroundColor = [UIColor clearColor];
		[_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        
		[controlView addSubview:_pageControl];
        _pageControl.hidden = YES;
		
		_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, 20)];
		_title.backgroundColor = [UIColor clearColor];
		_title.font = [UIFont systemFontOfSize:13];
		_title.textColor = [UIColor whiteColor];
		_title.textAlignment = UITextAlignmentCenter;
        _title.hidden = YES;
		[controlView addSubview:_title];
		
		focals = [[NSMutableArray alloc] initWithCapacity:3];
        
        
        UIImageView *im = [[UIImageView alloc] initWithFrame:frame];
        im.tag = 441;
        im.image = [UIImage imageNamed:@"def_ad.png"];
        [self addSubview:im];
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:frame];
        bgView.tag = kTagBgView;
        bgView.userInteractionEnabled = NO;
        bgView.image = [UIImage imageNamed:@"adscroll_bg.png"];
        //bgView.hidden = YES;
        [self addSubview:bgView];
        
    }
    return self;
}


- (void)invalidateTimer
{
	[_secondTimer invalidate];
	_secondTimer = nil;
}

- (void)btnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(adScrollViewClickedAtIndex:)]) {
        [self.delegate adScrollViewClickedAtIndex:[sender tag]];
    }
}

//kTagBgView
- (void)resetAdScrollView:(NSArray *)data
{
    [self viewWithTag:441].hidden = YES;
    
	[self invalidateTimer];
	for(UIView *v in _scrollView.subviews){
		if ([v isKindOfClass:[UIButton class]]) {
			[v removeFromSuperview];
		}
	}
	[self.focals removeAllObjects];
    
    self.focals = [NSMutableArray arrayWithArray:data];
    
    if ([data count] > 0) {
        CGRect rect1 = _indicatorView.frame;
        CGFloat wi = IPHONE_HEIGHT/[data count];
        TTDINFO(@"wiwi:%f", wi);
        rect1.size.width = IPHONE_HEIGHT/[data count];
        _indicatorView.frame = rect1;
    }
	
	CGRect rect = _scrollView.frame;
	int count = 0;
	_pageTotal = 0;
    
    for(FontPageItem *item in data)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = count;
        btn.frame = rect;
        NSURL *url = item.posterPic;
        //[];
        [btn setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"def_ad.png"]];
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];

        [_scrollView addSubview:btn];
        rect.origin.x += rect.size.width;
        _pageTotal++;
        count++;
    }
    
	[_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width*_pageTotal, _scrollView.frame.size.height)];
	_pageControl.numberOfPages = _pageTotal;
    _pageControl.currentPage = 0;
	
	FontPageItem *item = [data objectAtIndex:0];
	_title.text = item.title;
	
    //[self viewWithTag:kTagBgView].hidden = NO;
    
	[self timerBegin];
    
}

#pragma mark -
#pragma mark Actions

- (void)resetCurrentPage
{
	CGFloat pageWidth = _scrollView.frame.size.width;
	
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	if (page != _pageControl.currentPage ) {
        if(page < _pageControl.numberOfPages && page > -1)
        {
            _pageControl.currentPage = page;
            
            CGRect rect = _indicatorView.frame;
            rect.origin.x = page*rect.size.width;
            _indicatorView.frame = rect;
            
            //TTDINFO(@"当前page:%d",page);
            FontPageItem *item = [self.focals objectAtIndex:page];
            _title.text = item.title;
        }
		
		//_title.text = [NSString stringWithFormat:@"测试标题:%d",page];
	}
}

- (void)changePageTo:(int)aPage
{
	CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * aPage;
    [_scrollView setContentOffset:frame.origin animated:YES];
    
//    [UIView animateWithDuration:0.5 animations:^{
//        [_scrollView setContentOffset:frame.origin];
//        //[self.homePageScrollView setContentOffset:CGPointMake([UIScreen mainScreen].applicationFrame.size.width * currentScrollPage, 0)];
//    } completion:^(BOOL finished) {
//        if (finished) {
//            //[self setVideoInfo];
//        }
//    }];
    
}

- (void)changePage:(id)sender {
	//TTDINFO(@"changePage");
    int page = _pageControl.currentPage;
    [self changePageTo:page];
}


#pragma mark ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
	[self resetCurrentPage];
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[self timerBegin];
}

#pragma mark -
#pragma mark Timer

-(void)timerBegin
{

	if (_pageTotal < 2) {
		return;
	}
	_secondTimer = [NSTimer scheduledTimerWithTimeInterval: 5
											 target: self
										   selector: @selector(updateTime:)
										   userInfo: nil
											repeats: YES];
}


-(void)updateTime:(NSTimer *)timer
{
	//TTDINFO(@"updateTime");
	int nextPage = _pageControl.currentPage + 1;
	if (nextPage >= _pageControl.numberOfPages) {
		nextPage = 0;
	}
	[self changePageTo:nextPage];
}


@end
