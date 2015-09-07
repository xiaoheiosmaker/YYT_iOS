//
//  ArtistScrollerCell.h
//  YYTHD
//
//  Created by ssj on 13-10-26.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtistShowView.h"
#define kArtistTagBegin 200
#define kBtnOptionBegin 100
#define kartistSpaceX 0
@protocol ArtistScrollerCellDelegate;
@interface ArtistScrollerCell : UITableViewCell<ArtistShowViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollerView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) id <ArtistScrollerCellDelegate> delegate;
- (void)resetScrollView:(NSArray *)artistArray;
@end


@protocol ArtistScrollerCellDelegate <NSObject>

- (void)artistViewClicked:(NSInteger)index;

@end