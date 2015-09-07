//
//  MLOutlineView.m
//  YYTHD
//
//  Created by 崔海成 on 12/18/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "MLOutlineView.h"
#import "MLItem.h"
#import "MLPosterView.h"
#import "IconLabel.h"
#import "GCPlaceholderTextView.h"
#import "BlockView.h"
#import "UIColor+Generator.h"

@interface MLOutlineView () <UITextViewDelegate>
{
    __weak MLPosterView *posterView;
    __weak UIButton *changeCoverBtn;
    __weak GCPlaceholderTextView *titleTextView;
    __weak IconLabel *playLabel;
    __weak IconLabel *favoriteLabel;
    __weak UIButton *playBtn;
    __weak UIButton *favoriteBtn;
    __weak UIButton *shareBtn;
    __weak GCPlaceholderTextView *describtionTextView;
    __weak UIView *editCoverPanel;
}
@end

@implementation MLOutlineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frame = CGRectMake(0, 0, 496, 290);
        BlockView *blockView = [[BlockView alloc] initWithFrame:frame];
        
        MLPosterView *pview = [[MLPosterView alloc] init];
        pview.titleLabel.hidden = YES;
        pview.origin = CGPointMake(8, 7);
        [blockView addSubview:pview];
        posterView = pview;
        
        editCoverPanel = [self setupChangeCoverPanel];
        editCoverPanel.origin = CGPointMake(50, 104);
        [blockView addSubview:editCoverPanel];
        
        CGFloat nextX = 252.0;
        frame = CGRectMake(nextX, 8, 232, 48);
        UIFont *font = [UIFont systemFontOfSize:14];
        GCPlaceholderTextView *title = [[GCPlaceholderTextView alloc] initWithFrame:frame];
        title.font = font;
        title.textColor = [UIColor yytDarkGrayColor];
        title.editable = NO;
        title.delegate = self;
        [blockView addSubview:title];
        titleTextView = title;
        
        IconLabel *iconLabel = [[IconLabel alloc] init];
        iconLabel.iconImageName = @"miniPlayIcon";
        iconLabel.origin = CGPointMake(nextX, 53);
        [blockView addSubview:iconLabel];
        playLabel = iconLabel;
        
        iconLabel = [[IconLabel alloc] init];
        iconLabel.iconImageName = @"miniFavoriteIcon2";
        iconLabel.origin = CGPointMake(nextX, 77);
        [blockView addSubview:iconLabel];
        favoriteLabel = iconLabel;
        
        CGFloat gap = 4;
        frame = CGRectMake(342, 108, 50, 50);
        UIButton *button = [self createButtonUseFrame:frame
                            normalImageName:@"ml_detail_play"
                       highlightedImageName:@"ml_detail_play_h"
                                     action:@selector(play:)];
        [blockView addSubview:button];
        playBtn = button;
        
        frame.origin.y += gap + button.height;
        button = [self createButtonUseFrame:frame normalImageName:@"MV_Detail_Collect" highlightedImageName:@"MV_Detail_Collect_Sel" action:@selector(addToFavorite:)];
        [blockView addSubview:button];
        favoriteBtn = button;
        
        frame.origin.y += gap + button.height;
        button = [self createButtonUseFrame:frame
                            normalImageName:@"MV_Detail_Share"
                       highlightedImageName:@"MV_Detail_Share_Sel"
                                     action:@selector(share:)];
        [blockView addSubview:button];
        shareBtn = button;
        [self addSubview:blockView];
        
        CGFloat border = 8;
        frame = CGRectMake(0, 297, blockView.width, 320);
        blockView = [[BlockView alloc] initWithFrame:frame];
        
        frame = CGRectMake(13, 4, 85, 21);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor yytGrayColor];
        label.text = @"悦单描述";
        [blockView addSubview:label];
        
        CGFloat lineHeight = [SystemSupport versionPriorTo7] ? 1 : 0.5;
        frame = CGRectMake(1, 26, blockView.width - 2, lineHeight);
        UIView *lineView = [[UIView alloc] initWithFrame:frame];
        lineView.backgroundColor = [UIColor yytLineColor];
        [blockView addSubview:lineView];
        
        frame = CGRectMake(border, lineView.origin.y + border, blockView.width - 2 * border, blockView.height - lineView.origin.y - 2 * border);
        GCPlaceholderTextView *describtion = [[GCPlaceholderTextView alloc] initWithFrame:frame];
        describtion.font = [UIFont systemFontOfSize:12];
        describtion.textColor = [UIColor yytDarkGrayColor];
        describtion.editable = NO;
        describtion.delegate = self;
        [blockView addSubview:describtion];
        describtionTextView = describtion;
        
        [self addSubview:blockView];
    }
    return self;
}

- (UIView *)setupChangeCoverPanel
{
    UIView *panel = [[UIView alloc] init];
    UIImage *image = [UIImage imageNamed:@"2btn_background"];
    UIImageView *background = [[UIImageView alloc] initWithImage:image];
    panel.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [panel addSubview:background];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    image = [UIImage imageNamed:@"camera"];
    [button setImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"camera_h"];
    [button setImage:image forState:UIControlStateHighlighted];
    button.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    [button addTarget:self action:@selector(changeCoverUseCamera:) forControlEvents:UIControlEventTouchUpInside];
    float margin = 18;
    button.frame = CGRectMake(margin, (background.height - image.size.height) / 2, image.size.width, image.size.height);
    [panel addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    image = [UIImage imageNamed:@"photo_lib"];
    [button setImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"photo_lib_h"];
    [button setImage:image forState:UIControlStateHighlighted];
    button.frame = CGRectMake(background.width - image.size.width - margin, (background.height - image.size.height) / 2, image.size.width, image.size.height);
    [button addTarget:self action:@selector(changeCoverUsePhotoLib:) forControlEvents:UIControlEventTouchUpInside];
    [panel addSubview:button];
    
    margin = 20;
    float statusBarHeight = [SystemSupport versionPriorTo7] ? 0 : 20;
    panel.origin = CGPointMake(1024 - margin - panel.width, statusBarHeight + kTopBarHeight);
    [self addSubview:panel];
    panel.hidden = YES;
    
    return panel;
}

- (void)setEditing:(BOOL)editing
{
    if (editing == _editing) return;
    _editing = editing;
    titleTextView.editable = editing;
    titleTextView.backgroundColor = editing ? [UIColor yytBackgroundColor] : [UIColor clearColor];
    describtionTextView.editable = editing;
    describtionTextView.backgroundColor = editing ? [UIColor yytBackgroundColor] : [UIColor clearColor];
    describtionTextView.placeholder = editing ? @"请填写悦单描述" : @" "; // 处理描述为空，如果描述一定有内容，可以删除本行
    playLabel.hidden = editing;
    favoriteLabel.hidden = editing;
    playBtn.hidden = editing;
    favoriteBtn.hidden = editing;
    shareBtn.hidden = editing;
    editCoverPanel.hidden = !editing;
}

- (UIButton *)createButtonUseFrame:(CGRect)frame
                   normalImageName:(NSString *)normal
              highlightedImageName:(NSString *)highlighted
                            action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    UIImage *image = [UIImage imageNamed:normal];
    [button setImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:highlighted];
    [button setImage:image forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)setItem:(MLItem *)item
{
    posterView.item = item;
    titleTextView.text = item.title;
    playLabel.text = [NSString stringWithFormat:@"%@次播放", item.totalViews ?: @(0)];
    favoriteLabel.text = [NSString stringWithFormat:@"%@次收藏", item.totalFavorites ?: @(0)];
    describtionTextView.text = item.description;
}

#pragma mark - targetAction methods

- (void)changeCoverUseCamera:(id)sender
{
    SEL selector = @selector(changeCover:useSourceType:);
    if ([self.controller respondsToSelector:selector]) {
        NSNumber *sourceType = [NSNumber numberWithInt:UIImagePickerControllerSourceTypeCamera];
        [self.controller changeCover:sender useSourceType:sourceType];
    }
}

- (void)changeCoverUsePhotoLib:(id)sender
{
    SEL selector = @selector(changeCover:useSourceType:);
    if ([self.controller respondsToSelector:selector]) {
        NSNumber *sourceType = [NSNumber numberWithInt:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.controller changeCover:sender useSourceType:sourceType];
    }
}

- (void)play:(id)sender
{
    if ([self.controller respondsToSelector:@selector(play:)]) {
        [self.controller play:sender];
    }
}

- (void)addToFavorite:(id)sender
{
    if ([self.controller respondsToSelector:@selector(addToFavorite:)]) {
        [self.controller addToFavorite:sender];
    }
}

- (void)share:(id)sender
{
    if ([self.controller respondsToSelector:@selector(share:)]) {
        [self.controller share:sender];
    }
}

#pragma mark - UITextViewDelegate methods

- (void)textViewDidChange:(UITextView *)textView
{
    SEL newSelector = @selector(beModified:property:);
    if ([self.controller respondsToSelector:newSelector]) {
        NSString *original = textView.text;
        NSString *trimed = [original stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        textView.text = trimed;
        NSDictionary *property;
        if (textView == describtionTextView) {
            property = @{@"description": trimed};
        }
        if (textView == titleTextView) {
            property = @{@"title": trimed};
        }
        [self.controller beModified:textView property:property];
    }
}

@end
