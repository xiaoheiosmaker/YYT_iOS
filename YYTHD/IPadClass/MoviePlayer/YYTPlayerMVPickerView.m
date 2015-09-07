//
//  YYTMVPickerView.m
//  YYTHD
//
//  Created by IAN on 13-11-11.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTPlayerMVPickerView.h"
#import "MVPickerItemView.h"
#import "MVItem.h"
#import <GMGridView/GMGridView.h>
#import <GMGridViewLayoutStrategies.h>

#pragma mark - PickerTagBtn
@interface PickerTagBtn : UIControl
{
    UIImageView *_arrowImageView;
    UIImageView *_titleImageView;
    BOOL _upsideDown;
}

- (void)rotateArrowUpsideDown:(BOOL)upsideDown;
- (BOOL)arrowIsUpsideDown;

@end

@implementation PickerTagBtn

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        imageView.image = [UIImage imageNamed:@"player_picker_tagBg"];
        [self addSubview:imageView];
        
        CGFloat centerX = CGRectGetWidth(frame)/2;
        CGFloat centerY = CGRectGetHeight(frame)/2;
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        imageView.highlightedImage = [UIImage imageNamed:@"arrow_h"];
        imageView.center = CGPointMake(23, centerY+1);
        [self addSubview:imageView];
        _arrowImageView = imageView;
        _upsideDown = NO;
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player_picker_title"]];
        imageView.highlightedImage = [UIImage imageNamed:@"player_picker_title_h"];
        imageView.center = CGPointMake(centerX, centerY);
        [self addSubview:imageView];
        _titleImageView = imageView;
    }
    return self;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _arrowImageView.highlighted = YES;
    _titleImageView.highlighted = YES;
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _arrowImageView.highlighted = NO;
    _titleImageView.highlighted = NO;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    _arrowImageView.highlighted = NO;
    _titleImageView.highlighted = NO;
}

- (void)rotateArrowUpsideDown:(BOOL)rotate
{
    _upsideDown = rotate;
    CGFloat angle = 0;
    if (rotate) {
        angle = M_PI;
    }
    _arrowImageView.transform = CGAffineTransformMakeRotation(angle);
}

- (BOOL)arrowIsUpsideDown
{
   return _upsideDown;
}

@end


#pragma mark - YYTPlayerMVPickerView
@interface YYTPlayerMVPickerView ()<GMGridViewDataSource,GMGridViewActionDelegate>
{
    NSInteger _playMarkIndex;
}
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) PickerTagBtn *tagBtn;
@property (nonatomic, strong) GMGridView *gridView;

@property (nonatomic, assign) BOOL gridShown;

@end


@implementation YYTPlayerMVPickerView

- (instancetype)initWithMVItems:(NSArray *)itemsArray
{
    CGFloat height = [MVPickerItemView defaultSize].height+45;
    CGRect frame = CGRectMake(0, 0, 1024, height);
    return [self initWithFrame:frame];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *contentView = [[UIView alloc] initWithFrame:self.bounds];
        
        PickerTagBtn *btn = [[PickerTagBtn alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)-200, 0, 117, 30)];
        [btn addTarget:self action:@selector(tagBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [contentView addSubview:btn];
        self.tagBtn = btn;
        
        GMGridView *gridView = [[GMGridView alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-31)];
        //gridView.style = GMGridViewStylePush;
        gridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutHorizontal];
        gridView.dataSource = self;
        gridView.sortingDelegate = nil;
        gridView.actionDelegate = self;
        gridView.centerGrid = NO;
        
        gridView.itemSpacing = 5;
        gridView.minEdgeInsets = UIEdgeInsetsMake(8, 10, 0, 10);
        gridView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [contentView addSubview:gridView];
        self.gridView = gridView;
        self.gridShown = YES;
        
        [self addSubview:contentView];
        self.contentView = contentView;
        
        self.clipsToBounds = YES;
        
        _playMarkIndex = -1;
    }
    return self;
}

- (void)setMVList:(NSArray *)itemsArray
{
    self.items = itemsArray;
    [self.gridView reloadData];
}

- (void)tagBtnClicked:(id)sender
{
    BOOL hiden = [sender isSelected];
    if (hiden) {
        [self showGrid];
    } else {
        [self hideGrid];
    }
    
    [sender setSelected:!hiden];
}

- (void)showGrid
{
    if (self.gridShown) {
        return;
    }
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.35f
                     animations:^{
                         [self.tagBtn rotateArrowUpsideDown:NO];
                         self.contentView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         self.gridShown = YES;
                     }];
}

- (void)hideGrid
{
    if (!self.gridShown) {
        return;
    }
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = CGRectGetHeight(self.frame)-CGRectGetHeight(self.tagBtn.frame);
    [UIView animateWithDuration:0.35f
                     animations:^{
                         [self.tagBtn rotateArrowUpsideDown:YES];
                         self.contentView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         self.gridShown = NO;
                     }];
}

- (void)showPlayMarkAtIndex:(NSInteger)index
{
    if (_playMarkIndex != index) {
        [self setPlayMarkHidden:YES atIndex:_playMarkIndex];
        [self setPlayMarkHidden:NO atIndex:index];
        _playMarkIndex = index;
    }
    
    [self scrollToItemAtIndex:index];
}

- (void)setPlayMarkHidden:(BOOL)hidden atIndex:(NSInteger)index
{
    if (index >= 0 && index < [self.items count]) {
        //GMGridViewCell *gridCell = [self.gridView cellForItemAtIndex:index];
        GMGridViewCell *gridCell = [self getCellAtIndex:index];
        MVPickerItemView *itemView = (MVPickerItemView *)gridCell.contentView;
        [itemView setPlayMarkHidden:hidden];
    }
}

//GMGridView 有BUG，有时候会取不到
- (GMGridViewCell *)getCellAtIndex:(NSInteger)index
{
    NSArray *subViews = [self.gridView subviews];
    __block id cell = nil;
    [subViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[GMGridViewCell class]]){
            UIView *view = [obj contentView];
            if (view.tag == index) {
                cell = obj;
                *stop = YES;
            }
        }
    }];
    
    return cell;
}

- (void)scrollToItemAtIndex:(NSInteger)index
{
    [self.gridView scrollToObjectAtIndex:index atScrollPosition:GMGridViewScrollPositionNone animated:YES];
}

- (void)setScrollDelegate:(id<UIScrollViewDelegate>)scrollDelegate
{
    if (scrollDelegate != _scrollDelegate) {
        _scrollDelegate = scrollDelegate;
        self.gridView.delegate = scrollDelegate;
    }
}

#pragma mark -
#pragma mark GMGridViewDataSource
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return self.items.count;
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return [MVPickerItemView defaultSize];
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    if (!cell) {
        cell = [[GMGridViewCell alloc] init];
        
        MVPickerItemView *itemView = [MVPickerItemView defaultSizeView];
        cell.contentView = itemView;
    }
    
    MVItem *item = [self.items objectAtIndex:index];
    
    MVPickerItemView *itemView = (MVPickerItemView *)cell.contentView;
    [itemView setContentWithMVItem:item];
    itemView.tag = index;
    if (index == _playMarkIndex) {
        [itemView setPlayMarkHidden:NO];
    }
    else {
        [itemView setPlayMarkHidden:YES];
    }
    
    return cell;
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return NO;
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectMVItemAtIndex:)]) {
        //MVItem *item = [self.items objectAtIndex:position];
        [self.delegate pickerView:self didSelectMVItemAtIndex:position];
    }
}

@end
