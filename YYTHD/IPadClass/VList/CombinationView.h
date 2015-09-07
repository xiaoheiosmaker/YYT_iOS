//
//  CombinationView.h
//  YYTHD
//
//  Created by ssj on 13-10-30.
//  Copyright (c) 2013年 btxkenshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CombinationViewDelegate;
@interface CombinationView : UIView
@property (weak, nonatomic) IBOutlet UIButton *music_videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *concertBtn;
@property (weak, nonatomic) IBOutlet UIButton *liveBtn;
@property (weak, nonatomic) IBOutlet UIButton *fan_videoBtn;
@property (weak, nonatomic) IBOutlet UIButton *subtitleBtn;
@property (weak, nonatomic) IBOutlet UIButton *othersBtn;
@property (weak, nonatomic) id <CombinationViewDelegate> delegate;
@end

@protocol CombinationViewDelegate <NSObject>
@optional

- (void)comBtnClicked:(NSString *)condition;

@end