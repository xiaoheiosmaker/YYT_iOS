//
//  VViewController.h
//  YYTHD
//
//  Created by sunsujun on 13-10-15.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MVItemView.h"
#import "CalendarItemView.h"
#import "YYTCalendarView.h"
#import "YYTMoviePlayerViewController.h"
#import "YYTActivityIndicatorView.h"

#define IMAGE(name) [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", name]]

@interface VViewController : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MVItemViewDelegate,YYTCalendarViewDelegate,YYTActivitySubViewDelegate>{
    UITableView *listTableView;
    YYTCalendarView *calendar;
    int currentPlayIndex;
    YYTMoviePlayerViewController *playViewController;
    BOOL isFirstClick;
    YYTActivityIndicatorView *indicatorView;
    CGFloat topEdge;
}
@property BOOL isMoviePlayStarted;
@property (assign, nonatomic) NSInteger curDateCode;
@property (weak, nonatomic) IBOutlet UIImageView *desBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *jsBtn;
@property (weak, nonatomic) IBOutlet UIButton *spBtn;
@property (weak, nonatomic) IBOutlet UIButton *koreaBtn;
@property (weak, nonatomic) IBOutlet UIButton *eaBtn;
@property (weak, nonatomic) IBOutlet UIButton *gtBtn;
@property (weak, nonatomic) IBOutlet UIButton *mlBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *calendarBtn;
@property (weak, nonatomic) IBOutlet UIButton *prveBtn;
@property (nonatomic,copy)NSString *currentArea;
@property (weak, nonatomic) IBOutlet UILabel *dateCodeLabel;
@property (weak, nonatomic) IBOutlet UITextView *videoDescriptionView;
@property (nonatomic, strong) NSMutableArray *playlistArray;
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailPicView;
@property (weak, nonatomic) IBOutlet UIImageView *tabImageView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

- (id)initWithCodeDate:(NSString *)codeDate area:(NSString *)area;
- (void)refresh;

@end
