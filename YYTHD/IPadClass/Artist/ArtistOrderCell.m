//
//  ArtistOrderCell.m
//  YYTHD
//
//  Created by ssj on 13-10-31.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "ArtistOrderCell.h"
#import "Artist.h"

@implementation ArtistOrderCell

- (void)awakeFromNib{
    [self.comSearchBtn setImage:IMAGE(@"Artist_Com_Search_Sel") forState:UIControlStateHighlighted|UIControlStateSelected];
    UIImage *image = [UIImage imageNamed:@"ArtistOrder_BackGroundView"];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.backgroundImageView.image = [image resizableImageWithCapInsets:edgeInsets];
    self.allArtistLabel.textColor = [UIColor yytGrayColor];
    self.artistSuggestLabel.textColor = [UIColor yytGrayColor];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)artistChangeBtnClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(changeArtist)]) {
        [_delegate changeArtist];
    }
}
- (IBAction)comSearchBtnClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(comSearchArtist)]) {
        [_delegate comSearchArtist];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetScrollView:(NSArray *)artistArray
{
    if ([artistArray count] > 0) {
        
        for(UIView *v in self.backgrounScrollView.subviews){
            if ([v isKindOfClass:[ArtistOrderView class]]) {
                [v removeFromSuperview];
            }
        }
        
        __block int scrollViewWidth = 0;
        [artistArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Artist *art = (Artist *)obj;
            ArtistOrderView *artist = [[[NSBundle mainBundle] loadNibNamed:@"ArtistOrderView" owner:self options:nil] lastObject];
            artist.delegate = self;
            artist.frame = CGRectMake(170*idx, 0, 170, 192);
            artist.backgroundColor = [UIColor clearColor];
            artist.tag = idx + kArtistTagBegin;
            [artist setContentWithAtist:obj];
            [self.backgrounScrollView addSubview:artist];
            if ([art.sub boolValue]) {
                artist.orderBtn.hidden = YES;
                artist.cancelBtn.hidden = NO;
            }else{
                artist.orderBtn.hidden = NO;
                artist.cancelBtn.hidden = YES;
            }
        }];
        scrollViewWidth = 170 * artistArray.count;
        
        [self.backgrounScrollView setContentSize:CGSizeMake(scrollViewWidth, self.backgrounScrollView.frame.size.height - 10 - 3)];
    }
    
}

#pragma mark - artistOrderView delegate
- (void)artistOrderViewClicked:(ArtistOrderView *)artistOrderView{
    if (_delegate && [_delegate respondsToSelector:@selector(clickArtistView:)]) {
        [_delegate clickArtistView:artistOrderView];
    }
}

- (void)orderArtist:(ArtistOrderView *)artistOrderView{
    if (_delegate && [_delegate respondsToSelector:@selector(clickOrderArtist:)]) {
        [_delegate clickOrderArtist:artistOrderView];
    }
}

- (void)cancelOrderArtist:(ArtistOrderView *)artistOrderView{
    if (_delegate && [_delegate respondsToSelector:@selector(clickCancelArtist:)]) {
        [_delegate clickCancelArtist:artistOrderView];
    }
}
@end
