//
//  PlayHistroyCell.h
//  YYTHD
//
//  Created by IAN on 13-11-30.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PlayHistroyCellStyle) {
    PlayHistroyCellStyleDefault,
    PlayHistroyCellStyleSquareImage,
};

@interface PlayHistroyCell : UITableViewCell

@property (nonatomic, readonly) UIImageView *coverImageView;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *artistLabel;

- (id)initWithStyle:(PlayHistroyCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
