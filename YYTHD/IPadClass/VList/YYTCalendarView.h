

#import <UIKit/UIKit.h>
#import "CalendarItemView.h"
@protocol YYTCalendarViewDelegate;
@class GMGridView;
@interface YYTCalendarView : UIView<GMGridViewDataSource,CalendarItemViewDelegate>{
    int currentYear;
}

@property (weak, nonatomic) IBOutlet UIImageView *backgrounView;
@property (nonatomic, strong) GMGridView *gView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *monthArray;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) id<YYTCalendarViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *prveBtn;
@property (assign, nonatomic) NSInteger currentDateCode;

- (void)setContentWithMVItems:(NSArray *)itemArray currentDateCode:(NSInteger)curDateCode;
- (void)show:(BOOL)show;

+ (CGSize)defaultSize;
+ (instancetype)defaultSizeView;

@end
@protocol YYTCalendarViewDelegate <NSObject>

@required
- (void)calendarDate:(NSInteger)dateCode;

@optional

- (void)calendarClose;


@end
