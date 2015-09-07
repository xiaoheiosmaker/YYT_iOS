//
//  ArtistOrderView.h
//  YYTHD
//
//  Created by ssj on 13-10-31.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Artist;
@protocol ArtistOrderViewDelegate;
@interface ArtistOrderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headBackGround;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UIButton *backgroundBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) id <ArtistOrderViewDelegate> delegate;

- (void)setContentWithAtist:(Artist*)artist;
+ (instancetype)defaultSizeView;
+ (CGSize)defaultSize;
@end


@protocol ArtistOrderViewDelegate <NSObject>

- (void)artistOrderViewClicked:(ArtistOrderView *)artistOrderView;
- (void)cancelOrderArtist:(ArtistOrderView *)artistOrderView;
- (void)orderArtist:(ArtistOrderView *)artistOrderView;

@end