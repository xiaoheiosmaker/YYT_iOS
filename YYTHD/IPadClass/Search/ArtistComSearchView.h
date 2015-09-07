//
//  ArtistComSearchView.h
//  YYTHD
//
//  Created by ssj on 13-11-2.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MVSearchCondition;
@protocol ArtistComSearchViewDelegate;

@interface ArtistComSearchView : UIView

- (id)initWithFrame:(CGRect)frame condition:(MVSearchCondition *)condition;

@property (nonatomic, assign) NSInteger itemSpacing;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, readonly) MVSearchCondition *condition;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) id <ArtistComSearchViewDelegate> actionDelegate;

@end

@protocol ArtistComSearchViewDelegate <NSObject>

- (void)conditionViewDidSelectedOption:(ArtistComSearchView *)conditionView;

@optional
- (BOOL)conditionView:(ArtistComSearchView *)conditionView shouldSelectOptionAtIndex:(NSInteger)index;

@end