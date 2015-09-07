//
//  MVCell.m
//  YYTHD
//
//  Created by 崔海成 on 12/13/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "MVCell.h"
#import "UIColor+Generator.h"

const int MVCellHeight = 147;

@interface MVCell()

@property (nonatomic, weak) UIImageView *coverImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *artistLabel;
@property (nonatomic, weak) UILabel *descriptionLabel;
@property (nonatomic, weak) UIButton *joinButton;
@property (nonatomic, weak) UIImageView *selectImageView;
@property (nonatomic, weak) UIImageView *borderImageView;

@end

@implementation MVCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor yytBackgroundColor];
        self.selectedBackgroundView = [[UIView alloc] init];
        
        CGRect frame;
        UIImage *image;
        UIImageView *imageView;
        UIFont *font;
        UILabel *label;
        // set background image
        image = [UIImage imageNamed:@"mv_background_horizontal"];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        image = [image resizableImageWithCapInsets:edgeInsets];
        imageView = [[UIImageView alloc] initWithImage:image];
        frame = CGRectMake(0, 0, imageView.size.width, MVCellHeight);
        UIView *backgroundView = [[UIView alloc] initWithFrame:frame];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [backgroundView addSubview:imageView];
        self.backgroundView = backgroundView;
        
        frame = CGRectMake(4, 3, 242, 136);
        imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:imageView];
        self.coverImageView = imageView;
        
        image = [UIImage imageNamed:@"cell_select_border"];
        frame = CGRectMake(7, 52, image.size.width, image.size.height);
        imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = image;
        imageView.hidden = YES;
        [self.contentView addSubview:imageView];
        self.borderImageView = imageView;
        image = [UIImage imageNamed:@"cell_select"];
        frame = CGRectMake(self.borderImageView.origin.x + 2, self.borderImageView.origin.y + 2, image.size.width, image.size.height);
        imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = image;
        imageView.hidden = YES;
        [self.contentView addSubview:imageView];
        self.selectImageView = imageView;
        
        frame = CGRectMake(252, 19, 201, 21);
        font = [UIFont systemFontOfSize:12.0];
        label = [[UILabel alloc] initWithFrame:frame];
        label.font = font;
        label.textColor = [UIColor yytDarkGrayColor];
        [self.contentView addSubview:label];
        self.titleLabel = label;
        
        frame = CGRectMake(252, 38, 201, 21);
        label = [[UILabel alloc] initWithFrame:frame];
        label.font = font;
        label.textColor = [UIColor yytGreenColor];
        [self.contentView addSubview:label];
        self.artistLabel = label;
        
        frame = CGRectMake(252, 58, 207, 54);
        label = [[UILabel alloc] initWithFrame:frame];
        label.font = font;
        label.textColor = [UIColor yytTextViewColor];
        label.lineBreakMode = UILineBreakModeClip;
        label.numberOfLines = 3;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:label];
        self.descriptionLabel = label;
        
        image = [UIImage imageNamed:@"add"];
        frame = CGRectMake(450, 52, image.size.width, image.size.height);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        button.hidden = self.editing;
        [button setImage:image forState:UIControlStateNormal];
        image = [UIImage imageNamed:@"add_h"];
        [button setImage:image forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(joinToML:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        self.joinButton = button;
    }
    return self;
}

- (void)setItem:(MVItem *)item
{
    _item = item;
    [self.coverImageView cancelCurrentImageLoad];
    self.coverImageView.image = nil;
    self.titleLabel.text = @"";
    self.artistLabel.text = @"";
    self.descriptionLabel.text = @"";
    self.joinButton.hidden = YES;
    
    if (item) {
        [self.coverImageView setImageWithURL:item.coverImageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        }];
        self.titleLabel.text = item.title;
        self.artistLabel.text = item.artistName;
        self.descriptionLabel.text = item.describ;
        self.joinButton.hidden = NO;
    }
}

- (void)joinToML:(id)sender
{
    NSString *selector = NSStringFromSelector(_cmd);
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    SEL newSelector = NSSelectorFromString(selector);
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    if ([self.controller respondsToSelector:newSelector]) {
        // 忽略此警告
        [self.controller performSelector:newSelector withObject:sender withObject:indexPath];
    }
}

#pragma mark - override methods
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (self.editing) {
        self.selectImageView.hidden = !selected;
    }
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    if (state == UITableViewCellStateEditingMask) {
        self.selectImageView.hidden = YES;
        self.borderImageView.hidden = NO;
        self.joinButton.hidden = YES;
    }
    else if (state == UITableViewCellStateDefaultMask) {
        self.selectImageView.hidden = YES;
        self.borderImageView.hidden = YES;
        self.joinButton.hidden = NO;
    }
}

@end
