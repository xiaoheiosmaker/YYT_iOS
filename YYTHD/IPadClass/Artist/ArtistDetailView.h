//
//  ArtistDetailView.h
//  YYTHD
//
//  Created by ssj on 13-10-29.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Nimbus/NIAttributedLabel.h>
@class Artist;
@protocol ArtistDetailViewDelegate;
@interface ArtistDetailView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet NIAttributedLabel *mvCountLabel;
@property (weak, nonatomic) IBOutlet NIAttributedLabel *totalOrderCount;
@property (weak, nonatomic) IBOutlet UIImageView *artistHeadImageView;
@property (weak, nonatomic) IBOutlet UIButton *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
- (IBAction)backgroundClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
- (IBAction)orderBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
- (IBAction)cancelBtnClicked:(id)sender;

@property (weak, nonatomic) id<ArtistDetailViewDelegate>delegate;

+ (CGSize)defaultSize;
+ (instancetype)defaultSizeView;

- (void)setContentWithArtist:(Artist*)artist;

@end


@protocol ArtistDetailViewDelegate <NSObject>
@optional
- (void)artistDetailViewClicked:(ArtistDetailView *)artistDetailView;
- (void)artistOrderClicked:(ArtistDetailView *)artistDetailView;
- (void)artistCancelClicked:(ArtistDetailView *)artistDetailView;

@end
