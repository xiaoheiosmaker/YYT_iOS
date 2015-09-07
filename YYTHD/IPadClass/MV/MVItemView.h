//
//  MVItemView.h
//  YYTHD
//
//  Created by IAN on 13-10-11.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MVItem;
@class MVOfVListItem;
@class Artist;

@protocol MVItemViewDelegate;

@interface MVItemView : UIView
{
    UIView *_infoView;
    UIView *_artistsView;
    
    UIImageView *_bgImageView;
}

@property(nonatomic, readonly)UIButton *imageBtn;
@property(nonatomic, readonly)UIView *infoView;
@property(nonatomic, readonly)UILabel *titleLabel;
@property(nonatomic, readonly)UIButton *addBtn;

@property (nonatomic, strong)UIActivityIndicatorView *loadingIndicator;

@property(nonatomic, strong)MVItem *mvItem;
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UIImageView *playingView;
@property(nonatomic, strong)UILabel *rankingLabel;

@property(nonatomic, weak)id<MVItemViewDelegate> delegate;

+ (CGSize)defaultSize;
+ (instancetype)defaultSizeView;

- (void)setContentWithMVItem:(MVItem *)item;
- (void)setContentWithMVOfVListItem:(MVOfVListItem *)item;

@end


@protocol MVItemViewDelegate <NSObject>

@optional

- (void)MVItemViewDidClickedImage:(MVItemView *)mvItemView;
- (void)MVItemViewDidClickedAddBtn:(MVItemView *)mvItemView;
- (void)MVItemVIew:(MVItemView *)mvItemView didClickedArtist:(Artist *)artist;

@end