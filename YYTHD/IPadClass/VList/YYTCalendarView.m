//
//  YYTCalendarView.m
//  YYTHD
//
//  Created by ssj on 13-10-17.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import "YYTCalendarView.h"
#import "GMGridView.h"
#import "MVItemView.h"
#import "CalendarItemView.h"
#import "VListYearItem.h"
#import "VListMonthItem.h"
#import "VListPerioditem.h"

@implementation YYTCalendarView

- (void)awakeFromNib{
//    self.backgroundColor = [UIColor clearColor];
    self.backgrounView.backgroundColor = [UIColor blackColor];
    self.backgrounView.alpha = 0.5;
    [self setUserInteractionEnabled:YES];
    GMGridView *gridView = [[GMGridView alloc] initWithFrame:CGRectMake(15,50, 711, 399)];
//    gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gridView.bounces = NO;
    gridView.backgroundColor = [UIColor clearColor];
    self.gView = gridView;
    [self addSubview:self.gView];
//    self.gView.style = GMGridViewStyleSwap;
    self.gView.itemSpacing = 7;
    int topIntset = 5;
    int sideInset = 5;
    self.gView.minEdgeInsets = UIEdgeInsetsMake(topIntset, sideInset, topIntset, sideInset);
    self.gView.centerGrid = NO;
    self.gView.dataSource = self;
    self.gView.userInteractionEnabled = YES;
    
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}



#pragma mark- GMGridView Delegate

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView{
//    return 12;
    return self.monthArray.count;
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
   
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation{
    return CGSizeMake(155, 123);
}

- (GMGridViewCell*)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index{
    CGSize cellSize = [self GMGridView:gridView
    sizeForItemsInInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    CalendarItemView *itemView;
    if (!cell) {
        cell = [[GMGridViewCell alloc] init];
       
    }
    itemView = [[[NSBundle mainBundle] loadNibNamed:@"CalendarItemView" owner:nil options:nil] lastObject];
    itemView.frame = CGRectMake(0, 0, cellSize.width, cellSize.height);
    cell.contentView = itemView;
    itemView.delegate = self;
    VListMonthItem *vMonthItem = [self.monthArray objectAtIndex:index];
    itemView.monthLabel.text = vMonthItem.monthChn;
    for (int i = 0; i < vMonthItem.periodModels.count; i++) {
        NSDictionary *vPerioditem = [vMonthItem.periodModels objectAtIndex:i];
        switch (i) {
            case 0:
                [itemView.firstBtn setTitle:[NSString stringWithFormat:@"%@期 (%@-%@)",[vPerioditem objectForKey:@"periods"],[vPerioditem objectForKey:@"beginDateText"],[vPerioditem objectForKey:@"endDateText"]] forState:UIControlStateNormal];
                itemView.firstBtn.tag = [[vPerioditem objectForKey:@"dateCode"] integerValue];
                if (itemView.firstBtn.tag == self.currentDateCode) {
                    [itemView.firstBtn setBackgroundImage:IMAGE(@"Calendar_SelectDate") forState:UIControlStateNormal];
                }
                break;
            case 1:
                
                [itemView.secondBtn setTitle:[NSString stringWithFormat:@"%@期 (%@-%@)",[vPerioditem objectForKey:@"periods"],[vPerioditem objectForKey:@"beginDateText"],[vPerioditem objectForKey:@"endDateText"]] forState:UIControlStateNormal];
                itemView.secondBtn.tag = [[vPerioditem objectForKey:@"dateCode"] integerValue];
                if (itemView.secondBtn.tag == self.currentDateCode) {
                    [itemView.secondBtn setBackgroundImage:IMAGE(@"Calendar_SelectDate") forState:UIControlStateNormal];
                }
                break;
            case 2:
                [itemView.thirdBtn setTitle:[NSString stringWithFormat:@"%@期 (%@-%@)",[vPerioditem objectForKey:@"periods"],[vPerioditem objectForKey:@"beginDateText"],[vPerioditem objectForKey:@"endDateText"]] forState:UIControlStateNormal];
                itemView.thirdBtn.tag = [[vPerioditem objectForKey:@"dateCode"] integerValue];
                if (itemView.thirdBtn.tag == self.currentDateCode) {
                    [itemView.thirdBtn setBackgroundImage:IMAGE(@"Calendar_SelectDate") forState:UIControlStateNormal];
                }
                break;
            case 3:
                [itemView.fourthBtn setTitle:[NSString stringWithFormat:@"%@期 (%@-%@)",[vPerioditem objectForKey:@"periods"],[vPerioditem objectForKey:@"beginDateText"],[vPerioditem objectForKey:@"endDateText"]] forState:UIControlStateNormal];
                itemView.fourthBtn.tag = [[vPerioditem objectForKey:@"dateCode"] integerValue];
                if (itemView.fourthBtn.tag == self.currentDateCode) {
                    [itemView.fourthBtn setBackgroundImage:IMAGE(@"Calendar_SelectDate") forState:UIControlStateNormal];
                }
                break;
            case 4:
                [itemView.fifthBtn setTitle:[NSString stringWithFormat:@"%@期 (%@-%@)",[vPerioditem objectForKey:@"periods"],[vPerioditem objectForKey:@"beginDateText"],[vPerioditem objectForKey:@"endDateText"]] forState:UIControlStateNormal];
                itemView.fifthBtn.tag = [[vPerioditem objectForKey:@"dateCode"] integerValue];
                if (itemView.fifthBtn.tag == self.currentDateCode) {
                    [itemView.fifthBtn setBackgroundImage:IMAGE(@"Calendar_SelectDate") forState:UIControlStateNormal];
                }
                break;
                
            default:
                break;
        }
        
    }
    
    
    
    return cell;
}


+ (instancetype)defaultSizeView
{
    CGRect defaultFrame = CGRectZero;
    defaultFrame.size = [self defaultSize];
    
    return [[self alloc] initWithFrame:defaultFrame];
}

+ (CGSize)defaultSize
{
    return CGSizeMake(700, 448);
}

- (void)setContentWithMVItems:(NSArray *)itemArray currentDateCode:(NSInteger)curDateCode{
    
    self.dataArray = [[itemArray reverseObjectEnumerator] allObjects];
    self.currentDateCode = curDateCode;
    VListYearItem *vYearItem = (VListYearItem *)[self.dataArray objectAtIndex:0];
    currentYear = 0;
    self.nextBtn.enabled = NO;
    self.yearLabel.text = [NSString stringWithFormat:@"%@",vYearItem.year];
    self.monthArray = vYearItem.monthModels;
    [self.gView reloadData];
    self.prveBtn.enabled = YES;
    self.nextBtn.enabled = NO;
}
- (IBAction)prevYearClicked:(id)sender {
    currentYear +=1;
    if (currentYear > self.dataArray.count -1) {
        currentYear -= 1;
        return;
    }
    if (currentYear == self.dataArray.count -1) {
        self.prveBtn.enabled = NO;
        self.nextBtn.enabled = YES;
    }else{
        self.prveBtn.enabled = YES;
        self.nextBtn.enabled = YES;
    }
    
    VListYearItem *vYearItem = (VListYearItem *)[self.dataArray objectAtIndex:currentYear];
    self.monthArray = vYearItem.monthModels;
    self.yearLabel.text = [NSString stringWithFormat:@"%@",vYearItem.year];
    [self.gView reloadData];

}

- (IBAction)NextYearClicked:(id)sender {
    currentYear -= 1;
    if (currentYear < 0) {
        currentYear += 1;
        return;
    }
    if (currentYear == 0) {
        self.prveBtn.enabled = YES;
        self.nextBtn.enabled = NO;
    }else{
        self.prveBtn.enabled = YES;
        self.nextBtn.enabled = YES;
    }
    VListYearItem *vYearItem = (VListYearItem *)[self.dataArray objectAtIndex:currentYear];
    self.monthArray = vYearItem.monthModels;
    self.yearLabel.text = [NSString stringWithFormat:@"%@",vYearItem.year];
    [self.gView reloadData];
}
- (IBAction)closeClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarClose)]) {
        [self.delegate calendarClose];
    }
    [self show:YES];
}

- (void)show:(BOOL)show{
    self.hidden = show;
}

- (void)calendarItemViewBtnClick:(NSInteger)dateCode{
    self.currentDateCode = dateCode;
    [self.gView reloadData];
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarDate:)]) {
        [self.delegate calendarDate:dateCode];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
