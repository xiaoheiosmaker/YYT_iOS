//
//  HomeMVItemView.h
//  YYTHD
//
//  Created by IAN on 13-12-18.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Artist;

@protocol HomeMVItemViewDelegate;

@interface HomeMVItemView : UIView

@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UILabel *titleLabel;

@property (nonatomic, weak) id <HomeMVItemViewDelegate> delegate;
@property (nonatomic, readonly) MVItem *mvItem;

- (void)setContentWithMVItem:(MVItem *)item;

+ (CGSize)defaultSize;
+ (instancetype)defaultSizeView;

@end


@protocol HomeMVItemViewDelegate <NSObject>

@optional

- (void)homeMVItemViewDidClickedImage:(HomeMVItemView *)mvItemView;
- (void)homeMVItemViewDidClickedAddBtn:(HomeMVItemView *)mvItemView;
- (void)homeMVItemVIew:(HomeMVItemView *)mvItemView didClickedArtist:(Artist *)artist;

@end