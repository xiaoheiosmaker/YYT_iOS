//
//  ArtistScrollerCell.m
//  YYTHD
//
//  Created by ssj on 13-10-26.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "ArtistScrollerCell.h"
#import "ArtistShowView.h"
#import "Artist.h"

@implementation ArtistScrollerCell

- (void)awakeFromNib{
    self.backScrollerView.pagingEnabled = NO;
    self.backScrollerView.bounces = YES;
    self.backScrollerView.showsHorizontalScrollIndicator = NO;
    self.backScrollerView.showsVerticalScrollIndicator = NO;
    UIImage *image = [UIImage imageNamed:@"ArtistOrder_BackGroundView"];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.backgroundView.image = [image resizableImageWithCapInsets:edgeInsets];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.backScrollerView setPagingEnabled:YES];
        self.backScrollerView.userInteractionEnabled = YES;
        self.backScrollerView.clipsToBounds = NO;
    }
    return self;
}

- (void)resetScrollView:(NSArray *)artistArray
{
    if ([artistArray count] > 0) {
        
        for(UIView *v in self.backScrollerView.subviews){
            if ([v isKindOfClass:[ArtistShowView class]]) {
                [v removeFromSuperview];
            }
        }
        
        __block int scrollViewWidth = 0;
        [artistArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            ArtistShowView *artist = [[[NSBundle mainBundle] loadNibNamed:@"ArtistShowView" owner:self options:nil] lastObject];
            artist.delegate = self;
            artist.frame = CGRectMake(170*idx, 0, 170, 170);
            artist.backgroundColor = [UIColor clearColor];
            artist.backgroundButton.tag =idx + kArtistTagBegin;
            [artist setContentWithAtist:obj];
            
            [self.backScrollerView addSubview:artist];
        }];
        scrollViewWidth = 170 * artistArray.count;
        
        [self.backScrollerView setContentSize:CGSizeMake(scrollViewWidth, self.backScrollerView.frame.size.height - 10 - 3)];
    }else{
        for(UIView *v in self.backScrollerView.subviews){
            if ([v isKindOfClass:[ArtistShowView class]]) {
                [v removeFromSuperview];
            }
        }
    }
   
}
#pragma mark - artistShowView delegate
-(void)artistShowViewClicked:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(artistViewClicked:)]) {
        [self.delegate artistViewClicked:index];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{

}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

}

@end
