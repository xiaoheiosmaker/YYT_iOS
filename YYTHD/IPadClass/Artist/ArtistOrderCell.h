//
//  ArtistOrderCell.h
//  YYTHD
//
//  Created by ssj on 13-10-31.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtistOrderView.h"
@protocol ArtistOrderCellDelegate;
#define kArtistTagBegin 200
#define kBtnOptionBegin 100
#define kartistSpaceX 0
@interface ArtistOrderCell : UITableViewCell<ArtistOrderViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *backgrounScrollView;
@property (weak, nonatomic) IBOutlet UIButton *artistChange;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *comSearchBtn;
@property (weak, nonatomic) id <ArtistOrderCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *artistSuggestLabel;
@property (weak, nonatomic) IBOutlet UILabel *allArtistLabel;
- (void)resetScrollView:(NSArray *)artistArray;
@end

@protocol ArtistOrderCellDelegate <NSObject>
@optional

- (void)clickArtistView:(ArtistOrderView *)artistOrderView;

- (void)clickOrderArtist:(ArtistOrderView *)artistOrderView;

- (void)clickCancelArtist:(ArtistOrderView *)artistOrderView;

- (void)changeArtist;

- (void)comSearchArtist;

@end