//
//  MVSearchConditionView.h
//  YYTHD
//
//  Created by IAN on 13-10-17.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MVSearchCondition;
@protocol MVSearchConditionActionDelegate;

@interface MVSearchConditionView : UIView

- (id)initWithFrame:(CGRect)frame condition:(MVSearchCondition *)condition;

@property (nonatomic, assign) NSInteger itemSpacing;
@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, readonly) MVSearchCondition *condition;

@property (nonatomic, weak) id <MVSearchConditionActionDelegate> actionDelegate;

@end

@protocol MVSearchConditionActionDelegate <NSObject>

- (void)conditionViewDidSelectedOption:(MVSearchConditionView *)conditionView;

@optional
- (BOOL)conditionView:(MVSearchConditionView *)conditionView shouldSelectOptionAtIndex:(NSInteger)index;

@end