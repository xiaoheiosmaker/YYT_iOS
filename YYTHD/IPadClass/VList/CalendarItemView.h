//
//  CallendarItemView.h
//  YYTHD
//
//  Created by ssj on 13-10-17.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YYTUILabel;
@protocol CalendarItemViewDelegate;
@interface CalendarItemView : UIView
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourthBtn;
@property (weak, nonatomic) IBOutlet UIButton *fifthBtn;
@property(nonatomic, weak)id<CalendarItemViewDelegate> delegate;


@end

@protocol CalendarItemViewDelegate <NSObject>

@required
- (void)calendarItemViewBtnClick:(NSInteger)dataCode;


@end
