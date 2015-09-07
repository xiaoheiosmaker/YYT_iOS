//
//  YYTMVPickerView.h
//  YYTHD
//
//  Created by IAN on 13-11-11.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YYTPlayerMVPickerDelegate;
@interface YYTPlayerMVPickerView : UIView

- (instancetype)initWithMVItems:(NSArray *)itemsArray;

@property (nonatomic, weak) id<YYTPlayerMVPickerDelegate> delegate;
@property (nonatomic, weak) id<UIScrollViewDelegate>scrollDelegate;
@property (nonatomic, readonly) BOOL gridShown;

- (void)setMVList:(NSArray *)itemsArray;
- (void)showGrid;
- (void)hideGrid;

- (void)showPlayMarkAtIndex:(NSInteger)index;
- (void)scrollToItemAtIndex:(NSInteger)index;

@end


@protocol YYTPlayerMVPickerDelegate <NSObject>

- (void)pickerView:(YYTPlayerMVPickerView *)pickerView didSelectMVItemAtIndex:(NSUInteger)index;

@end