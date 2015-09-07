//
//  HomeMVItemView.m
//  YYTHD
//
//  Created by IAN on 13-12-18.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "HomeMVItemView.h"
#import "MVItem.h"
#import "Artist.h"

static const CGFloat FontSize = 12;

@interface HomeMVItemView () <UIGestureRecognizerDelegate>
{
    UIView *_artistsView;
    UIButton *_addBtn;
}

@property (nonatomic, strong) MVItem *mvItem;

@end


@implementation HomeMVItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.autoresizingMask  = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:imageView];
        _imageView = imageView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-73, CGRectGetWidth(frame), 73)];
        UIImage *shadow = [UIImage imageNamed:@"home_itemShadow"];
        infoView.backgroundColor = [UIColor colorWithPatternImage:shadow];
        [self addSubview:infoView];
        
        CGFloat x = 8;
        CGFloat y = 33;
        CGFloat add_x = CGRectGetWidth(frame) - 42;
        CGFloat width = add_x - x;
        //title
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 18)];
        label.textColor = [UIColor whiteColor];
        //label.contentMode = UIViewContentModeTopLeft;
        label.backgroundColor = [UIColor clearColor];
        [infoView addSubview:label];
        _titleLabel = label;
        _titleLabel.font = [UIFont systemFontOfSize:FontSize];
        
        //artists
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y+18, width, 20)];
        [infoView addSubview:view];
        _artistsView = view;
        
        //add-Btn
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(add_x, y, 40, 40);
        [btn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"add_white"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"add_h"] forState:UIControlStateHighlighted];
        [infoView addSubview:btn];
        _addBtn = btn;
    }
    return self;
}

+ (instancetype)defaultSizeView
{
    CGRect defaultFrame = CGRectZero;
    defaultFrame.size = [self defaultSize];
    
    return [[self alloc] initWithFrame:defaultFrame];
}

+ (CGSize)defaultSize
{
    return CGSizeMake(340, 190);
}

- (void)setContentWithMVItem:(MVItem *)item
{
    self.mvItem = item;
    self.titleLabel.text = item.title;
    [self setupArtistView:item.artists];
    
    UIImageView *imageView = _imageView;
    [imageView setImageWithURL:item.largeImageURL placeholderImage:nil];
    /*
    imageView.alpha = 0.0f;
    [UIView animateWithDuration:0.5 animations:^{
        loadingIndicator.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [loadingIndicator stopAnimating];
            [loadingIndicator removeFromSuperview];
            loadingIndicator = nil;
        }
    }];
     
    [UIView animateWithDuration:1.0f animations:^{
        imageView.alpha = 1.0;
    }];*/
}

- (void)setupArtistView:(NSArray *)artists
{
    //clear prev btns
    [[_artistsView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //setup btns
    int x = 0;
    int y = 0;
    
    CGFloat boundX = CGRectGetWidth(_artistsView.bounds);
    CGFloat boundY = CGRectGetHeight(_artistsView.bounds);
    
    UIFont *font = [UIFont systemFontOfSize:FontSize];
    
    NSInteger i = 0;
    for (Artist *art in artists) {
        NSString *artName = art.name;
        CGSize btnSize = [artName sizeWithFont:font forWidth:boundX lineBreakMode:NSLineBreakByClipping];
        y = (boundY-btnSize.height)/2;
        CGRect btnFrame = CGRectMake(x, y, btnSize.width, btnSize.height);
        
        if (CGRectGetMaxX(btnFrame)>boundX) {
            //超出显示范围，不处理
            break;
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = btnFrame;
        btn.titleLabel.font = font;
        [btn setTitle:art.name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor yytGreenColor] forState:UIControlStateNormal];
        
        btn.tag = i++;
        [btn addTarget:self action:@selector(artistBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_artistsView addSubview:btn];
        
        x = CGRectGetMaxX(btn.frame)+3;
    }
    
}

- (void)tapAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeMVItemViewDidClickedImage:)]) {
        [self.delegate homeMVItemViewDidClickedImage:self];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = touch.view;
    if ([view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    return YES;
}

- (void)artistBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeMVItemVIew:didClickedArtist:)]) {
        NSInteger index = [sender tag];
        Artist *art = [self.mvItem.artists objectAtIndex:index];
        [self.delegate homeMVItemVIew:self didClickedArtist:art];
    }
}

- (void)addBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeMVItemViewDidClickedAddBtn:)]) {
        [self.delegate homeMVItemViewDidClickedAddBtn:self];
    }
}

@end
